#!/usr/bin/env bash

set -euo pipefail

CMD="${1:-run}"

EVIDENCE_DIR="${VRP_LAB_EVIDENCE_DIRECTORY:-/evidence}"
RUN_ID="${VRP_LAB_RUN_ID:-manual}"
EVIDENCE_FORMAT="${VRP_LAB_EVIDENCE_FORMAT:-public-evidence-v1}"
CONTRACT_VERSION="${VRP_LAB_CONTRACT_VERSION:-1}"
RUN_DURATION_SECONDS="${VRP_LAB_RUN_DURATION_SECONDS:-60}"

PRIMARY_ENDPOINT="${VRP_LAB_PRIMARY_ENDPOINT:-http://wifi-gateway:8080}"
ALTERNATE_ENDPOINT="${VRP_LAB_ALTERNATE_ENDPOINT:-http://mobile-gateway:8080}"

SUMMARY_FINAL="${EVIDENCE_DIR}/subject-evidence.json"
EVENTS_FINAL="${EVIDENCE_DIR}/subject-events.jsonl"

SUMMARY_TMP="${EVIDENCE_DIR}/.subject-evidence.json.tmp"
EVENTS_TMP="${EVIDENCE_DIR}/.subject-events.jsonl.tmp"

CONTINUITY_REFERENCE="mock-continuity-${RUN_ID}"

SEQUENCE=0
PROGRESS_COUNT=0
PATH_TRANSITION_COUNT=0
ACCEPTED_MUTATION_COUNT=0
DUPLICATE_ACCEPTED_MUTATION_COUNT=0
STALE_AUTHORITY_REJECTION_COUNT=0
REPLAY_REJECTION_COUNT=0

ACTIVE_PATH="wifi"
STARTED_AT=""

mkdir -p "${EVIDENCE_DIR}"

utc_now() {
    date -u +%Y-%m-%dT%H:%M:%SZ
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

endpoint_reachable() {
    local endpoint="$1"

    curl \
        --silent \
        --show-error \
        --fail \
        --max-time 1 \
        --output /dev/null \
        "${endpoint}" \
        >/dev/null 2>&1
}

next_sequence() {
    SEQUENCE=$((SEQUENCE + 1))
}

emit_event() {
    local event_id="$1"
    local event_kind="$2"
    local path_id="$3"
    local public_verdict="$4"
    local operation_reference="${5:-}"

    local timestamp

    next_sequence
    timestamp="$(utc_now)"

    printf '{' >>"${EVENTS_TMP}"

    printf '"schema_version":"vrp-continuity-lab/subject-event-v1",' \
        >>"${EVENTS_TMP}"

    printf '"run_id":"%s",' \
        "$(json_escape "${RUN_ID}")" \
        >>"${EVENTS_TMP}"

    printf '"event_sequence":%d,' \
        "${SEQUENCE}" \
        >>"${EVENTS_TMP}"

    printf '"event_id":"%s",' \
        "$(json_escape "${event_id}")" \
        >>"${EVENTS_TMP}"

    printf '"event_kind":"%s",' \
        "$(json_escape "${event_kind}")" \
        >>"${EVENTS_TMP}"

    printf '"public_verdict":"%s",' \
        "$(json_escape "${public_verdict}")" \
        >>"${EVENTS_TMP}"

    printf '"observed_at_utc":"%s",' \
        "$(json_escape "${timestamp}")" \
        >>"${EVENTS_TMP}"

    printf '"continuity_reference":"%s"' \
        "$(json_escape "${CONTINUITY_REFERENCE}")" \
        >>"${EVENTS_TMP}"

    if [[ -n "${path_id}" ]]; then
        if [[ "${event_kind}" == "path-transition" ]]; then
            printf ',"logical_path":"%s"' \
                "$(json_escape "${path_id}")" \
                >>"${EVENTS_TMP}"
        else
            printf ',"path_id":"%s"' \
                "$(json_escape "${path_id}")" \
                >>"${EVENTS_TMP}"
        fi
    fi

    if [[ -n "${operation_reference}" ]]; then
        printf ',"public_operation_reference":"%s"' \
            "$(json_escape "${operation_reference}")" \
            >>"${EVENTS_TMP}"
    fi

    printf '}\n' >>"${EVENTS_TMP}"
}

emit_progress() {
    local path="$1"

    PROGRESS_COUNT=$((PROGRESS_COUNT + 1))

    emit_event \
        "mock-progress-${PROGRESS_COUNT}" \
        "progress" \
        "${path}" \
        "succeeded" \
        "mock-operation-${PROGRESS_COUNT}"
}

emit_transition() {
    local from_path="$1"
    local to_path="$2"

    PATH_TRANSITION_COUNT=$((PATH_TRANSITION_COUNT + 1))

    emit_event \
        "mock-transition-${PATH_TRANSITION_COUNT}" \
        "path-transition" \
        "${to_path}" \
        "observed"

    ACTIVE_PATH="${to_path}"
}

write_summary() {
    local completed_at="$1"

    cat >"${SUMMARY_TMP}" <<JSON
{
  "schema_version": "vrp-continuity-lab/subject-evidence-v1",
  "evidence_format": "$(json_escape "${EVIDENCE_FORMAT}")",
  "contract_version": "$(json_escape "${CONTRACT_VERSION}")",
  "run_id": "$(json_escape "${RUN_ID}")",
  "adapter": {
    "public_id": "vrp-subject-mock",
    "version": "1.0.0"
  },
  "started_at_utc": "$(json_escape "${STARTED_AT}")",
  "completed_at_utc": "$(json_escape "${completed_at}")",
  "continuity_reference": "$(json_escape "${CONTINUITY_REFERENCE}")",
  "final_active_path": "$(json_escape "${ACTIVE_PATH}")",
  "completion_state": "complete",
  "public_verdict": "evidence-ready",
  "summary": {
    "successful_progress_event_count": ${PROGRESS_COUNT},
    "path_transition_count": ${PATH_TRANSITION_COUNT},
    "accepted_mutation_count": ${ACCEPTED_MUTATION_COUNT},
    "duplicate_accepted_mutation_count": ${DUPLICATE_ACCEPTED_MUTATION_COUNT},
    "stale_authority_rejection_count": ${STALE_AUTHORITY_REJECTION_COUNT},
    "replay_rejection_count": ${REPLAY_REJECTION_COUNT}
  }
}
JSON
}

publish_evidence() {
    chmod 0644 "${EVENTS_TMP}" "${SUMMARY_TMP}"

    mv -f "${EVENTS_TMP}" "${EVENTS_FINAL}"
    mv -f "${SUMMARY_TMP}" "${SUMMARY_FINAL}"
}

cleanup_temp() {
    rm -f "${EVENTS_TMP}" "${SUMMARY_TMP}"
}

finalize() {
    local rc="${1:-0}"
    local completed_at

    trap - TERM INT EXIT

    completed_at="$(utc_now)"

    emit_event \
        "mock-complete-${SEQUENCE}" \
        "adapter.completed" \
        "${ACTIVE_PATH}" \
        "observed"

    write_summary "${completed_at}"
    publish_evidence

    exit "${rc}"
}

case "${CMD}" in
    health)
        printf 'OK\n'
        exit 0
        ;;

    run)
        trap cleanup_temp EXIT

        STARTED_AT="$(utc_now)"

        : >"${EVENTS_TMP}"

        emit_event \
            "mock-start-001" \
            "adapter.started" \
            "${ACTIVE_PATH}" \
            "observed"

        trap 'finalize 0' TERM INT

        deadline=$((SECONDS + RUN_DURATION_SECONDS))

        while ((SECONDS < deadline)); do
            if [[ "${ACTIVE_PATH}" == "wifi" ]]; then
                if endpoint_reachable "${PRIMARY_ENDPOINT}"; then
                    emit_progress "wifi"
                elif endpoint_reachable "${ALTERNATE_ENDPOINT}"; then
                    emit_transition "wifi" "mobile"
                    emit_progress "mobile"
                fi
            else
                if endpoint_reachable "${ALTERNATE_ENDPOINT}"; then
                    emit_progress "mobile"
                fi
            fi

            sleep 2
        done

        finalize 0
        ;;

    *)
        printf 'unknown command: %s\n' "${CMD}" >&2
        exit 64
        ;;
esac
