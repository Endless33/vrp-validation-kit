#!/usr/bin/env bash
set -uo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR" || exit 1

RUN_ID="evaluation-$(date -u +%Y%m%dT%H%M%SZ)"
OUT_DIR="$ROOT_DIR/out/$RUN_ID"
LOG_DIR="$OUT_DIR/logs"
BIN_DIR="$OUT_DIR/bin"

mkdir -p "$LOG_DIR" "$BIN_DIR"

FINAL_RC=0
PASSED=0
FAILED=0
SKIPPED=0

section() {
    printf '\n'
    printf '%s\n' "============================================================"
    printf '%s\n' "$1"
    printf '%s\n' "============================================================"
}

record_pass() {
    PASSED=$((PASSED + 1))
}

record_fail() {
    FAILED=$((FAILED + 1))
    FINAL_RC=1
}

record_skip() {
    SKIPPED=$((SKIPPED + 1))
}

run_stage() {
    local name="$1"
    shift

    section "$name"

    "$@" 2>&1 | tee "$LOG_DIR/${name}.log"
    local rc=${PIPESTATUS[0]}

    printf '\nSTAGE=%s\n' "$name"
    printf 'RC=%d\n' "$rc"

    if [ "$rc" -eq 0 ]; then
        printf 'STATUS=PASS\n'
        record_pass
    else
        printf 'STATUS=FAIL\n'
        record_fail
    fi

    return 0
}

section "VRP PUBLIC EVALUATION"

printf 'run_id=%s\n' "$RUN_ID"
printf 'started_at_utc=%s\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
printf 'repository=%s\n' "$ROOT_DIR"

if command -v git >/dev/null 2>&1; then
    printf 'git_head=%s\n' "$(git rev-parse HEAD 2>/dev/null || printf unknown)"
    printf 'git_branch=%s\n' "$(git rev-parse --abbrev-ref HEAD 2>/dev/null || printf unknown)"
else
    printf 'git_head=unavailable\n'
    printf 'git_branch=unavailable\n'
fi

if command -v go >/dev/null 2>&1; then
    printf 'go_version=%s\n' "$(go version)"
    printf 'go_platform=%s/%s\n' "$(go env GOOS)" "$(go env GOARCH)"
else
    printf 'go_version=unavailable\n'
fi

printf 'host_kernel=%s\n' "$(uname -srmo 2>/dev/null || uname -a)"

section "BUILD VRP EVALUATION CAPSULE"

if ! command -v go >/dev/null 2>&1; then
    printf 'STATUS=FAIL\n'
    printf 'reason=go_not_available\n'
    record_fail
else
    go build \
        -trimpath \
        -o "$BIN_DIR/vrp-evaluate" \
        ./cmd/vrp-evaluate \
        2>&1 | tee "$LOG_DIR/build.log"

    BUILD_RC=${PIPESTATUS[0]}

    printf '\nBUILD_RC=%d\n' "$BUILD_RC"

    if [ "$BUILD_RC" -eq 0 ]; then
        printf 'STATUS=PASS\n'
        record_pass
    else
        printf 'STATUS=FAIL\n'
        record_fail
    fi
fi

CAPSULE="$BIN_DIR/vrp-evaluate"

if [ -x "$CAPSULE" ]; then
    run_stage "doctor" \
        "$CAPSULE" doctor

    run_stage "verify-sample" \
        "$CAPSULE" verify-sample
else
    section "CAPSULE EXECUTION"
    printf 'STATUS=FAIL\n'
    printf 'reason=capsule_binary_unavailable\n'
    record_fail
fi

if command -v go >/dev/null 2>&1; then
    run_stage "go-test" \
        go test ./... -count=1

    run_stage "go-vet" \
        go vet ./...

    run_stage "validation-model" \
        go run ./cmd/vrp-test

    run_stage "attack-model" \
        go run ./cmd/attack-suite

    run_stage "runtime-scenario-model" \
        go run ./cmd/vrp-runtime-scenario
fi

section "DOCKER CONTINUITY LAB"

if command -v docker >/dev/null 2>&1 && docker info >/dev/null 2>&1; then
    printf 'docker_available=true\n'

    LAB_DIR="$ROOT_DIR/docker/continuity-lab"

    if [ -x "$LAB_DIR/scripts/run-scenario.sh" ]; then
        for scenario in \
            wifi-to-mobile \
            blackout-recovery \
            stale-authority \
            replay-attempt
        do
            printf '\n'
            printf '%s\n' "------------------------------------------------------------"
            printf 'DOCKER_SCENARIO=%s\n' "$scenario"
            printf '%s\n' "------------------------------------------------------------"

            (
                cd "$LAB_DIR" || exit 1
                ./scripts/run-scenario.sh "$scenario"
            ) 2>&1 | tee "$LOG_DIR/docker-${scenario}.log"

            SCENARIO_RC=${PIPESTATUS[0]}

            printf 'SCENARIO_RC=%d\n' "$SCENARIO_RC"

            if [ "$SCENARIO_RC" -eq 0 ]; then
                printf 'STATUS=PASS\n'
                record_pass
            else
                printf 'STATUS=FAIL\n'
                record_fail
            fi
        done
    else
        printf 'STATUS=FAIL\n'
        printf 'reason=docker_lab_runner_not_executable\n'
        record_fail
    fi
else
    printf 'docker_available=false\n'
    printf 'STATUS=SKIPPED\n'
    printf 'reason=docker_runtime_not_available_on_this_host\n'
    printf 'note=SKIPPED_IS_NOT_PASS\n'
    record_skip
fi

section "ARTIFACT HASHES"

HASH_FILE="$OUT_DIR/SHA256SUMS"

: > "$HASH_FILE"

while IFS= read -r -d '' file; do
    relative="${file#"$OUT_DIR"/}"

    if [ "$relative" = "SHA256SUMS" ]; then
        continue
    fi

    sha256sum "$file" |
        sed "s#  $OUT_DIR/#  #" >> "$HASH_FILE"
done < <(find "$OUT_DIR" -type f -print0 | sort -z)

cat "$HASH_FILE"

section "MACHINE READABLE RESULT"

RESULT_FILE="$OUT_DIR/result.env"

{
    printf 'RUN_ID=%s\n' "$RUN_ID"
    printf 'GIT_HEAD=%s\n' "$(git rev-parse HEAD 2>/dev/null || printf unknown)"
    printf 'PASSED=%d\n' "$PASSED"
    printf 'FAILED=%d\n' "$FAILED"
    printf 'SKIPPED=%d\n' "$SKIPPED"
    printf 'FINAL_RC=%d\n' "$FINAL_RC"

    if [ "$FINAL_RC" -eq 0 ]; then
        printf 'FINAL_VERDICT=PUBLIC_EVALUATION_PASSED\n'
    else
        printf 'FINAL_VERDICT=PUBLIC_EVALUATION_FAILED\n'
    fi
} > "$RESULT_FILE"

cat "$RESULT_FILE"

section "FINAL VRP PUBLIC EVALUATION VERDICT"

printf 'stages_passed=%d\n' "$PASSED"
printf 'stages_failed=%d\n' "$FAILED"
printf 'stages_skipped=%d\n' "$SKIPPED"
printf 'evidence_directory=%s\n' "$OUT_DIR"

if [ "$SKIPPED" -gt 0 ]; then
    printf 'environment_note=some_capabilities_were_unavailable\n'
    printf 'interpretation=skipped_capabilities_are_not_claimed_as_passed\n'
fi

if [ "$FINAL_RC" -eq 0 ]; then
    printf '\n'
    printf 'FINAL_VERDICT=PUBLIC_EVALUATION_PASSED\n'
    printf 'FINAL_RC=0\n'
else
    printf '\n'
    printf 'FINAL_VERDICT=PUBLIC_EVALUATION_FAILED\n'
    printf 'FINAL_RC=1\n'
fi

printf '\ncompleted_at_utc=%s\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)"

exit "$FINAL_RC"