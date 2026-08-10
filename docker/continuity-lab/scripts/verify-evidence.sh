#!/usr/bin/env bash

set -Eeuo pipefail
IFS=$'\n\t'
umask 077

readonly SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
readonly LAB_DIR="$(cd -- "${SCRIPT_DIR}/.." && pwd -P)"

RUN_DIR=""
VERIFICATION_OUTPUT=""
OUTPUT_TEMP=""
SCENARIO_JSON_TEMP=""
VERIFIER_PROGRAM_TEMP=""

usage() {
    printf '%s\n' \
        "Usage:" \
        "  ./scripts/verify-evidence.sh out/<run-id>"
}

log() {
    printf '[vrp-lab-verifier] %s\n' "$*"
}

die() {
    printf '[vrp-lab-verifier] ERROR: %s\n' "$*" >&2
    exit 1
}

require_command() {
    command -v "$1" >/dev/null 2>&1 ||
        die "Required command is not available: $1"
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

validate_image_reference() {
    [[ "$1" =~ ^[A-Za-z0-9][A-Za-z0-9._/:@+-]*$ ]] ||
        die "Invalid parser image reference"
}

require_digest_reference() {
    [[ "$1" =~ @sha256:[a-f0-9]{64}$ ]] ||
        die "Digest-qualified parser image required"
}

ensure_image() {
    local reference="$1"

    if docker image inspect "${reference}" >/dev/null 2>&1; then
        return 0
    fi

    log "Pulling required parser image: ${reference}"
    docker pull "${reference}" >/dev/null
}

cleanup_temporary_files() {
    local path

    for path in \
        "${OUTPUT_TEMP:-}" \
        "${SCENARIO_JSON_TEMP:-}" \
        "${VERIFIER_PROGRAM_TEMP:-}"; do
        if [[ -n "${path}" && -f "${path}" ]]; then
            rm -f -- "${path}"
        fi
    done
}

write_incomplete_result() {
    local reason="$1"
    local generated_at_utc

    generated_at_utc="$(date -u +%Y-%m-%dT%H:%M:%SZ)"

    cat >"${OUTPUT_TEMP}" <<EOF
{
  "schema_version": "vrp-continuity-lab/verification-v1",
  "run_id": null,
  "scenario_id": null,
  "verdict": "INCOMPLETE",
  "generated_at_utc": "$(json_escape "${generated_at_utc}")",
  "checks": [
    {
      "invariant_id": "VRP-LAB-EVIDENCE-COMPLETE",
      "status": "INCOMPLETE",
      "message": "$(json_escape "${reason}")"
    }
  ],
  "summary": {
    "pass": 0,
    "fail": 0,
    "incomplete": 1
  }
}
EOF

    mv -f -- "${OUTPUT_TEMP}" "${VERIFICATION_OUTPUT}"

    printf '[vrp-lab-verifier] VERDICT=INCOMPLETE\n'
    printf '[vrp-lab-verifier] RESULT=%s\n' "${VERIFICATION_OUTPUT}"

    exit 2
}

require_artifact() {
    local relative_path="$1"
    local maximum_size="$2"
    local full_path="${RUN_DIR}/${relative_path}"
    local artifact_size

    if [[ ! -f "${full_path}" ]]; then
        write_incomplete_result \
            "Required artifact is missing: ${relative_path}"
    fi

    if [[ -L "${full_path}" ]]; then
        write_incomplete_result \
            "Artifact symlinks are not permitted: ${relative_path}"
    fi

    artifact_size="$(stat -c '%s' "${full_path}")"

    if ((artifact_size == 0)); then
        write_incomplete_result \
            "Required artifact is empty: ${relative_path}"
    fi

    if ((artifact_size > maximum_size)); then
        write_incomplete_result \
            "Artifact exceeds the public size limit: ${relative_path}"
    fi
}

jq_container() {
    docker run \
        --rm \
        --network none \
        --read-only \
        --cap-drop ALL \
        --security-opt no-new-privileges:true \
        --tmpfs /tmp:rw,noexec,nosuid,nodev,size=32m \
        --mount "type=bind,source=${RUN_DIR},target=/evidence,readonly" \
        "${VRP_LAB_JQ_IMAGE}" \
        "$@"
}

yq_scenario_to_json() {
    docker run \
        --rm \
        --network none \
        --read-only \
        --cap-drop ALL \
        --security-opt no-new-privileges:true \
        --tmpfs /tmp:rw,noexec,nosuid,nodev,size=32m \
        --mount "type=bind,source=${RUN_DIR}/input/scenario.yaml,target=/input/scenario.yaml,readonly" \
        "${VRP_LAB_YQ_IMAGE}" \
        -o=json \
        '.' \
        /input/scenario.yaml
}

jq_read() {
    local expression="$1"
    local relative_path="$2"

    jq_container \
        -r \
        "${expression}" \
        "/evidence/${relative_path}"
}

append_hash_mismatch() {
    local artifact_name="$1"

    if [[ -z "${HASH_MISMATCHES}" ]]; then
        HASH_MISMATCHES="${artifact_name}"
    else
        HASH_MISMATCHES="${HASH_MISMATCHES},${artifact_name}"
    fi

    HASH_STATUS="FAIL"
}

verify_manifest_artifact() {
    local manifest_key="$1"
    local expected_relative_path="$2"
    local declared_path
    local declared_digest
    local actual_digest

    declared_path="$(
        jq_read \
            ".artifacts.${manifest_key}.path // \"\"" \
            "manifest.json"
    )"

    declared_digest="$(
        jq_read \
            ".artifacts.${manifest_key}.sha256 // \"\"" \
            "manifest.json"
    )"

    if [[ "${declared_path}" != "${expected_relative_path}" ]]; then
        append_hash_mismatch "${manifest_key}"
        return 0
    fi

    if [[ ! "${declared_digest}" =~ ^[a-f0-9]{64}$ ]]; then
        append_hash_mismatch "${manifest_key}"
        return 0
    fi

    actual_digest="$(
        sha256sum "${RUN_DIR}/${expected_relative_path}" |
            awk '{print $1}'
    )"

    if [[ "${actual_digest}" != "${declared_digest}" ]]; then
        append_hash_mismatch "${manifest_key}"
    fi
}

if (($# != 1)); then
    usage
    exit 64
fi

for required_command in \
    docker \
    timeout \
    realpath \
    sha256sum \
    awk \
    stat \
    date \
    rm \
    mv; do
    require_command "${required_command}"
done

set +e

timeout     --signal=TERM     --kill-after=2s     5s     docker version     --format '{{.Server.Version}}'     >/dev/null 2>&1

docker_preflight_rc=$?

set -e

if ((docker_preflight_rc != 0)); then
    die "Docker daemon is not available or did not respond within the bounded preflight"
fi

if [[ ! -d "$1" ]]; then
    die "Run directory does not exist"
fi

if [[ -L "$1" ]]; then
    die "Run-directory symlinks are not permitted"
fi

RUN_DIR="$(realpath "$1")"

[[ "${RUN_DIR}" != "/" ]] ||
    die "Filesystem root cannot be used as a run directory"

if [[ -L "${RUN_DIR}/report" ]]; then
    die "Report-directory symlinks are not permitted"
fi

mkdir -p -- "${RUN_DIR}/report"

VERIFICATION_OUTPUT="${RUN_DIR}/verification.json"
OUTPUT_TEMP="${RUN_DIR}/report/.verification-output.$$.json"
SCENARIO_JSON_TEMP="${RUN_DIR}/report/.scenario.$$.json"
VERIFIER_PROGRAM_TEMP="${RUN_DIR}/report/.verification-program.$$.jq"

trap cleanup_temporary_files EXIT

OVERWRITE_VERIFICATION="${VRP_LAB_OVERWRITE_VERIFICATION:-0}"

[[ "${OVERWRITE_VERIFICATION}" == "0" ||
    "${OVERWRITE_VERIFICATION}" == "1" ]] ||
    die "VRP_LAB_OVERWRITE_VERIFICATION must be 0 or 1"

if [[ -L "${VERIFICATION_OUTPUT}" ]]; then
    die "Verification-result symlinks are not permitted"
fi

if [[ -e "${VERIFICATION_OUTPUT}" &&
    "${OVERWRITE_VERIFICATION}" != "1" ]]; then
    die "verification.json already exists; set VRP_LAB_OVERWRITE_VERIFICATION=1 to replace it"
fi

export VRP_LAB_JQ_IMAGE="${VRP_LAB_JQ_IMAGE:-ghcr.io/jqlang/jq:1.7.1}"
export VRP_LAB_YQ_IMAGE="${VRP_LAB_YQ_IMAGE:-mikefarah/yq:4.45.1}"

validate_image_reference "${VRP_LAB_JQ_IMAGE}"
validate_image_reference "${VRP_LAB_YQ_IMAGE}"

REQUIRE_DIGEST="${VRP_LAB_REQUIRE_DIGEST:-0}"

[[ "${REQUIRE_DIGEST}" == "0" ||
    "${REQUIRE_DIGEST}" == "1" ]] ||
    die "VRP_LAB_REQUIRE_DIGEST must be 0 or 1"

if [[ "${REQUIRE_DIGEST}" == "1" ]]; then
    require_digest_reference "${VRP_LAB_JQ_IMAGE}"
    require_digest_reference "${VRP_LAB_YQ_IMAGE}"
fi

ensure_image "${VRP_LAB_JQ_IMAGE}"
ensure_image "${VRP_LAB_YQ_IMAGE}"

require_artifact "manifest.json" 1048576
require_artifact "input/scenario.yaml" 1048576
require_artifact "input/schedule.tsv" 262144
require_artifact "input/invariant-contract.json" 4194304
require_artifact "witness/environment.json" 2097152
require_artifact "witness/events.jsonl" 67108864
require_artifact "subject/subject-evidence.json" 4194304
require_artifact "subject/subject-events.jsonl" 67108864

if ! jq_container \
    -e \
    'type == "object"' \
    /evidence/manifest.json \
    >/dev/null; then
    write_incomplete_result "manifest.json is not a valid JSON object"
fi

if ! jq_container \
    -e \
    'type == "object"' \
    /evidence/input/invariant-contract.json \
    >/dev/null; then
    write_incomplete_result \
        "input/invariant-contract.json is not a valid JSON object"
fi

if ! jq_container \
    -e \
    'type == "object"' \
    /evidence/witness/environment.json \
    >/dev/null; then
    write_incomplete_result \
        "witness/environment.json is not a valid JSON object"
fi

if ! jq_container \
    -e \
    'type == "object"' \
    /evidence/subject/subject-evidence.json \
    >/dev/null; then
    write_incomplete_result \
        "subject/subject-evidence.json is not a valid JSON object"
fi

if ! jq_container \
    -s \
    -e \
    'length > 0 and all(.[]; type == "object")' \
    /evidence/witness/events.jsonl \
    >/dev/null; then
    write_incomplete_result \
        "witness/events.jsonl is not valid non-empty JSONL"
fi

if ! jq_container \
    -s \
    -e \
    'length > 0 and all(.[]; type == "object")' \
    /evidence/subject/subject-events.jsonl \
    >/dev/null; then
    write_incomplete_result \
        "subject/subject-events.jsonl is not valid non-empty JSONL"
fi

set +e
yq_scenario_to_json >"${SCENARIO_JSON_TEMP}"
scenario_conversion_rc=$?
set -e

if ((scenario_conversion_rc != 0)); then
    write_incomplete_result \
        "input/scenario.yaml could not be parsed"
fi

chmod 0644 "${SCENARIO_JSON_TEMP}"

if ! jq_container \
    -e \
    'type == "object"' \
    "/evidence/report/$(basename "${SCENARIO_JSON_TEMP}")" \
    >/dev/null; then
    write_incomplete_result \
        "Scenario conversion did not produce a JSON object"
fi

HASH_STATUS="PASS"
HASH_MISMATCHES=""

verify_manifest_artifact \
    "scenario" \
    "input/scenario.yaml"

verify_manifest_artifact \
    "schedule" \
    "input/schedule.tsv"

verify_manifest_artifact \
    "invariant_contract" \
    "input/invariant-contract.json"

verify_manifest_artifact \
    "environment" \
    "witness/environment.json"

verify_manifest_artifact \
    "witness_events" \
    "witness/events.jsonl"

verify_manifest_artifact \
    "subject_evidence" \
    "subject/subject-evidence.json"

verify_manifest_artifact \
    "subject_events" \
    "subject/subject-events.jsonl"

MANIFEST_SHA256="$(
    sha256sum "${RUN_DIR}/manifest.json" |
        awk '{print $1}'
)"

CONTRACT_SHA256="$(
    sha256sum "${RUN_DIR}/input/invariant-contract.json" |
        awk '{print $1}'
)"

GENERATED_AT_UTC="$(date -u +%Y-%m-%dT%H:%M:%SZ)"

cat >"${VERIFIER_PROGRAM_TEMP}" <<'JQ'
def result($id; $status; $message):
  {
    "invariant_id": $id,
    "status": $status,
    "message": $message
  };

def checked($id; $condition; $failure_status; $pass_message; $failure_message):
  if $condition then
    result($id; "PASS"; $pass_message)
  else
    result($id; $failure_status; $failure_message)
  end;

def nonempty_string:
  type == "string" and length > 0 and length <= 256;

def nonnegative_integer:
  type == "number" and . >= 0 and floor == .;

def valid_utc:
  type == "string"
  and test("^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}Z$")
  and ((try fromdateiso8601 catch null) != null);

def epoch($value):
  try ($value | fromdateiso8601) catch null;

def strict_sequence($items):
  ($items | length) as $count
  | ($count > 0)
    and all(
      $items[];
      (.event_sequence | nonnegative_integer)
      and .event_sequence >= 1
    )
    and (
      [range(0; $count) | $items[.].event_sequence]
      ==
      [range(1; $count + 1)]
    );

def unique_event_ids($items):
  ($items | length) > 0
  and all($items[]; (.event_id | nonempty_string))
  and (
    ([$items[].event_id] | length)
    ==
    ([$items[].event_id] | unique | length)
  );

def exactly_one_witness_epoch($items; $kind):
  [
    $items[]
    | select(.event_kind == $kind)
    | epoch(.observed_at_utc)
    | select(type == "number")
  ]
  | if length == 1 then .[0] else null end;

def witness_count($items; $kind):
  [$items[] | select(.event_kind == $kind)] | length;

def times_before($items; $boundary):
  [
    $items[]
    | epoch(.observed_at_utc)
    | select(type == "number" and . < $boundary)
  ];

def times_after_or_equal($items; $boundary):
  [
    $items[]
    | epoch(.observed_at_utc)
    | select(type == "number" and . >= $boundary)
  ];

def wifi_checks($scenario; $subject; $witness; $progress; $transitions):
  exactly_one_witness_epoch($witness; "path.wifi.disabled") as $fault_time
  | ($scenario.acceptance.parameters.minimum_baseline_progress_events // -1) as $minimum_before
  | ($scenario.acceptance.parameters.minimum_post_transition_progress_events // -1) as $minimum_after
  | ($scenario.acceptance.parameters.maximum_recovery_seconds // -1) as $maximum_recovery
  | if $fault_time == null then
      [
        result(
          "VRP-LAB-PATH-TRANSITION-OBSERVED";
          "INCOMPLETE";
          "The required primary-path witness event is missing or ambiguous."
        ),
        result(
          "VRP-LAB-PROGRESS-RESUMED";
          "INCOMPLETE";
          "Recovery timing cannot be evaluated without the path-fault witness event."
        )
      ]
    else
      times_before($progress; $fault_time) as $before_times
      | times_after_or_equal($progress; $fault_time) as $after_times
      | ($after_times | min) as $first_after
      | [
          $transitions[]
          | select(
              .logical_path == "mobile"
              and .public_verdict == "observed"
              and (
                epoch(.observed_at_utc) as $transition_time
                | $transition_time != null
                  and $transition_time >= $fault_time
              )
            )
        ] as $mobile_transitions
      | [
          checked(
            "VRP-LAB-PATH-TRANSITION-OBSERVED";
            (
              ($mobile_transitions | length) >= 1
              and $subject.summary.path_transition_count >= 1
              and $subject.final_active_path == "mobile"
            );
            "FAIL";
            "The alternate logical path became the observed active path.";
            "The required transition to the alternate logical path was not established."
          ),
          checked(
            "VRP-LAB-PROGRESS-RESUMED";
            (
              $minimum_before >= 0
              and $minimum_after >= 0
              and $maximum_recovery >= 0
              and ($before_times | length) >= $minimum_before
              and ($after_times | length) >= $minimum_after
              and (
                if $first_after == null then
                  false
                else
                  ($first_after - $fault_time) <= $maximum_recovery
                end
              )
            );
            "FAIL";
            "Public workload progress resumed within the declared recovery bound.";
            "Post-transition progress did not satisfy the declared acceptance window."
          )
        ]
    end;

def blackout_checks($scenario; $subject; $witness; $progress):
  exactly_one_witness_epoch($witness; "blackout.started") as $blackout_start
  | exactly_one_witness_epoch($witness; "blackout.ended") as $blackout_end
  | ($scenario.acceptance.parameters.expected_blackout_seconds // -1) as $expected_duration
  | ($scenario.acceptance.parameters.blackout_tolerance_seconds // -1) as $duration_tolerance
  | ($scenario.observation_windows.blackout.settling_grace_seconds // -1) as $settling_grace
  | ($scenario.acceptance.parameters.maximum_recovery_seconds // -1) as $maximum_recovery
  | ($scenario.acceptance.parameters.minimum_post_recovery_progress_events // -1) as $minimum_after
  | if $blackout_start == null or $blackout_end == null then
      [
        result(
          "VRP-LAB-BLACKOUT-OBSERVED";
          "INCOMPLETE";
          "The bounded-blackout witness interval is missing or ambiguous."
        ),
        result(
          "VRP-LAB-RECOVERY-OBSERVED";
          "INCOMPLETE";
          "Recovery cannot be evaluated without a complete blackout witness interval."
        ),
        result(
          "VRP-LAB-PROGRESS-RESUMED";
          "INCOMPLETE";
          "Post-blackout progress cannot be timed without complete witness evidence."
        )
      ]
    else
      [
        $progress[]
        | epoch(.observed_at_utc)
        | select(
            type == "number"
            and . >= ($blackout_start + $settling_grace)
            and . < $blackout_end
          )
      ] as $progress_during_blackout
      | times_after_or_equal($progress; $blackout_end) as $after_times
      | ($after_times | min) as $first_after
      | ($blackout_end - $blackout_start) as $observed_duration
      | [
          checked(
            "VRP-LAB-BLACKOUT-OBSERVED";
            (
              $expected_duration >= 0
              and $duration_tolerance >= 0
              and $settling_grace >= 0
              and $blackout_end > $blackout_start
              and (
                ($observed_duration - $expected_duration)
                | if . < 0 then -. else . end
              ) <= $duration_tolerance
              and ($progress_during_blackout | length) == 0
            );
            "FAIL";
            "The bounded dual-path blackout was witnessed without false progress.";
            "The blackout interval or its public observations contradicted the scenario."
          ),
          checked(
            "VRP-LAB-RECOVERY-OBSERVED";
            (
              $subject.final_active_path == "mobile"
              and $subject.completion_state == "complete"
              and ($after_times | length) > 0
            );
            "FAIL";
            "The subject recovered through the restored alternate logical path.";
            "Recovery through the restored alternate path was not established."
          ),
          checked(
            "VRP-LAB-PROGRESS-RESUMED";
            (
              $minimum_after >= 0
              and $maximum_recovery >= 0
              and ($after_times | length) >= $minimum_after
              and (
                if $first_after == null then
                  false
                else
                  ($first_after - $blackout_end) <= $maximum_recovery
                end
              )
            );
            "FAIL";
            "Public workload progress resumed within the post-blackout bound.";
            "Post-blackout progress did not satisfy the declared acceptance window."
          )
        ]
    end;

def stale_authority_checks(
  $scenario;
  $subject;
  $witness;
  $events;
  $progress;
  $accepted;
  $transitions
):
  ($scenario.acceptance.parameters.stimulus_event_id // "") as $stimulus_id
  | ($scenario.acceptance.parameters.expected_public_verdict // "") as $expected_verdict
  | ($scenario.acceptance.parameters.required_rejection_events // -1) as $required_rejections
  | ($scenario.acceptance.parameters.maximum_accepted_mutations_for_stimulus // -1) as $maximum_mutations
  | ($scenario.acceptance.parameters.minimum_baseline_progress_events // -1) as $minimum_before
  | ($scenario.acceptance.parameters.minimum_post_rejection_progress_events // -1) as $minimum_after
  | ($scenario.acceptance.parameters.maximum_unplanned_path_transitions // -1) as $maximum_transitions
  | ($scenario.observation_windows.rejection.verdict_timeout_seconds // -1) as $verdict_timeout
  | exactly_one_witness_epoch(
      $witness;
      "stimulus.stale-authority.requested"
    ) as $request_time
  | [
      $events[]
      | select(
          .event_kind == "stimulus-verdict"
          and (.related_witness_event_id? // "") == $stimulus_id
          and .public_verdict == $expected_verdict
        )
    ] as $rejections
  | [
      $accepted[]
      | select((.related_witness_event_id? // "") == $stimulus_id)
    ] as $linked_acceptances
  | if $request_time == null
      or witness_count(
        $witness;
        "stimulus.stale-authority.delivered"
      ) != 1 then
      [
        result(
          "VRP-LAB-STALE-AUTHORITY-REJECTED";
          "INCOMPLETE";
          "The stale-authority stimulus delivery is missing or ambiguous."
        ),
        result(
          "VRP-LAB-REJECTED-STIMULUS-NO-MUTATION";
          "INCOMPLETE";
          "Mutation linkage cannot be evaluated without complete stimulus evidence."
        ),
        result(
          "VRP-LAB-PROGRESS-PRESERVED";
          "INCOMPLETE";
          "Progress preservation cannot be evaluated without the stimulus timestamp."
        )
      ]
    else
      times_before($progress; $request_time) as $before_times
      | times_after_or_equal($progress; $request_time) as $after_times
      | (
          [
            $rejections[]
            | epoch(.observed_at_utc)
            | select(type == "number")
          ]
          | min
        ) as $first_rejection
      | [
          checked(
            "VRP-LAB-STALE-AUTHORITY-REJECTED";
            (
              $required_rejections >= 0
              and $verdict_timeout >= 0
              and ($rejections | length) == $required_rejections
              and $subject.summary.stale_authority_rejection_count
                == $required_rejections
              and (
                if $first_rejection == null then
                  false
                else
                  $first_rejection >= $request_time
                  and ($first_rejection - $request_time) <= $verdict_timeout
                end
              )
            );
            "FAIL";
            "The stale-authority stimulus received the required public rejection verdict.";
            "The required stale-authority rejection was not established."
          ),
          checked(
            "VRP-LAB-REJECTED-STIMULUS-NO-MUTATION";
            (
              $maximum_mutations >= 0
              and ($linked_acceptances | length) <= $maximum_mutations
            );
            "FAIL";
            "No accepted mutation was linked to the rejected stale-authority stimulus.";
            "An accepted mutation was linked to the stale-authority stimulus."
          ),
          checked(
            "VRP-LAB-PROGRESS-PRESERVED";
            (
              $minimum_before >= 0
              and $minimum_after >= 0
              and $maximum_transitions >= 0
              and ($before_times | length) >= $minimum_before
              and ($after_times | length) >= $minimum_after
              and ($transitions | length) <= $maximum_transitions
            );
            "FAIL";
            "Healthy public workload progress continued after rejection.";
            "Post-rejection progress did not satisfy the declared acceptance window."
          )
        ]
    end;

def replay_checks(
  $scenario;
  $subject;
  $witness;
  $events;
  $progress;
  $accepted;
  $transitions
):
  ($scenario.acceptance.parameters.stimulus_event_id // "") as $stimulus_id
  | ($scenario.acceptance.parameters.expected_public_verdict // "") as $expected_verdict
  | ($scenario.acceptance.parameters.required_original_acceptances // -1) as $required_original
  | ($scenario.acceptance.parameters.required_rejection_events // -1) as $required_rejections
  | ($scenario.acceptance.parameters.maximum_total_acceptances_for_original_operation // -1) as $maximum_total
  | ($scenario.acceptance.parameters.maximum_additional_acceptances_for_replay // -1) as $maximum_additional
  | ($scenario.acceptance.parameters.minimum_baseline_progress_events // -1) as $minimum_before
  | ($scenario.acceptance.parameters.minimum_post_rejection_progress_events // -1) as $minimum_after
  | ($scenario.acceptance.parameters.maximum_unplanned_path_transitions // -1) as $maximum_transitions
  | ($scenario.observation_windows.rejection.verdict_timeout_seconds // -1) as $verdict_timeout
  | exactly_one_witness_epoch(
      $witness;
      "stimulus.replay.requested"
    ) as $request_time
  | [
      $events[]
      | select(
          .event_kind == "stimulus-verdict"
          and (.related_witness_event_id? // "") == $stimulus_id
          and .public_verdict == $expected_verdict
        )
    ] as $rejections
  | (
      $rejections
      | if length == 1
          and (.[0].public_operation_reference? | nonempty_string)
        then
          .[0].public_operation_reference
        else
          null
        end
    ) as $operation_reference
  | (
      if $operation_reference == null then
        []
      else
        [
          $accepted[]
          | select(
              (.public_operation_reference? // "")
              == $operation_reference
            )
        ]
      end
    ) as $source_acceptances
  | [
      $accepted[]
      | select((.related_witness_event_id? // "") == $stimulus_id)
    ] as $linked_replay_acceptances
  | if $request_time == null
      or witness_count($witness; "stimulus.replay.delivered") != 1 then
      [
        result(
          "VRP-LAB-REPLAY-SOURCE-OBSERVED";
          "INCOMPLETE";
          "The replay source relationship cannot be established."
        ),
        result(
          "VRP-LAB-REPLAY-REJECTED";
          "INCOMPLETE";
          "The replay stimulus delivery is missing or ambiguous."
        ),
        result(
          "VRP-LAB-REPLAY-NO-DUPLICATE-MUTATION";
          "INCOMPLETE";
          "Duplicate-mutation evaluation requires complete replay evidence."
        ),
        result(
          "VRP-LAB-PROGRESS-PRESERVED";
          "INCOMPLETE";
          "Progress preservation cannot be evaluated without the stimulus timestamp."
        )
      ]
    else
      times_before($progress; $request_time) as $before_times
      | times_after_or_equal($progress; $request_time) as $after_times
      | (
          [
            $rejections[]
            | epoch(.observed_at_utc)
            | select(type == "number")
          ]
          | min
        ) as $first_rejection
      | [
          checked(
            "VRP-LAB-REPLAY-SOURCE-OBSERVED";
            (
              $operation_reference != null
              and $required_original >= 0
              and ($source_acceptances | length) == $required_original
              and all(
                $source_acceptances[];
                epoch(.observed_at_utc) as $source_time
                | $source_time != null
                  and $source_time < $request_time
              )
            );
            "FAIL";
            "One prior accepted public operation was linked to the replay attempt.";
            "The required prior accepted operation was not established."
          ),
          checked(
            "VRP-LAB-REPLAY-REJECTED";
            (
              $required_rejections >= 0
              and $verdict_timeout >= 0
              and ($rejections | length) == $required_rejections
              and $subject.summary.replay_rejection_count
                == $required_rejections
              and (
                if $first_rejection == null then
                  false
                else
                  $first_rejection >= $request_time
                  and ($first_rejection - $request_time) <= $verdict_timeout
                end
              )
            );
            "FAIL";
            "The replay attempt received the required public rejection verdict.";
            "The required replay rejection was not established."
          ),
          checked(
            "VRP-LAB-REPLAY-NO-DUPLICATE-MUTATION";
            (
              $maximum_total >= 0
              and $maximum_additional >= 0
              and ($source_acceptances | length) <= $maximum_total
              and (
                ($source_acceptances | length) - $required_original
              ) <= $maximum_additional
              and ($linked_replay_acceptances | length) == 0
            );
            "FAIL";
            "The replay attempt did not create an additional accepted mutation.";
            "Duplicate acceptance was observed for the replayed operation."
          ),
          checked(
            "VRP-LAB-PROGRESS-PRESERVED";
            (
              $minimum_before >= 0
              and $minimum_after >= 0
              and $maximum_transitions >= 0
              and ($before_times | length) >= $minimum_before
              and ($after_times | length) >= $minimum_after
              and ($transitions | length) <= $maximum_transitions
            );
            "FAIL";
            "Healthy public workload progress continued after replay rejection.";
            "Post-rejection progress did not satisfy the declared acceptance window."
          )
        ]
    end;

def scenario_checks(
  $scenario;
  $subject;
  $witness;
  $events;
  $progress;
  $accepted;
  $transitions
):
  if $scenario.scenario.id == "wifi-to-mobile" then
    wifi_checks(
      $scenario;
      $subject;
      $witness;
      $progress;
      $transitions
    )
  elif $scenario.scenario.id == "blackout-recovery" then
    blackout_checks(
      $scenario;
      $subject;
      $witness;
      $progress
    )
  elif $scenario.scenario.id == "stale-authority" then
    stale_authority_checks(
      $scenario;
      $subject;
      $witness;
      $events;
      $progress;
      $accepted;
      $transitions
    )
  elif $scenario.scenario.id == "replay-attempt" then
    replay_checks(
      $scenario;
      $subject;
      $witness;
      $events;
      $progress;
      $accepted;
      $transitions
    )
  else
    [
      result(
        "VRP-LAB-SCENARIO-SUPPORTED";
        "INCOMPLETE";
        "The scenario identifier is not supported by this verifier."
      )
    ]
  end;

($manifest[0]) as $manifest_object
| ($scenario[0]) as $scenario_object
| ($contract[0]) as $contract_object
| ($environment[0]) as $environment_object
| ($subject[0]) as $subject_object
| $witness as $witness_events
| $subject_events as $events
| [
    $events[]
    | select(
        .event_kind == "progress"
        and .public_verdict == "succeeded"
      )
  ] as $progress_events
| [
    $events[]
    | select(
        .event_kind == "path-transition"
        and .public_verdict == "observed"
      )
  ] as $transition_events
| [
    $events[]
    | select(
        .event_kind == "mutation"
        and .public_verdict == "accepted"
      )
  ] as $accepted_events
| [
    $events[]
    | select(.public_verdict == "accepted-duplicate")
  ] as $duplicate_events
| [
    $events[]
    | select(.public_verdict == "rejected-stale-authority")
  ] as $stale_rejection_events
| [
    $events[]
    | select(.public_verdict == "rejected-replay")
  ] as $replay_rejection_events
| (
    [
      $subject_object.continuity_reference,
      (
        $events[]
        | .continuity_reference?
        | select(type == "string" and length > 0)
      )
    ]
    | map(select(type == "string" and length > 0))
    | unique
  ) as $continuity_references
| (
    [
      ($subject_object, $events[])
      | ..
      | objects
      | keys[]
      | select(
          test(
            "(private[_-]?key|secret|credential|bearer|protected[_-]?token|raw[_-]?(packet|payload|artifact)|internal[_-]?(runtime[_-]?)?state|stack[_-]?trace|source[_-]?path|decision[_-]?trace)";
            "i"
          )
        )
    ]
    | unique
  ) as $prohibited_keys
| (
    ($subject_object.summary.successful_progress_event_count
        | nonnegative_integer)
    and ($subject_object.summary.path_transition_count
        | nonnegative_integer)
    and ($subject_object.summary.accepted_mutation_count
        | nonnegative_integer)
    and ($subject_object.summary.duplicate_accepted_mutation_count
        | nonnegative_integer)
    and ($subject_object.summary.stale_authority_rejection_count
        | nonnegative_integer)
    and ($subject_object.summary.replay_rejection_count
        | nonnegative_integer)
) as $counter_fields_valid
| (
    $counter_fields_valid
    and $subject_object.summary.successful_progress_event_count
      == ($progress_events | length)
    and $subject_object.summary.path_transition_count
      == ($transition_events | length)
    and $subject_object.summary.accepted_mutation_count
      == ($accepted_events | length)
    and $subject_object.summary.duplicate_accepted_mutation_count
      == ($duplicate_events | length)
    and $subject_object.summary.stale_authority_rejection_count
      == ($stale_rejection_events | length)
    and $subject_object.summary.replay_rejection_count
      == ($replay_rejection_events | length)
  ) as $counter_consistency
| (
    ($manifest_object.schema_version
        == "vrp-continuity-lab/run-manifest-v1")
    and ($scenario_object.schema_version
        == "vrp-continuity-lab/scenario-v1")
    and ($contract_object.schema_version
        == "vrp-continuity-lab/invariant-contract-v1")
    and ($environment_object.schema_version
        == "vrp-continuity-lab/environment-v1")
    and ($subject_object.schema_version
        == "vrp-continuity-lab/subject-evidence-v1")
    and ($subject_object.evidence_format
        == "public-evidence-v1")
    and ($subject_object.run_id | nonempty_string)
    and ($subject_object.adapter.public_id | nonempty_string)
    and ($subject_object.adapter.version | nonempty_string)
    and ($subject_object.started_at_utc | valid_utc)
    and ($subject_object.completed_at_utc | valid_utc)
    and ($subject_object.continuity_reference | nonempty_string)
    and ($subject_object.final_active_path | nonempty_string)
    and all(
        $witness_events[];
        (.schema_version == "vrp-continuity-lab/witness-event-v1")
        and (.observed_at_utc | valid_utc)
    )
    and all(
        $events[];
        (.schema_version == "vrp-continuity-lab/subject-event-v1")
        and (.run_id | nonempty_string)
        and (.event_id | nonempty_string)
        and (.event_kind | nonempty_string)
        and (.public_verdict | nonempty_string)
        and (.observed_at_utc | valid_utc)
    )
) as $schema_compatible
| (
    all(
      ($scenario_object.evidence.required_witness_events // [])[];
      . as $required_kind
      | any(
          $witness_events[];
          .event_kind == $required_kind
        )
    )
  ) as $required_witness_complete
| (
    [
      $environment_object.run_id,
      $subject_object.run_id,
      ($witness_events[].run_id),
      ($events[].run_id)
    ]
    | all(. == $manifest_object.run_id)
  ) as $run_ids_consistent
| (
    ($continuity_references | length) == 1
  ) as $continuity_stable
| (
    $subject_object.summary.duplicate_accepted_mutation_count == 0
    and ($duplicate_events | length) == 0
    and (
      [
        $accepted_events[]
        | .public_operation_reference?
        | select(type == "string" and length > 0)
      ] as $accepted_references
      | ($accepted_references | length)
        == ($accepted_references | unique | length)
    )
  ) as $no_duplicate_acceptance
| (
    ($contract_object.global_required_invariants // [])
    +
    ($scenario_object.acceptance.required_invariants // [])
    | unique
  ) as $required_invariant_ids
| [
    "VRP-LAB-ARTIFACT-HASHES-MATCH",
    "VRP-LAB-SCHEMA-COMPATIBLE",
    "VRP-LAB-PROHIBITED-FIELDS-ABSENT",
    "VRP-LAB-EVIDENCE-COUNTERS-CONSISTENT",
    "VRP-LAB-CONTRACT-COVERAGE",
    "VRP-LAB-EVIDENCE-COMPLETE",
    "VRP-LAB-RUN-ID-CONSISTENT",
    "VRP-LAB-EVENT-SEQUENCE-MONOTONIC",
    "VRP-LAB-EVENT-ID-UNIQUE",
    "VRP-LAB-CONTINUITY-REFERENCE-STABLE",
    "VRP-LAB-NO-DUPLICATE-ACCEPTANCE",
    "VRP-LAB-PATH-TRANSITION-OBSERVED",
    "VRP-LAB-PROGRESS-RESUMED",
    "VRP-LAB-BLACKOUT-OBSERVED",
    "VRP-LAB-RECOVERY-OBSERVED",
    "VRP-LAB-STALE-AUTHORITY-REJECTED",
    "VRP-LAB-REJECTED-STIMULUS-NO-MUTATION",
    "VRP-LAB-PROGRESS-PRESERVED",
    "VRP-LAB-REPLAY-SOURCE-OBSERVED",
    "VRP-LAB-REPLAY-REJECTED",
    "VRP-LAB-REPLAY-NO-DUPLICATE-MUTATION"
  ] as $supported_invariant_ids
| (
    ($contract_object.invariants | type) == "array"
    and (
      [$contract_object.invariants[].id] | length
    ) == (
      [$contract_object.invariants[].id] | unique | length
    )
    and all(
      $required_invariant_ids[];
      . as $required_id
      | any(
          $contract_object.invariants[];
          .id == $required_id
        )
    )
    and all(
      $required_invariant_ids[];
      . as $required_id
      | any(
          $supported_invariant_ids[];
          . == $required_id
        )
    )
  ) as $contract_coverage
| [
    checked(
      "VRP-LAB-ARTIFACT-HASHES-MATCH";
      $hash_status == "PASS";
      "FAIL";
      "All manifest-bound artifact hashes match.";
      "One or more manifest-bound artifact hashes do not match."
    ),
    checked(
      "VRP-LAB-SCHEMA-COMPATIBLE";
      $schema_compatible;
      "INCOMPLETE";
      "All public evidence schemas are compatible.";
      "One or more public evidence schemas are missing or incompatible."
    ),
    checked(
      "VRP-LAB-PROHIBITED-FIELDS-ABSENT";
      ($prohibited_keys | length) == 0;
      "FAIL";
      "No prohibited subject-evidence fields were detected.";
      "Subject evidence contains prohibited field names."
    ),
    checked(
      "VRP-LAB-EVIDENCE-COUNTERS-CONSISTENT";
      $counter_consistency;
      "FAIL";
      "Subject summary counters match the ordered public event stream.";
      "Subject summary counters contradict the public event stream."
    ),
    checked(
      "VRP-LAB-CONTRACT-COVERAGE";
      $contract_coverage;
      "INCOMPLETE";
      "Every required invariant is defined and supported.";
      "The required invariant set is undefined or unsupported."
    ),
    checked(
      "VRP-LAB-EVIDENCE-COMPLETE";
      (
        $manifest_object.execution_state == "COMPLETE"
        and $manifest_object.execution_exit_code == 0
        and $manifest_object.evidence_format == "public-evidence-v1"
        and $subject_object.completion_state == "complete"
        and $subject_object.public_verdict == "evidence-ready"
        and $required_witness_complete
        and $counter_fields_valid
        and epoch($subject_object.started_at_utc) != null
        and epoch($subject_object.completed_at_utc) != null
        and epoch($subject_object.started_at_utc)
          <= epoch($subject_object.completed_at_utc)
      );
      "INCOMPLETE";
      "All required public evidence is complete.";
      "The run does not contain a complete public evidence set."
    ),
    checked(
      "VRP-LAB-RUN-ID-CONSISTENT";
      $run_ids_consistent;
      "FAIL";
      "The run identifier is consistent across all evidence layers.";
      "Run identifiers contradict each other."
    ),
    (
      if ($witness_events | length) == 0
          or ($events | length) == 0 then
        result(
          "VRP-LAB-EVENT-SEQUENCE-MONOTONIC";
          "INCOMPLETE";
          "Event sequencing cannot be evaluated from empty evidence."
        )
      else
        checked(
          "VRP-LAB-EVENT-SEQUENCE-MONOTONIC";
          (
            strict_sequence($witness_events)
            and strict_sequence($events)
          );
          "FAIL";
          "Witness and subject event sequences are strictly monotonic.";
          "An event sequence is missing, duplicated, or out of order."
        )
      end
    ),
    (
      if ($witness_events | length) == 0
          or ($events | length) == 0 then
        result(
          "VRP-LAB-EVENT-ID-UNIQUE";
          "INCOMPLETE";
          "Event-identifier uniqueness cannot be evaluated."
        )
      else
        checked(
          "VRP-LAB-EVENT-ID-UNIQUE";
          (
            unique_event_ids($witness_events)
            and unique_event_ids($events)
          );
          "FAIL";
          "Witness and subject event identifiers are unique.";
          "Duplicate or invalid public event identifiers were found."
        )
      end
    ),
    (
      if ($continuity_references | length) == 0 then
        result(
          "VRP-LAB-CONTINUITY-REFERENCE-STABLE";
          "INCOMPLETE";
          "No public continuity reference was available."
        )
      else
        checked(
          "VRP-LAB-CONTINUITY-REFERENCE-STABLE";
          $continuity_stable;
          "FAIL";
          "Exactly one opaque public continuity reference was observed.";
          "Multiple public continuity references were observed."
        )
      end
    ),
    checked(
      "VRP-LAB-NO-DUPLICATE-ACCEPTANCE";
      $no_duplicate_acceptance;
      "FAIL";
      "No duplicate accepted mutation was observed.";
      "Duplicate accepted mutation evidence was detected."
    )
  ] as $general_checks
| scenario_checks(
    $scenario_object;
    $subject_object;
    $witness_events;
    $events;
    $progress_events;
    $accepted_events;
    $transition_events
  ) as $scenario_specific_checks
| ($general_checks + $scenario_specific_checks) as $initial_checks
| (
    all(
      $required_invariant_ids[];
      . as $required_id
      | any(
          $initial_checks[];
          .invariant_id == $required_id
        )
    )
  ) as $all_required_checks_present
| (
    $initial_checks
    | map(
        if .invariant_id == "VRP-LAB-CONTRACT-COVERAGE"
            and $all_required_checks_present == false then
          .status = "INCOMPLETE"
          | .message = "A required invariant has no evaluator."
        else
          .
        end
      )
  ) as $checks
| (
    if any($checks[]; .status == "FAIL") then
      "FAIL"
    elif any($checks[]; .status == "INCOMPLETE") then
      "INCOMPLETE"
    else
      "PASS"
    end
  ) as $verdict
| {
    "schema_version": "vrp-continuity-lab/verification-v1",
    "run_id": $manifest_object.run_id,
    "scenario_id": $scenario_object.scenario.id,
    "verdict": $verdict,
    "generated_at_utc": $generated_at,
    "inputs": {
      "manifest_sha256": $manifest_sha256,
      "invariant_contract_sha256": $contract_sha256,
      "hash_mismatches": (
        if $hash_mismatches == "" then
          []
        else
          ($hash_mismatches | split(","))
        end
      )
    },
    "checks": $checks,
    "summary": {
      "pass": (
        [$checks[] | select(.status == "PASS")] | length
      ),
      "fail": (
        [$checks[] | select(.status == "FAIL")] | length
      ),
      "incomplete": (
        [$checks[] | select(.status == "INCOMPLETE")] | length
      )
    },
    "interpretation": {
      "scope": "public-black-box-observations",
      "internal_implementation_proven": false,
      "production_readiness_proven": false,
      "formal_verification_provided": false
    }
  }
JQ

chmod 0644 "${VERIFIER_PROGRAM_TEMP}"

if ! jq_container \
    -n \
    --slurpfile manifest /evidence/manifest.json \
    --slurpfile scenario \
        "/evidence/report/$(basename "${SCENARIO_JSON_TEMP}")" \
    --slurpfile contract \
        /evidence/input/invariant-contract.json \
    --slurpfile environment \
        /evidence/witness/environment.json \
    --slurpfile witness \
        /evidence/witness/events.jsonl \
    --slurpfile subject \
        /evidence/subject/subject-evidence.json \
    --slurpfile subject_events \
        /evidence/subject/subject-events.jsonl \
    --arg hash_status "${HASH_STATUS}" \
    --arg hash_mismatches "${HASH_MISMATCHES}" \
    --arg manifest_sha256 "${MANIFEST_SHA256}" \
    --arg contract_sha256 "${CONTRACT_SHA256}" \
    --arg generated_at "${GENERATED_AT_UTC}" \
    -f "/evidence/report/$(basename "${VERIFIER_PROGRAM_TEMP}")" \
    >"${OUTPUT_TEMP}"; then
    write_incomplete_result \
        "The deterministic public-invariant evaluator did not complete"
fi

chmod 0644 "${OUTPUT_TEMP}"

cp -- "${OUTPUT_TEMP}" "${RUN_DIR}/report/verifier-raw-result.json"
chmod 0644 "${RUN_DIR}/report/verifier-raw-result.json"

if ! jq_container \
    -e \
    '
      type == "object"
      and .schema_version
        == "vrp-continuity-lab/verification-v1"
      and (
        .verdict == "PASS"
        or .verdict == "FAIL"
        or .verdict == "INCOMPLETE"
      )
    ' \
    "/evidence/report/$(basename "${OUTPUT_TEMP}")" \
    >/dev/null; then
    write_incomplete_result \
        "The verifier produced an invalid result object"
fi

FINAL_VERDICT="$(
    jq_container \
        -r \
        '.verdict' \
        "/evidence/report/$(basename "${OUTPUT_TEMP}")"
)"

mv -f -- "${OUTPUT_TEMP}" "${VERIFICATION_OUTPUT}"

printf '[vrp-lab-verifier] VERDICT=%s\n' "${FINAL_VERDICT}"
printf '[vrp-lab-verifier] RESULT=%s\n' "${VERIFICATION_OUTPUT}"

case "${FINAL_VERDICT}" in
    PASS)
        exit 0
        ;;
    FAIL)
        exit 1
        ;;
    INCOMPLETE)
        exit 2
        ;;
    *)
        die "Unexpected final verdict"
        ;;
esac
