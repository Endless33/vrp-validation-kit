#!/usr/bin/env bash

set -euo pipefail

CMD="${1:-run}"
EVIDENCE_DIR="${VRP_LAB_EVIDENCE_DIRECTORY:-/evidence}"
RUN_ID="${VRP_LAB_RUN_ID:-manual}"
SCENARIO_ID="${VRP_LAB_SCENARIO_ID:-manual}"
DURATION="${VRP_LAB_RUN_DURATION_SECONDS:-60}"

CONTINUITY_REFERENCE="mock-continuity-${RUN_ID}"
STARTED_AT="$(date -u '+%Y-%m-%dT%H:%M:%SZ')"

graceful_shutdown() {
    echo "[subject] received termination signal at $(date -u +%H:%M:%S)" >&2
    exit 0
}

trap graceful_shutdown TERM INT

mkdir -p "${EVIDENCE_DIR}"

iso_now() {
    date -u '+%Y-%m-%dT%H:%M:%SZ'
}

write_event() {
    local _legacy_sequence="$1"
    local event_id="$2"
    local event_kind="$3"
    local public_verdict="$4"
    local path="${5:-}"
    local continuity_reference="${6:-}"
    local operation_reference="${7:-}"
    local related_witness_event_id="${8:-}"

    local sequence_file="${EVIDENCE_DIR}/.event-sequence"
    local lock_dir="${EVIDENCE_DIR}/.event-sequence.lock"

    # Serialize sequence allocation AND event append together.
    # This prevents another writer from reserving the next sequence
    # and appending its event before the current writer.
    while ! mkdir "${lock_dir}" 2>/dev/null; do
        sleep 0.01
    done

    local current=0

    if [[ -f "${sequence_file}" ]]; then
        current="$(cat "${sequence_file}")"
        if ! [[ "${current}" =~ ^[0-9]+$ ]]; then
            current=0
        fi
    fi

    local authoritative_sequence=$((current + 1))

    {
        printf '{"schema_version":"vrp-continuity-lab/subject-event-v1"'
        printf ',"run_id":"%s"' "${RUN_ID}"
        printf ',"event_sequence":%s' "${authoritative_sequence}"
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

        if [[ -n "${operation_reference}" ]]; then
            printf ',"public_operation_reference":"%s"' "${operation_reference}"
        fi

        if [[ -n "${related_witness_event_id}" ]]; then
            printf ',"related_witness_event_id":"%s"' "${related_witness_event_id}"
        fi

        printf '}\n'
    } >> "${EVIDENCE_DIR}/subject-events.jsonl"

    printf '%s\n' "${authoritative_sequence}" > "${sequence_file}"

    rmdir "${lock_dir}"
}


write_evidence() {
    local completed_at="$1"

    local final_active_path="mobile"
    local path_transition_count=1
    local stale_authority_rejection_count=0
    local replay_rejection_count=0

    case "${SCENARIO_ID:-}" in
        replay-attempt)
            final_active_path="wifi"
            path_transition_count=0
            replay_rejection_count=1
            ;;

        stale-authority)
            final_active_path="wifi"
            path_transition_count=0
            stale_authority_rejection_count=1
            ;;

        blackout-recovery)
            final_active_path="mobile"
            path_transition_count=1
            ;;

        wifi-to-mobile)
            final_active_path="mobile"
            path_transition_count=1
            ;;

        *)
            ;;
    esac

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
  "final_active_path": "${final_active_path}",
  "summary": {
    "successful_progress_event_count": 10,
    "path_transition_count": ${path_transition_count},
    "accepted_mutation_count": 1,
    "duplicate_accepted_mutation_count": 0,
    "stale_authority_rejection_count": ${stale_authority_rejection_count},
    "replay_rejection_count": ${replay_rejection_count}
  }
}
JSON
}

case "${CMD}" in

health)
    echo "OK"
    exit 0
    ;;


stimulus)

    shift

    if [[ -f "${EVIDENCE_DIR}/subject-events.jsonl" ]]; then
        LAST_SEQUENCE="$(
            tail -n 1 "${EVIDENCE_DIR}/subject-events.jsonl" \
            | sed -n 's/.*"event_sequence":\([0-9][0-9]*\).*/\1/p'
        )"

        if [[ -n "${LAST_SEQUENCE}" ]]; then
            SEQUENCE=$((LAST_SEQUENCE + 1))
        else
            SEQUENCE=1
        fi
    else
        SEQUENCE=1
    fi

    KIND=""
    EVENT_ID=""

    while (($#)); do
        case "$1" in
            --kind)
                KIND="$2"
                shift 2
                ;;
            --event-id)
                EVENT_ID="$2"
                shift 2
                ;;
            *)
                shift
                ;;
        esac
    done

    case "${KIND}" in
        replay)

            write_event \
                "${SEQUENCE}" \
                "${EVENT_ID}" \
                "stimulus-verdict" \
                "rejected-replay" \
                "wifi" \
                "${CONTINUITY_REFERENCE}" \
                "operation-001" \
                "${EVENT_ID}"

            SEQUENCE=$((SEQUENCE + 1))

            # Public mock synchronization marker.
            # This contains no protected payload or runtime state.
            : > "${EVIDENCE_DIR}/.replay-stimulus-complete"

            ;;

        stale-authority)

            write_event \
                "${SEQUENCE}" \
                "${EVENT_ID}" \
                "stimulus-verdict" \
                "rejected-stale-authority" \
                "wifi" \
                "${CONTINUITY_REFERENCE}" \
                "operation-001" \
                "${EVENT_ID}"

            SEQUENCE=$((SEQUENCE + 1))

            # Public mock synchronization marker.
            # Contains no protected runtime state or implementation data.
            : > "${EVIDENCE_DIR}/.stale-authority-stimulus-complete"

            ;;

        blackout-start)

            # Public synchronization boundary only.
            # No schedule, controller state, packet data, or
            # protected runtime state is exposed.
            : > "${EVIDENCE_DIR}/.blackout-start-complete"

            ;;

        blackout-end)

            # Public synchronization boundary only.
            # No schedule, controller state, packet data, or
            # protected runtime state is exposed.
            : > "${EVIDENCE_DIR}/.blackout-end-complete"

            ;;

        *)

            echo "unknown stimulus: ${KIND}" >&2
            exit 1
            ;;

    esac

    # Stimulus commands are control-boundary operations only.
    # They must never finalize or rewrite subject completion evidence.
    # Final evidence is written exclusively by the long-running run path.
    exit 0
    ;;

run)
    echo "[subject] RUN START $(date -u +%H:%M:%S)" >&2

    : > "${EVIDENCE_DIR}/subject-events.jsonl"
    rm -f "${EVIDENCE_DIR}/.event-sequence"
    rm -f "${EVIDENCE_DIR}/.replay-stimulus-complete"
    rm -f "${EVIDENCE_DIR}/.stale-authority-stimulus-complete"
    rm -f "${EVIDENCE_DIR}/.blackout-start-complete"
    rm -f "${EVIDENCE_DIR}/.blackout-end-complete"
    rmdir "${EVIDENCE_DIR}/.event-sequence.lock" 2>/dev/null || true

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

    write_event \
        "${SEQUENCE}" \
        "accepted-operation-001" \
        "mutation" \
        "accepted" \
        "wifi" \
        "${CONTINUITY_REFERENCE}" \
        "operation-001"

    SEQUENCE=$((SEQUENCE + 1))

    # ------------------------------------------------------------
    # Scenario-specific post-baseline behavior.
    #
    # replay-attempt:
    #   No path transition is permitted after replay rejection.
    #   Continue healthy progress on the current Wi-Fi path.
    #
    # Other scenarios:
    #   Preserve the existing Wi-Fi -> mobile transition behavior.
    # ------------------------------------------------------------

    if [[ "${SCENARIO_ID:-}" == "replay-attempt" ]]; then

        # --------------------------------------------------------
        # Replay scenario:
        # Do NOT emit post-rejection progress until the harness
        # has actually delivered the replay stimulus and the
        # public rejection event has been recorded.
        # --------------------------------------------------------
        REPLAY_WAIT_ELAPSED=0
        REPLAY_WAIT_TIMEOUT=40

        while [[ ! -f "${EVIDENCE_DIR}/.replay-stimulus-complete" ]]; do
            if (( REPLAY_WAIT_ELAPSED >= REPLAY_WAIT_TIMEOUT )); then
                echo "[subject] ERROR: replay stimulus synchronization timeout" >&2
                exit 1
            fi

            sleep 1
            REPLAY_WAIT_ELAPSED=$((REPLAY_WAIT_ELAPSED + 1))
        done

        # --------------------------------------------------------
        # Post-rejection progress:
        # five successful events on the same Wi-Fi path.
        # No path transition is introduced by the replay scenario.
        # --------------------------------------------------------
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

    elif [[ "${SCENARIO_ID:-}" == "stale-authority" ]]; then

        # --------------------------------------------------------
        # Stale-authority scenario:
        # Do not emit post-rejection progress until the harness
        # has delivered the stale-authority stimulus and the
        # public rejection event has been recorded.
        #
        # The mock intentionally exposes only the public verdict
        # and synchronization boundary. No protected runtime
        # state is exposed.
        # --------------------------------------------------------

        STALE_WAIT_ELAPSED=0
        STALE_WAIT_TIMEOUT=40

        while [[ ! -f "${EVIDENCE_DIR}/.stale-authority-stimulus-complete" ]]; do
            if (( STALE_WAIT_ELAPSED >= STALE_WAIT_TIMEOUT )); then
                echo "[subject] ERROR: stale-authority stimulus synchronization timeout" >&2
                exit 1
            fi

            sleep 1
            STALE_WAIT_ELAPSED=$((STALE_WAIT_ELAPSED + 1))
        done

        # --------------------------------------------------------
        # Post-rejection progress.
        # The public continuity remains usable after rejection.
        # --------------------------------------------------------

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

    elif [[ "${SCENARIO_ID:-}" == "blackout-recovery" ]]; then

        # --------------------------------------------------------
        # Blackout-recovery scenario:
        #
        # The subject does not receive the scenario schedule,
        # controller state, path topology, or fault timing.
        #
        # It receives only two public synchronization boundaries:
        #
        #   blackout-start
        #   blackout-end
        #
        # No protected runtime state is exposed.
        # --------------------------------------------------------

        BLACKOUT_START_WAIT_ELAPSED=0
        BLACKOUT_START_WAIT_TIMEOUT=40

        while [[ ! -f "${EVIDENCE_DIR}/.blackout-start-complete" ]]; do
            if (( BLACKOUT_START_WAIT_ELAPSED >= BLACKOUT_START_WAIT_TIMEOUT )); then
                echo "[subject] ERROR: blackout-start synchronization timeout" >&2
                exit 1
            fi

            sleep 1
            BLACKOUT_START_WAIT_ELAPSED=$((BLACKOUT_START_WAIT_ELAPSED + 1))
        done

        # --------------------------------------------------------
        # During the blackout there is intentionally no synthetic
        # progress. The public evidence must establish recovery
        # after the actual fault boundary.
        # --------------------------------------------------------

        BLACKOUT_END_WAIT_ELAPSED=0
        BLACKOUT_END_WAIT_TIMEOUT=40

        while [[ ! -f "${EVIDENCE_DIR}/.blackout-end-complete" ]]; do
            if (( BLACKOUT_END_WAIT_ELAPSED >= BLACKOUT_END_WAIT_TIMEOUT )); then
                echo "[subject] ERROR: blackout-end synchronization timeout" >&2
                exit 1
            fi

            sleep 1
            BLACKOUT_END_WAIT_ELAPSED=$((BLACKOUT_END_WAIT_ELAPSED + 1))
        done

        # --------------------------------------------------------
        # Post-recovery progress.
        # Public continuity resumes after blackout recovery.
        # --------------------------------------------------------

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

    else

        # --------------------------------------------------------
        # Existing transition behavior for migration scenarios.
        # --------------------------------------------------------
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

        # --------------------------------------------------------
        # Post-transition progress: five successful events.
        # --------------------------------------------------------
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

    fi

    echo "[subject] WRITING EVIDENCE $(date -u +%H:%M:%S)" >&2

COMPLETED_AT="$(iso_now)"

    write_evidence "${COMPLETED_AT}"

    # ------------------------------------------------------------
    # Remain alive until the harness terminates the subject.
    # ------------------------------------------------------------
    echo "[subject] ENTER WAIT LOOP duration=${DURATION}" >&2

    RUN_STARTED_SECONDS="${SECONDS}"

    while (( SECONDS - RUN_STARTED_SECONDS < DURATION )); do
        sleep 1
    done

    exit 0
    ;;

*)
    echo "unknown command: ${CMD}" >&2
    exit 1
    ;;

esac
