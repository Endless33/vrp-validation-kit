#!/usr/bin/env bash

set -Eeuo pipefail
IFS=$'\n\t'
umask 077

readonly SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
readonly LAB_DIR="$(cd -- "${SCRIPT_DIR}/.." && pwd -P)"
readonly CONFIG_DIR="${LAB_DIR}/configs"
readonly COMPOSE_FILE="${LAB_DIR}/compose.yaml"
readonly DEFAULT_CONTRACT_PATH="${LAB_DIR}/expected/invariant-contract.json"

RUN_DIR=""
RUN_ID=""
SCENARIO_ID=""
PROJECT_NAME=""
RUN_STATE="INITIALIZING"
RUN_STARTED_AT_UTC=""
RUN_COMPLETED_AT_UTC=""
RUN_CLOCK_START_SECONDS=0
TIMELINE_START_SECONDS=0
EVENT_SEQUENCE=0
WITNESS_READY=0
CLEANUP_REQUIRED=0
FINALIZED=0
SUBJECT_CID=""

declare -a COMPOSE_BASE=()

usage() {
    printf '%s\n' \
        "Usage:" \
        "  ./scripts/run-scenario.sh configs/<scenario>.yaml"
}

log() {
    printf '[vrp-lab] %s\n' "$*"
}

warn() {
    printf '[vrp-lab] WARNING: %s\n' "$*" >&2
}

die() {
    printf '[vrp-lab] ERROR: %s\n' "$*" >&2
    exit 1
}

require_command() {
    local command_name="$1"

    command -v "${command_name}" >/dev/null 2>&1 ||
        die "Required command is not available: ${command_name}"
}

json_escape() {
    local value="${1-}"

    value="${value//\\/\\\\}"
    value="${value//\"/\\\"}"
    value="${value//$'\n'/\\n}"
    value="${value//$'\r'/\\r}"
    value="${value//$'\t'/\\t}"

    printf '%s' "${value}"
}

string_sha256() {
    printf '%s' "$1" |
        sha256sum |
        awk '{print $1}'
}

validate_image_reference() {
    local reference="$1"

    [[ -n "${reference}" ]] ||
        die "An empty container image reference is not permitted"

    [[ "${reference}" =~ ^[A-Za-z0-9][A-Za-z0-9._/:@+-]*$ ]] ||
        die "Invalid container image reference: ${reference}"
}

require_digest_reference() {
    local reference="$1"

    [[ "${reference}" =~ @sha256:[a-f0-9]{64}$ ]] ||
        die "Digest-qualified image required: ${reference}"
}

ensure_image() {
    local reference="$1"

    if docker image inspect "${reference}" >/dev/null 2>&1; then
        return 0
    fi

    log "Pulling required image: ${reference}"
    docker pull "${reference}" >/dev/null
}

image_id() {
    docker image inspect \
        --format '{{.Id}}' \
        "$1"
}

image_content_digest() {
    local reference="$1"
    local repository_digest

    repository_digest="$(
        docker image inspect \
            --format '{{if .RepoDigests}}{{index .RepoDigests 0}}{{end}}' \
            "${reference}"
    )"

    if [[ -n "${repository_digest}" ]]; then
        printf '%s' "${repository_digest##*@}"
        return 0
    fi

    image_id "${reference}"
}

resolve_config_path() {
    local supplied_path="$1"
    local candidate

    if [[ "${supplied_path}" == /* ]]; then
        candidate="${supplied_path}"
    elif [[ -f "${PWD}/${supplied_path}" ]]; then
        candidate="${PWD}/${supplied_path}"
    else
        candidate="${LAB_DIR}/${supplied_path}"
    fi

    [[ -f "${candidate}" ]] ||
        die "Scenario file does not exist: ${supplied_path}"

    [[ ! -L "${candidate}" ]] ||
        die "Scenario symlinks are not permitted"

    candidate="$(realpath "${candidate}")"

    case "${candidate}" in
        "${CONFIG_DIR}"/*.yaml)
            ;;
        *)
            die "Scenario must be a YAML file inside ${CONFIG_DIR}"
            ;;
    esac

    printf '%s' "${candidate}"
}

yq_read() {
    local expression="$1"

    docker run \
        --rm \
        --network none \
        --read-only \
        --cap-drop ALL \
        --security-opt no-new-privileges:true \
        --tmpfs /tmp:rw,noexec,nosuid,nodev,size=16m \
        --mount "type=bind,source=${CONFIG_PATH},target=/input/scenario.yaml,readonly" \
        "${VRP_LAB_YQ_IMAGE}" \
        -r \
        "${expression}" \
        /input/scenario.yaml
}

validate_integer_range() {
    local field_name="$1"
    local value="$2"
    local minimum="$3"
    local maximum="$4"

    [[ "${value}" =~ ^[0-9]+$ ]] ||
        die "${field_name} must be an integer"

    ((value >= minimum && value <= maximum)) ||
        die "${field_name} must be between ${minimum} and ${maximum}"
}

compose() {
    "${COMPOSE_BASE[@]}" "$@"
}

controller_call() {
    timeout 20s \
        "${COMPOSE_BASE[@]}" \
        --profile tools \
        run \
        --rm \
        --no-deps \
        -T \
        controller \
        "$@"
}

record_event() {
    local event_kind="$1"
    local event_id="$2"
    local target="$3"
    local outcome="$4"
    local observed_at_utc
    local elapsed_seconds

    ((EVENT_SEQUENCE += 1))

    observed_at_utc="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
    elapsed_seconds=$((SECONDS - RUN_CLOCK_START_SECONDS))

    printf \
        '{"schema_version":"vrp-continuity-lab/witness-event-v1","run_id":"%s","scenario_id":"%s","event_sequence":%d,"event_id":"%s","event_kind":"%s","target":"%s","outcome":"%s","observed_at_utc":"%s","run_elapsed_seconds":%d}\n' \
        "$(json_escape "${RUN_ID}")" \
        "$(json_escape "${SCENARIO_ID}")" \
        "${EVENT_SEQUENCE}" \
        "$(json_escape "${event_id}")" \
        "$(json_escape "${event_kind}")" \
        "$(json_escape "${target}")" \
        "$(json_escape "${outcome}")" \
        "$(json_escape "${observed_at_utc}")" \
        "${elapsed_seconds}" \
        >>"${RUN_DIR}/witness/events.jsonl"
}

hash_or_null() {
    local path="$1"
    local digest

    if [[ -f "${path}" && ! -L "${path}" ]]; then
        digest="$(sha256sum "${path}" | awk '{print $1}')"
        printf '"%s"' "${digest}"
    else
        printf 'null'
    fi
}

write_environment() {
    local destination="${RUN_DIR}/witness/environment.json"
    local temporary="${destination}.tmp"

    local host_os
    local host_architecture
    local docker_engine_version
    local docker_compose_version

    host_os="$(uname -s)"
    host_architecture="$(uname -m)"
    docker_engine_version="$(
        docker version --format '{{.Server.Version}}'
    )"
    docker_compose_version="$(
        docker compose version --short
    )"

    cat >"${temporary}" <<EOF
{
  "schema_version": "vrp-continuity-lab/environment-v1",
  "run_id": "$(json_escape "${RUN_ID}")",
  "captured_at_utc": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "host": {
    "operating_system": "$(json_escape "${host_os}")",
    "architecture": "$(json_escape "${host_architecture}")"
  },
  "docker": {
    "engine_version": "$(json_escape "${docker_engine_version}")",
    "compose_version": "$(json_escape "${docker_compose_version}")"
  },
  "images": {
    "subject": {
      "configured_reference_sha256": "$(string_sha256 "${VRP_LAB_SUBJECT_IMAGE}")",
      "image_id": "$(json_escape "$(image_id "${VRP_LAB_SUBJECT_IMAGE}")")",
      "content_digest": "$(json_escape "$(image_content_digest "${VRP_LAB_SUBJECT_IMAGE}")")"
    },
    "origin": {
      "configured_reference_sha256": "$(string_sha256 "${VRP_LAB_ORIGIN_IMAGE}")",
      "image_id": "$(json_escape "$(image_id "${VRP_LAB_ORIGIN_IMAGE}")")",
      "content_digest": "$(json_escape "$(image_content_digest "${VRP_LAB_ORIGIN_IMAGE}")")"
    },
    "fault_engine": {
      "configured_reference_sha256": "$(string_sha256 "${VRP_LAB_FAULT_ENGINE_IMAGE}")",
      "image_id": "$(json_escape "$(image_id "${VRP_LAB_FAULT_ENGINE_IMAGE}")")",
      "content_digest": "$(json_escape "$(image_content_digest "${VRP_LAB_FAULT_ENGINE_IMAGE}")")"
    },
    "relay": {
      "configured_reference_sha256": "$(string_sha256 "${VRP_LAB_RELAY_IMAGE}")",
      "image_id": "$(json_escape "$(image_id "${VRP_LAB_RELAY_IMAGE}")")",
      "content_digest": "$(json_escape "$(image_content_digest "${VRP_LAB_RELAY_IMAGE}")")"
    },
    "controller": {
      "configured_reference_sha256": "$(string_sha256 "${VRP_LAB_CONTROLLER_IMAGE}")",
      "image_id": "$(json_escape "$(image_id "${VRP_LAB_CONTROLLER_IMAGE}")")",
      "content_digest": "$(json_escape "$(image_content_digest "${VRP_LAB_CONTROLLER_IMAGE}")")"
    },
    "yaml_parser": {
      "configured_reference_sha256": "$(string_sha256 "${VRP_LAB_YQ_IMAGE}")",
      "image_id": "$(json_escape "$(image_id "${VRP_LAB_YQ_IMAGE}")")",
      "content_digest": "$(json_escape "$(image_content_digest "${VRP_LAB_YQ_IMAGE}")")"
    }
  }
}
EOF

    mv -- "${temporary}" "${destination}"
}

write_manifest() {
    local execution_exit_code="$1"
    local destination="${RUN_DIR}/manifest.json"
    local temporary="${destination}.tmp"

    cat >"${temporary}" <<EOF
{
  "schema_version": "vrp-continuity-lab/run-manifest-v1",
  "run_id": "$(json_escape "${RUN_ID}")",
  "scenario_id": "$(json_escape "${SCENARIO_ID}")",
  "execution_state": "$(json_escape "${RUN_STATE}")",
  "execution_exit_code": ${execution_exit_code},
  "started_at_utc": "$(json_escape "${RUN_STARTED_AT_UTC}")",
  "completed_at_utc": "$(json_escape "${RUN_COMPLETED_AT_UTC}")",
  "project_name": "$(json_escape "${PROJECT_NAME}")",
  "evidence_format": "public-evidence-v1",
  "verification_required": true,
  "artifacts": {
    "scenario": {
      "path": "input/scenario.yaml",
      "sha256": $(hash_or_null "${RUN_DIR}/input/scenario.yaml")
    },
    "schedule": {
      "path": "input/schedule.tsv",
      "sha256": $(hash_or_null "${RUN_DIR}/input/schedule.tsv")
    },
    "invariant_contract": {
      "path": "input/invariant-contract.json",
      "sha256": $(hash_or_null "${RUN_DIR}/input/invariant-contract.json")
    },
    "environment": {
      "path": "witness/environment.json",
      "sha256": $(hash_or_null "${RUN_DIR}/witness/environment.json")
    },
    "witness_events": {
      "path": "witness/events.jsonl",
      "sha256": $(hash_or_null "${RUN_DIR}/witness/events.jsonl")
    },
    "subject_evidence": {
      "path": "subject/subject-evidence.json",
      "sha256": $(hash_or_null "${RUN_DIR}/subject/subject-evidence.json")
    },
    "subject_events": {
      "path": "subject/subject-events.jsonl",
      "sha256": $(hash_or_null "${RUN_DIR}/subject/subject-events.jsonl")
    }
  }
}
EOF

    mv -- "${temporary}" "${destination}"
}

cleanup_lab() {
    if ((CLEANUP_REQUIRED == 0)); then
        return 0
    fi

    if ! compose \
        --profile subject \
        --profile tools \
        down \
        --remove-orphans \
        --timeout 10 \
        >/dev/null 2>&1; then
        warn "Automatic Compose cleanup did not complete successfully"
    fi

    CLEANUP_REQUIRED=0
}

on_exit() {
    local exit_status=$?

    trap - EXIT INT TERM
    set +e

    if ((exit_status != 0)); then
        RUN_STATE="INCOMPLETE"

        if ((WITNESS_READY == 1)); then
            record_event \
                "run.failed" \
                "run.failed" \
                "runner" \
                "exit-${exit_status}"
        fi
    fi

    if [[ -n "${RUN_DIR}" ]] &&
        ((WITNESS_READY == 1)) &&
        ((FINALIZED == 0)); then
        RUN_COMPLETED_AT_UTC="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
        write_manifest "${exit_status}"
        FINALIZED=1
    fi

    cleanup_lab

    if ((exit_status != 0)); then
        printf '[vrp-lab] RUN_STATE=INCOMPLETE\n' >&2
        printf '[vrp-lab] RUN_DIR=%s\n' "${RUN_DIR}" >&2
    fi

    exit "${exit_status}"
}

wait_for_fault_engine() {
    local timeout_seconds="$1"
    local deadline=$((SECONDS + timeout_seconds))

    until controller_call \
        --max-time 3 \
        "http://fault-engine:8474/version" \
        >/dev/null 2>&1; do
        ((SECONDS < deadline)) ||
            die "Fault-engine control API did not become ready"

        sleep 1
    done
}

create_proxy() {
    local name="$1"
    local listen_address="$2"
    local upstream_address="$3"
    local request_body

    request_body="$(
        printf \
            '{"name":"%s","listen":"%s","upstream":"%s","enabled":true}' \
            "${name}" \
            "${listen_address}" \
            "${upstream_address}"
    )"

    controller_call \
        --max-time 5 \
        --request POST \
        --header "Content-Type: application/json" \
        --data "${request_body}" \
        "http://fault-engine:8474/proxies" \
        >/dev/null
}

path_proxy_name() {
    case "$1" in
        wifi)
            printf '%s' "wifi-path"
            ;;
        mobile)
            printf '%s' "mobile-path"
            ;;
        *)
            die "Unsupported logical path: $1"
            ;;
    esac
}

path_proxy_port() {
    case "$1" in
        wifi)
            printf '%s' "8666"
            ;;
        mobile)
            printf '%s' "8667"
            ;;
        *)
            die "Unsupported logical path: $1"
            ;;
    esac
}

path_is_reachable() {
    local path_id="$1"
    local port

    port="$(path_proxy_port "${path_id}")"

    controller_call \
        --max-time 3 \
        "http://fault-engine:${port}/" \
        >/dev/null 2>&1
}

wait_for_path_reachable() {
    local path_id="$1"
    local timeout_seconds="$2"
    local deadline=$((SECONDS + timeout_seconds))

    until path_is_reachable "${path_id}"; do
        ((SECONDS < deadline)) ||
            die "Logical path did not become reachable: ${path_id}"

        sleep 1
    done
}

set_path_state() {
    local path_id="$1"
    local enabled="$2"
    local witness_event_id="$3"

    local proxy_name
    local listen_address
    local request_body
    local state_word
    local event_kind

    proxy_name="$(path_proxy_name "${path_id}")"

    case "${path_id}" in
        wifi)
            listen_address="0.0.0.0:8666"
            ;;
        mobile)
            listen_address="0.0.0.0:8667"
            ;;
        *)
            die "Unsupported logical path: ${path_id}"
            ;;
    esac

    if [[ "${enabled}" == "true" ]]; then
        state_word="enabled"
    else
        state_word="disabled"
    fi

    request_body="$(
        printf \
            '{"name":"%s","listen":"%s","upstream":"origin:8080","enabled":%s}' \
            "${proxy_name}" \
            "${listen_address}" \
            "${enabled}"
    )"

    controller_call \
        --max-time 5 \
        --request POST \
        --header "Content-Type: application/json" \
        --data "${request_body}" \
        "http://fault-engine:8474/proxies/${proxy_name}" \
        >/dev/null

    if [[ "${enabled}" == "true" ]]; then
        wait_for_path_reachable "${path_id}" 10
    else
        if path_is_reachable "${path_id}"; then
            die "Logical path remained reachable after disable action: ${path_id}"
        fi
    fi

    event_kind="path.${path_id}.${state_word}"

    record_event \
        "${event_kind}" \
        "${witness_event_id}" \
        "${path_id}" \
        "confirmed"
}

subject_is_running() {
    [[ -n "${SUBJECT_CID}" ]] ||
        return 1

    [[ "$(
        docker inspect \
            --format '{{.State.Running}}' \
            "${SUBJECT_CID}" \
            2>/dev/null
    )" == "true" ]]
}

subject_exit_code() {
    docker inspect \
        --format '{{.State.ExitCode}}' \
        "${SUBJECT_CID}"
}

wait_until_timeline_offset() {
    local target_offset="$1"
    local elapsed
    local remaining

    while :; do
        elapsed=$((SECONDS - TIMELINE_START_SECONDS))

        if ((elapsed >= target_offset)); then
            return 0
        fi

        subject_is_running ||
            die "Subject exited before the scheduled scenario completed"

        remaining=$((target_offset - elapsed))

        if ((remaining > 1)); then
            sleep 1
        else
            sleep "${remaining}"
        fi
    done
}

execute_scheduled_event() {
    local event_id="$1"
    local action="$2"
    local target="$3"
    local targets="$4"
    local stimulus_kind="$5"

    local -a path_list=()
    local path_id

    case "${action}" in
        path.disable)
            set_path_state \
                "${target}" \
                "false" \
                "${event_id}"
            ;;

        path.enable)
            set_path_state \
                "${target}" \
                "true" \
                "${event_id}"

            if [[ "${SCENARIO_ID}" == "blackout-recovery" ]]; then
                record_event \
                    "blackout.ended" \
                    "${event_id}.blackout-ended" \
                    "${target}" \
                    "confirmed"
            fi
            ;;

        paths.disable)
            IFS=',' read -r -a path_list <<<"${targets}"

            for path_id in "${path_list[@]}"; do
                set_path_state \
                    "${path_id}" \
                    "false" \
                    "${event_id}.${path_id}"
            done

            record_event \
                "blackout.started" \
                "${event_id}" \
                "all-declared-paths" \
                "confirmed"
            ;;

        paths.enable)
            IFS=',' read -r -a path_list <<<"${targets}"

            for path_id in "${path_list[@]}"; do
                set_path_state \
                    "${path_id}" \
                    "true" \
                    "${event_id}.${path_id}"
            done

            record_event \
                "blackout.ended" \
                "${event_id}" \
                "all-declared-paths" \
                "confirmed"
            ;;

        subject.stimulus)
            record_event \
                "stimulus.${stimulus_kind}.requested" \
                "${event_id}" \
                "subject" \
                "requested"

            if ! timeout "${STIMULUS_TIMEOUT_SECONDS}s" \
                "${COMPOSE_BASE[@]}" \
                --profile subject \
                exec \
                -T \
                subject \
                "${VRP_LAB_SUBJECT_ENTRYPOINT}" \
                stimulus \
                --kind "${stimulus_kind}" \
                --event-id "${event_id}" \
                >/dev/null 2>&1; then
                die "Subject did not accept the public stimulus command: ${event_id}"
            fi

            record_event \
                "stimulus.${stimulus_kind}.delivered" \
                "${event_id}.delivered" \
                "subject" \
                "delivered"
            ;;

        *)
            die "Unsupported scheduled action: ${action}"
            ;;
    esac
}

validate_subject_artifact() {
    local path="$1"
    local maximum_bytes="$2"
    local artifact_name="$3"
    local artifact_size

    [[ -f "${path}" ]] ||
        die "Required subject artifact is missing: ${artifact_name}"

    [[ ! -L "${path}" ]] ||
        die "Subject artifact must not be a symlink: ${artifact_name}"

    artifact_size="$(stat -c '%s' "${path}")"

    ((artifact_size > 0)) ||
        die "Subject artifact is empty: ${artifact_name}"

    ((artifact_size <= maximum_bytes)) ||
        die "Subject artifact exceeds the public size limit: ${artifact_name}"
}

if (($# != 1)); then
    usage
    exit 64
fi

for required_command in \
    docker \
    realpath \
    sha256sum \
    awk \
    stat \
    timeout \
    uname; do
    require_command "${required_command}"
done

docker info >/dev/null 2>&1 ||
    die "Docker daemon is not available"

docker compose version >/dev/null 2>&1 ||
    die "Docker Compose v2 is not available"

readonly CONFIG_PATH="$(resolve_config_path "$1")"

export VRP_LAB_YQ_IMAGE="${
    VRP_LAB_YQ_IMAGE:-mikefarah/yq:4.45.1
}"

validate_image_reference "${VRP_LAB_YQ_IMAGE}"
ensure_image "${VRP_LAB_YQ_IMAGE}"

SCHEMA_VERSION="$(
    yq_read '.schema_version // ""'
)"

[[ "${SCHEMA_VERSION}" == "vrp-continuity-lab/scenario-v1" ]] ||
    die "Unsupported scenario schema version: ${SCHEMA_VERSION}"

SCENARIO_ID="$(
    yq_read '.scenario.id // ""'
)"

[[ "${SCENARIO_ID}" =~ ^[a-z0-9][a-z0-9-]{0,47}$ ]] ||
    die "Invalid public scenario identifier"

DURATION_SECONDS="$(
    yq_read '.execution.duration_seconds // ""'
)"
INFRASTRUCTURE_TIMEOUT_SECONDS="$(
    yq_read '.execution.infrastructure_ready_timeout_seconds // ""'
)"
SUBJECT_READY_TIMEOUT_SECONDS="$(
    yq_read '.execution.subject_ready_timeout_seconds // ""'
)"
STIMULUS_TIMEOUT_SECONDS="$(
    yq_read '.execution.stimulus_delivery_timeout_seconds // 10'
)"
COMPLETION_GRACE_SECONDS="$(
    yq_read '.execution.completion_grace_seconds // ""'
)"
CONTRACT_REFERENCE="$(
    yq_read '.acceptance.contract // ""'
)"

validate_integer_range \
    "execution.duration_seconds" \
    "${DURATION_SECONDS}" \
    10 \
    3600

validate_integer_range \
    "execution.infrastructure_ready_timeout_seconds" \
    "${INFRASTRUCTURE_TIMEOUT_SECONDS}" \
    5 \
    300

validate_integer_range \
    "execution.subject_ready_timeout_seconds" \
    "${SUBJECT_READY_TIMEOUT_SECONDS}" \
    5 \
    300

validate_integer_range \
    "execution.stimulus_delivery_timeout_seconds" \
    "${STIMULUS_TIMEOUT_SECONDS}" \
    1 \
    120

validate_integer_range \
    "execution.completion_grace_seconds" \
    "${COMPLETION_GRACE_SECONDS}" \
    1 \
    120

[[ "${CONTRACT_REFERENCE}" == "../expected/invariant-contract.json" ]] ||
    die "Scenario must reference ../expected/invariant-contract.json"

[[ -f "${DEFAULT_CONTRACT_PATH}" ]] ||
    die "Public invariant contract is missing"

[[ ! -L "${DEFAULT_CONTRACT_PATH}" ]] ||
    die "Invariant-contract symlinks are not permitted"

export VRP_LAB_SUBJECT_IMAGE="${VRP_LAB_SUBJECT_IMAGE:-}"
export VRP_LAB_ORIGIN_IMAGE="${
    VRP_LAB_ORIGIN_IMAGE:-hashicorp/http-echo:1.0.0
}"
export VRP_LAB_FAULT_ENGINE_IMAGE="${
    VRP_LAB_FAULT_ENGINE_IMAGE:-ghcr.io/shopify/toxiproxy:2.12.0
}"
export VRP_LAB_RELAY_IMAGE="${
    VRP_LAB_RELAY_IMAGE:-alpine/socat:1.8.0.0
}"
export VRP_LAB_CONTROLLER_IMAGE="${
    VRP_LAB_CONTROLLER_IMAGE:-curlimages/curl:8.12.1
}"
export VRP_LAB_SUBJECT_ENTRYPOINT="${
    VRP_LAB_SUBJECT_ENTRYPOINT:-/vrp-lab-adapter
}"
export VRP_LAB_SUBJECT_UID="${
    VRP_LAB_SUBJECT_UID:-$(id -u)
}"
export VRP_LAB_SUBJECT_GID="${
    VRP_LAB_SUBJECT_GID:-$(id -g)
}"

for image_reference in \
    "${VRP_LAB_SUBJECT_IMAGE}" \
    "${VRP_LAB_ORIGIN_IMAGE}" \
    "${VRP_LAB_FAULT_ENGINE_IMAGE}" \
    "${VRP_LAB_RELAY_IMAGE}" \
    "${VRP_LAB_CONTROLLER_IMAGE}" \
    "${VRP_LAB_YQ_IMAGE}"; do
    validate_image_reference "${image_reference}"
done

[[ "${VRP_LAB_SUBJECT_ENTRYPOINT}" =~ ^/[A-Za-z0-9._/-]+$ ]] ||
    die "Subject entrypoint must be a safe absolute container path"

[[ "${VRP_LAB_SUBJECT_UID}" =~ ^[0-9]+$ ]] ||
    die "VRP_LAB_SUBJECT_UID must be numeric"

[[ "${VRP_LAB_SUBJECT_GID}" =~ ^[0-9]+$ ]] ||
    die "VRP_LAB_SUBJECT_GID must be numeric"

VRP_LAB_REQUIRE_DIGEST="${VRP_LAB_REQUIRE_DIGEST:-0}"

[[ "${VRP_LAB_REQUIRE_DIGEST}" == "0" ||
    "${VRP_LAB_REQUIRE_DIGEST}" == "1" ]] ||
    die "VRP_LAB_REQUIRE_DIGEST must be 0 or 1"

if [[ "${VRP_LAB_REQUIRE_DIGEST}" == "1" ]]; then
    for image_reference in \
        "${VRP_LAB_SUBJECT_IMAGE}" \
        "${VRP_LAB_ORIGIN_IMAGE}" \
        "${VRP_LAB_FAULT_ENGINE_IMAGE}" \
        "${VRP_LAB_RELAY_IMAGE}" \
        "${VRP_LAB_CONTROLLER_IMAGE}" \
        "${VRP_LAB_YQ_IMAGE}"; do
        require_digest_reference "${image_reference}"
    done
fi

RUN_TIMESTAMP="$(date -u +%Y%m%dt%H%M%Sz)"
RUN_SUFFIX="$(printf '%04x%04x' "${RANDOM}" "${RANDOM}")"
RUN_ID="${SCENARIO_ID}-${RUN_TIMESTAMP}-${RUN_SUFFIX}"
PROJECT_NAME="vrplab-${SCENARIO_ID:0:20}-${RUN_TIMESTAMP}-${RUN_SUFFIX}"

OUTPUT_ROOT="${VRP_LAB_OUTPUT_ROOT:-${LAB_DIR}/out}"

if [[ "${OUTPUT_ROOT}" != /* ]]; then
    OUTPUT_ROOT="${LAB_DIR}/${OUTPUT_ROOT}"
fi

mkdir -p -- "${OUTPUT_ROOT}"
OUTPUT_ROOT="$(cd -- "${OUTPUT_ROOT}" && pwd -P)"

RUN_DIR="${OUTPUT_ROOT}/${RUN_ID}"

mkdir -- "${RUN_DIR}" ||
    die "Run directory already exists: ${RUN_DIR}"

mkdir -p \
    "${RUN_DIR}/input" \
    "${RUN_DIR}/subject" \
    "${RUN_DIR}/witness" \
    "${RUN_DIR}/report"

cp -- "${CONFIG_PATH}" "${RUN_DIR}/input/scenario.yaml"
cp -- "${DEFAULT_CONTRACT_PATH}" \
    "${RUN_DIR}/input/invariant-contract.json"

EVENT_COUNT="$(
    yq_read \
        '((.fault_schedule // []) + (.stimulus_schedule // [])) | length'
)"

validate_integer_range \
    "scheduled event count" \
    "${EVENT_COUNT}" \
    1 \
    32

declare -A SEEN_EVENT_IDS=()
LAST_EVENT_OFFSET=-1

: >"${RUN_DIR}/input/schedule.tsv"

for ((event_index = 0; event_index < EVENT_COUNT; event_index++)); do
    EVENT_OFFSET="$(
        yq_read \
            "((.fault_schedule // []) + (.stimulus_schedule // []))[${event_index}].at_seconds // \"\""
    )"
    EVENT_ID="$(
        yq_read \
            "((.fault_schedule // []) + (.stimulus_schedule // []))[${event_index}].event_id // \"\""
    )"
    EVENT_ACTION="$(
        yq_read \
            "((.fault_schedule // []) + (.stimulus_schedule // []))[${event_index}].action // \"\""
    )"
    EVENT_TARGET="$(
        yq_read \
            "((.fault_schedule // []) + (.stimulus_schedule // []))[${event_index}].target // \"\""
    )"
    EVENT_TARGETS="$(
        yq_read \
            "((((.fault_schedule // []) + (.stimulus_schedule // []))[${event_index}].targets // []) | join(\",\"))"
    )"
    EVENT_KIND="$(
        yq_read \
            "((.fault_schedule // []) + (.stimulus_schedule // []))[${event_index}].kind // \"\""
    )"

    validate_integer_range \
        "event at_seconds" \
        "${EVENT_OFFSET}" \
        0 \
        "$((DURATION_SECONDS - 1))"

    ((EVENT_OFFSET >= LAST_EVENT_OFFSET)) ||
        die "Scheduled events must be ordered by at_seconds"

    LAST_EVENT_OFFSET="${EVENT_OFFSET}"

    [[ "${EVENT_ID}" =~ ^[a-z0-9][a-z0-9._-]{0,63}$ ]] ||
        die "Invalid scheduled event identifier: ${EVENT_ID}"

    [[ -z "${SEEN_EVENT_IDS[${EVENT_ID}]+x}" ]] ||
        die "Duplicate scheduled event identifier: ${EVENT_ID}"

    SEEN_EVENT_IDS["${EVENT_ID}"]=1

    case "${EVENT_ACTION}" in
        path.disable | path.enable)
            [[ "${EVENT_TARGET}" == "wifi" ||
                "${EVENT_TARGET}" == "mobile" ]] ||
                die "Single-path action requires wifi or mobile target"

            [[ -z "${EVENT_TARGETS}" ]] ||
                die "Single-path action must not declare targets"
            ;;

        paths.disable | paths.enable)
            [[ -z "${EVENT_TARGET}" ]] ||
                die "Multi-path action must not declare a singular target"

            [[ "${EVENT_TARGETS}" == "wifi,mobile" ||
                "${EVENT_TARGETS}" == "mobile,wifi" ]] ||
                die "Multi-path action must target wifi and mobile"
            ;;

        subject.stimulus)
            [[ "${EVENT_TARGET}" == "subject" ]] ||
                die "Stimulus action must target subject"

            [[ "${EVENT_KIND}" == "stale-authority" ||
                "${EVENT_KIND}" == "replay" ]] ||
                die "Unsupported public stimulus kind"
            ;;

        *)
            die "Unsupported scheduled action: ${EVENT_ACTION}"
            ;;
    esac

    printf '%s|%s|%s|%s|%s|%s\n' \
        "${EVENT_OFFSET}" \
        "${EVENT_ID}" \
        "${EVENT_ACTION}" \
        "${EVENT_TARGET}" \
        "${EVENT_TARGETS}" \
        "${EVENT_KIND}" \
        >>"${RUN_DIR}/input/schedule.tsv"
done

export VRP_LAB_RUN_ID="${RUN_ID}"
export VRP_LAB_RUN_DURATION_SECONDS="$(
    (
        DURATION_SECONDS + SUBJECT_READY_TIMEOUT_SECONDS
    )
)"
export VRP_LAB_SUBJECT_OUTPUT_DIR="${RUN_DIR}/subject"

COMPOSE_BASE=(
    docker compose
    --project-directory "${LAB_DIR}"
    --file "${COMPOSE_FILE}"
    --project-name "${PROJECT_NAME}"
)

RUN_STARTED_AT_UTC="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
RUN_CLOCK_START_SECONDS="${SECONDS}"

: >"${RUN_DIR}/witness/events.jsonl"
WITNESS_READY=1

trap on_exit EXIT
trap 'exit 130' INT
trap 'exit 143' TERM

for image_reference in \
    "${VRP_LAB_SUBJECT_IMAGE}" \
    "${VRP_LAB_ORIGIN_IMAGE}" \
    "${VRP_LAB_FAULT_ENGINE_IMAGE}" \
    "${VRP_LAB_RELAY_IMAGE}" \
    "${VRP_LAB_CONTROLLER_IMAGE}"; do
    ensure_image "${image_reference}"
done

compose \
    --profile subject \
    --profile tools \
    config \
    --quiet

write_environment

CLEANUP_REQUIRED=1

log "Starting isolated lab infrastructure"

compose up \
    --detach \
    origin \
    fault-engine \
    wifi-gateway \
    mobile-gateway \
    >/dev/null

wait_for_fault_engine "${INFRASTRUCTURE_TIMEOUT_SECONDS}"

create_proxy \
    "wifi-path" \
    "0.0.0.0:8666" \
    "origin:8080"

create_proxy \
    "mobile-path" \
    "0.0.0.0:8667" \
    "origin:8080"

wait_for_path_reachable \
    "wifi" \
    "${INFRASTRUCTURE_TIMEOUT_SECONDS}"

wait_for_path_reachable \
    "mobile" \
    "${INFRASTRUCTURE_TIMEOUT_SECONDS}"

record_event \
    "infrastructure.ready" \
    "infrastructure.ready" \
    "lab" \
    "confirmed"

log "Starting authorized black-box subject"

compose \
    --profile subject \
    up \
    --detach \
    subject \
    >/dev/null

SUBJECT_READY_DEADLINE=$(
    (
        SECONDS + SUBJECT_READY_TIMEOUT_SECONDS
    )
)

while :; do
    SUBJECT_CID="$(
        compose \
            --profile subject \
            ps \
            --quiet \
            subject \
            2>/dev/null ||
            true
    )"

    if [[ -n "${SUBJECT_CID}" ]]; then
        if ! subject_is_running; then
            die "Subject exited before becoming ready"
        fi

        if timeout 5s \
            "${COMPOSE_BASE[@]}" \
            --profile subject \
            exec \
            -T \
            subject \
            "${VRP_LAB_SUBJECT_ENTRYPOINT}" \
            health \
            >/dev/null 2>&1; then
            break
        fi
    fi

    ((SECONDS < SUBJECT_READY_DEADLINE)) ||
        die "Subject did not become ready within the declared timeout"

    sleep 1
done

TIMELINE_START_SECONDS="${SECONDS}"

record_event \
    "subject.ready" \
    "subject.ready" \
    "subject" \
    "confirmed"

while IFS='|' read -r \
    EVENT_OFFSET \
    EVENT_ID \
    EVENT_ACTION \
    EVENT_TARGET \
    EVENT_TARGETS \
    EVENT_KIND; do

    wait_until_timeline_offset "${EVENT_OFFSET}"

    execute_scheduled_event \
        "${EVENT_ID}" \
        "${EVENT_ACTION}" \
        "${EVENT_TARGET}" \
        "${EVENT_TARGETS}" \
        "${EVENT_KIND}"
done <"${RUN_DIR}/input/schedule.tsv"

wait_until_timeline_offset "${DURATION_SECONDS}"

if subject_is_running; then
    compose \
        --profile subject \
        stop \
        --timeout "${COMPLETION_GRACE_SECONDS}" \
        subject \
        >/dev/null
fi

SUBJECT_EXIT_CODE="$(subject_exit_code)"

record_event \
    "subject.completed" \
    "subject.completed" \
    "subject" \
    "exit-${SUBJECT_EXIT_CODE}"

[[ "${SUBJECT_EXIT_CODE}" == "0" ]] ||
    die "Subject exited with status ${SUBJECT_EXIT_CODE}"

validate_subject_artifact \
    "${RUN_DIR}/subject/subject-evidence.json" \
    4194304 \
    "subject-evidence.json"

validate_subject_artifact \
    "${RUN_DIR}/subject/subject-events.jsonl" \
    67108864 \
    "subject-events.jsonl"

RUN_STATE="COMPLETE"

record_event \
    "run.completed" \
    "run.completed" \
    "runner" \
    "evidence-captured"

RUN_COMPLETED_AT_UTC="$(date -u +%Y-%m-%dT%H:%M:%SZ)"

write_manifest 0
FINALIZED=1

cleanup_lab

printf '[vrp-lab] RUN_STATE=COMPLETE\n'
printf '[vrp-lab] RUN_ID=%s\n' "${RUN_ID}"
printf '[vrp-lab] RUN_DIR=%s\n' "${RUN_DIR}"
printf '[vrp-lab] VERIFICATION_REQUIRED=true\n'
printf '[vrp-lab] NEXT_COMMAND=%s/scripts/verify-evidence.sh %s\n' \
    "${LAB_DIR}" \
    "${RUN_DIR}"