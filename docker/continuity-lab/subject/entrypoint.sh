#!/usr/bin/env bash

set -euo pipefail

CMD="${1:-run}"
EVIDENCE_DIR="${VRP_LAB_EVIDENCE_DIRECTORY:-/evidence}"
RUN_ID="${VRP_LAB_RUN_ID:-manual}"
DURATION="${VRP_LAB_RUN_DURATION_SECONDS:-60}"

CONTINUITY_REFERENCE="mock-continuity-${RUN_ID}"
STARTED_AT="$(date -u '+%Y-%m-%dT%H:%M:%SZ')"

graceful_shutdown() {
    exit 0
}

trap graceful_shutdown TERM INT

mkdir -p "${EVIDENCE_DIR}"

iso_now() {
    date -u '+%Y-%m-%dT%H:%M:%SZ'
}

write_event() {
    local sequence="$1"
    local event_id="$2"
    local event_kind="$3"
    local public_verdict="$4"
    local path="${5:-}"
    local continuity_reference="${6:-}"

    {
        printf '{"schema_version":"vrp-continuity-lab/subject-event-v1"'
        printf ',"run_id":"%s"' "${RUN_ID}"
        printf ',"event_sequence":%s' "${sequence}"
        printf ',"event_id":"%s"' "${event_id}"
        printf ',"event_kind":"%s"' "${event_kind}"
        printf ',"public_verdict":"%s"' "${public_verdict}"
        printf ',"observed_at_utc":"%s"' "$(iso_now)"

        if [[ -n "${continuity_reference}" ]]; then
            printf ',"continuity_reference":"%s"' "${continuity_reference}"
        fi

        if [[ -n "${path}" ]]; then
            printf ',"logical_path":"%s"' "${path}"
        fi

        printf '}\n'
    } >> "${EVIDENCE_DIR}/subject-events.jsonl"
}

write_evidence() {
    local completed_at="$1"

    cat > "${EVIDENCE_DIR}/subject-evidence.json" <<JSON
{
  "schema_version": "vrp-continuity-lab/subject-evidence-v1",
  "evidence_format": "public-evidence-v1",
  "run_id": "${RUN_ID}",
  "adapter": {
    "public_id": "vrp-subject-mock",
    "version": "1.0.0"
  },
  "started_at_utc": "${STARTED_AT}",
  "completed_at_utc": "${completed_at}",
  "completion_state": "complete",
  "public_verdict": "evidence-ready",
  "continuity_reference": "${CONTINUITY_REFERENCE}",
  "final_active_path": "mobile",
  "summary": {
    "successful_progress_event_count": 10,
    "path_transition_count": 1,
    "accepted_mutation_count": 0,
    "duplicate_accepted_mutation_count": 0,
    "stale_authority_rejection_count": 0,
    "replay_rejection_count": 0
  }
}
JSON
}

case "${CMD}" in

health)
    echo "OK"
    exit 0
    ;;

run)
    : > "${EVIDENCE_DIR}/subject-events.jsonl"

    SEQUENCE=1

    # ------------------------------------------------------------
    # Baseline progress: five successful public progress events.
    # ------------------------------------------------------------
    for i in 1 2 3 4 5; do
        sleep 1

        write_event \
            "${SEQUENCE}" \
            "mock-progress-${SEQUENCE}" \
            "progress" \
            "succeeded" \
            "wifi" \
            "${CONTINUITY_REFERENCE}"

        SEQUENCE=$((SEQUENCE + 1))
    done

    # ------------------------------------------------------------
    # Wait until the harness has had time to apply the Wi-Fi fault.
    # The scenario declares a 15-second fault point and a 12-second
    # recovery bound. Transition at approximately +16 seconds.
    # ------------------------------------------------------------
    ELAPSED=5

    while (( ELAPSED < 16 )); do
        sleep 1
        ELAPSED=$((ELAPSED + 1))
    done

    write_event \
        "${SEQUENCE}" \
        "mock-path-transition-${SEQUENCE}" \
        "path-transition" \
        "observed" \
        "mobile" \
        "${CONTINUITY_REFERENCE}"

    SEQUENCE=$((SEQUENCE + 1))

    # ------------------------------------------------------------
    # Post-transition progress: five successful events.
    # ------------------------------------------------------------
    for i in 1 2 3 4 5; do
        sleep 1

        write_event \
            "${SEQUENCE}" \
            "mock-progress-${SEQUENCE}" \
            "progress" \
            "succeeded" \
            "mobile" \
            "${CONTINUITY_REFERENCE}"

        SEQUENCE=$((SEQUENCE + 1))
    done

    COMPLETED_AT="$(iso_now)"

    write_evidence "${COMPLETED_AT}"

    # ------------------------------------------------------------
    # Remain alive until the harness terminates the subject.
    # ------------------------------------------------------------
    ELAPSED=26

    while (( ELAPSED < DURATION )); do
        sleep 1
        ELAPSED=$((ELAPSED + 1))
    done

    exit 0
    ;;

*)
    echo "unknown command: ${CMD}" >&2
    exit 1
    ;;

esac
