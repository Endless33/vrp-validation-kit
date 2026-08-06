#!/usr/bin/env bash

set -Eeuo pipefail
IFS=$'\n\t'
umask 077
export LC_ALL=C

RUN_DIR=""
STAGING_DIR=""
ARCHIVE_TEMP=""
SIDECAR_TEMP=""
SUMMARY_TEMP=""
EXPORT_MANIFEST_TEMP=""
PACKAGE_CHECKSUMS_TEMP=""

usage() {
    printf '%s\n' \
        "Usage:" \
        "  ./scripts/export-report.sh out/<run-id>"
}

log() {
    printf '[vrp-lab-exporter] %s\n' "$*"
}

die() {
    printf '[vrp-lab-exporter] ERROR: %s\n' "$*" >&2
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

markdown_escape() {
    local value="${1-}"

    value="${value//\\/\\\\}"
    value="${value//|/\\|}"
    value="${value//$'\n'/ }"
    value="${value//$'\r'/ }"
    value="${value//$'\t'/ }"

    printf '%s' "${value}"
}

validate_image_reference() {
    [[ "$1" =~ ^[A-Za-z0-9][A-Za-z0-9._/:@+-]*$ ]] ||
        die "Invalid JSON-parser image reference"
}

require_digest_reference() {
    [[ "$1" =~ @sha256:[a-f0-9]{64}$ ]] ||
        die "Digest-qualified JSON-parser image required"
}

ensure_image() {
    local reference="$1"

    if docker image inspect "${reference}" >/dev/null 2>&1; then
        return 0
    fi

    log "Pulling required JSON-parser image: ${reference}"
    docker pull "${reference}" >/dev/null
}

cleanup() {
    local temporary_file

    for temporary_file in \
        "${ARCHIVE_TEMP:-}" \
        "${SIDECAR_TEMP:-}" \
        "${SUMMARY_TEMP:-}" \
        "${EXPORT_MANIFEST_TEMP:-}" \
        "${PACKAGE_CHECKSUMS_TEMP:-}"; do
        if [[ -n "${temporary_file}" &&
            -f "${temporary_file}" ]]; then
            rm -f -- "${temporary_file}"
        fi
    done

    if [[ -n "${STAGING_DIR:-}" &&
        -d "${STAGING_DIR}" ]]; then
        case "${STAGING_DIR}" in
            /tmp/vrp-lab-export.*)
                rm -rf -- "${STAGING_DIR}"
                ;;
            *)
                printf \
                    '[vrp-lab-exporter] WARNING: refusing to remove unexpected temporary path\n' \
                    >&2
                ;;
        esac
    fi
}

require_artifact() {
    local relative_path="$1"
    local maximum_size="$2"
    local full_path="${RUN_DIR}/${relative_path}"
    local artifact_size

    [[ -f "${full_path}" ]] ||
        die "Required artifact is missing: ${relative_path}"

    [[ ! -L "${full_path}" ]] ||
        die "Artifact symlinks are not permitted: ${relative_path}"

    artifact_size="$(stat -c '%s' "${full_path}")"

    ((artifact_size > 0)) ||
        die "Required artifact is empty: ${relative_path}"

    ((artifact_size <= maximum_size)) ||
        die "Artifact exceeds the public size limit: ${relative_path}"
}

prepare_destination() {
    local destination="$1"
    local overwrite="$2"

    [[ ! -L "${destination}" ]] ||
        die "Output symlinks are not permitted"

    if [[ -e "${destination}" &&
        "${overwrite}" != "1" ]]; then
        die "Output already exists: $(basename "${destination}")"
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

jq_read() {
    local expression="$1"
    local relative_path="$2"

    jq_container \
        -r \
        "${expression}" \
        "/evidence/${relative_path}"
}

append_hash_failure() {
    local artifact_name="$1"

    if [[ -z "${HASH_FAILURES}" ]]; then
        HASH_FAILURES="${artifact_name}"
    else
        HASH_FAILURES="${HASH_FAILURES},${artifact_name}"
    fi
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
        append_hash_failure "${manifest_key}"
        return 0
    fi

    if [[ ! "${declared_digest}" =~ ^[a-f0-9]{64}$ ]]; then
        append_hash_failure "${manifest_key}"
        return 0
    fi

    actual_digest="$(
        sha256sum "${RUN_DIR}/${expected_relative_path}" |
            awk '{print $1}'
    )"

    if [[ "${actual_digest}" != "${declared_digest}" ]]; then
        append_hash_failure "${manifest_key}"
    fi
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
    tar \
    gzip \
    mktemp \
    mkdir \
    cp \
    mv \
    rm \
    find \
    sort \
    chmod \
    basename \
    dirname; do
    require_command "${required_command}"
done

docker info >/dev/null 2>&1 ||
    die "Docker daemon is not available"

tar --version |
    awk 'NR == 1 { if ($0 !~ /GNU tar/) exit 1 }' ||
    die "GNU tar is required for deterministic export"

[[ -d "$1" ]] ||
    die "Run directory does not exist"

[[ ! -L "$1" ]] ||
    die "Run-directory symlinks are not permitted"

RUN_DIR="$(realpath "$1")"

[[ "${RUN_DIR}" != "/" ]] ||
    die "Filesystem root cannot be used as a run directory"

REPORT_DIR="${RUN_DIR}/report"
EXPORT_DIR="${REPORT_DIR}/exports"

[[ ! -L "${REPORT_DIR}" ]] ||
    die "Report-directory symlinks are not permitted"

[[ ! -L "${EXPORT_DIR}" ]] ||
    die "Export-directory symlinks are not permitted"

mkdir -p -- "${REPORT_DIR}" "${EXPORT_DIR}"

export VRP_LAB_JQ_IMAGE="${
    VRP_LAB_JQ_IMAGE:-ghcr.io/jqlang/jq:1.7.1
}"

validate_image_reference "${VRP_LAB_JQ_IMAGE}"

REQUIRE_DIGEST="${VRP_LAB_REQUIRE_DIGEST:-0}"

[[ "${REQUIRE_DIGEST}" == "0" ||
    "${REQUIRE_DIGEST}" == "1" ]] ||
    die "VRP_LAB_REQUIRE_DIGEST must be 0 or 1"

if [[ "${REQUIRE_DIGEST}" == "1" ]]; then
    require_digest_reference "${VRP_LAB_JQ_IMAGE}"
fi

ensure_image "${VRP_LAB_JQ_IMAGE}"

declare -a SOURCE_ARTIFACTS=(
    "manifest.json"
    "verification.json"
    "input/scenario.yaml"
    "input/schedule.tsv"
    "input/invariant-contract.json"
    "witness/environment.json"
    "witness/events.jsonl"
    "subject/subject-evidence.json"
    "subject/subject-events.jsonl"
)

require_artifact "manifest.json" 1048576
require_artifact "verification.json" 4194304
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
    die "manifest.json is not a valid JSON object"
fi

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
    /evidence/verification.json \
    >/dev/null; then
    die "verification.json is not a valid verification result"
fi

if ! jq_container \
    -e \
    'type == "object"' \
    /evidence/input/invariant-contract.json \
    >/dev/null; then
    die "Invariant contract is not a valid JSON object"
fi

if ! jq_container \
    -e \
    'type == "object"' \
    /evidence/witness/environment.json \
    >/dev/null; then
    die "Environment evidence is not a valid JSON object"
fi

if ! jq_container \
    -s \
    -e \
    'length > 0 and all(.[]; type == "object")' \
    /evidence/witness/events.jsonl \
    >/dev/null; then
    die "Witness event evidence is not valid JSONL"
fi

if ! jq_container \
    -e \
    'type == "object"' \
    /evidence/subject/subject-evidence.json \
    >/dev/null; then
    die "Subject evidence is not a valid JSON object"
fi

if ! jq_container \
    -s \
    -e \
    'length > 0 and all(.[]; type == "object")' \
    /evidence/subject/subject-events.jsonl \
    >/dev/null; then
    die "Subject event evidence is not valid JSONL"
fi

RUN_ID="$(
    jq_read '.run_id // ""' "verification.json"
)"
SCENARIO_ID="$(
    jq_read '.scenario_id // ""' "verification.json"
)"
VERDICT="$(
    jq_read '.verdict // ""' "verification.json"
)"
VERIFICATION_TIME="$(
    jq_read '.generated_at_utc // ""' "verification.json"
)"

[[ "${RUN_ID}" =~ ^[a-z0-9][a-z0-9.-]{0,127}$ ]] ||
    die "Invalid run identifier in verification result"

[[ "${SCENARIO_ID}" =~ ^[a-z0-9][a-z0-9-]{0,47}$ ]] ||
    die "Invalid scenario identifier in verification result"

[[ "${VERDICT}" == "PASS" ||
    "${VERDICT}" == "FAIL" ||
    "${VERDICT}" == "INCOMPLETE" ]] ||
    die "Unsupported verification verdict"

MANIFEST_RUN_ID="$(
    jq_read '.run_id // ""' "manifest.json"
)"
MANIFEST_SCENARIO_ID="$(
    jq_read '.scenario_id // ""' "manifest.json"
)"

[[ "${MANIFEST_RUN_ID}" == "${RUN_ID}" ]] ||
    die "Manifest and verification run identifiers do not match"

[[ "${MANIFEST_SCENARIO_ID}" == "${SCENARIO_ID}" ]] ||
    die "Manifest and verification scenario identifiers do not match"

if ! jq_container \
    -e \
    '
      [
        "VRP-LAB-ARTIFACT-HASHES-MATCH",
        "VRP-LAB-SCHEMA-COMPATIBLE",
        "VRP-LAB-PROHIBITED-FIELDS-ABSENT",
        "VRP-LAB-RUN-ID-CONSISTENT"
      ] as $required
      | all(
          $required[];
          . as $required_id
          | (
              [
                .checks[]
                | select(.invariant_id == $required_id)
              ]
              | length == 1
              and .[0].status == "PASS"
            )
        )
      and (.inputs.hash_mismatches | length == 0)
    ' \
    /evidence/verification.json \
    >/dev/null; then
    die "Verification safety and integrity gates are not all PASS"
fi

if ! jq_container \
    -s \
    -e \
    '
      [
        .[]
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
      | length == 0
    ' \
    /evidence/subject/subject-evidence.json \
    /evidence/subject/subject-events.jsonl \
    >/dev/null; then
    die "Subject evidence contains prohibited field names"
fi

if ! jq_container \
    -s \
    -e \
    '
      [
        .[]
        | ..
        | strings
        | select(
            length > 4096
            or test("-----BEGIN[[:space:]].*PRIVATE[[:space:]]KEY-----"; "i")
            or test("(^|/)(internal|private)/[^[:space:]]+"; "i")
            or test("(^|/)(root|home)/[^[:space:]]+"; "i")
          )
      ]
      | length == 0
    ' \
    /evidence/subject/subject-evidence.json \
    /evidence/subject/subject-events.jsonl \
    >/dev/null; then
    die "Subject evidence contains prohibited or oversized string material"
fi

HASH_FAILURES=""

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

[[ -z "${HASH_FAILURES}" ]] ||
    die "Manifest-bound artifact integrity check failed"

CURRENT_MANIFEST_SHA256="$(
    sha256sum "${RUN_DIR}/manifest.json" |
        awk '{print $1}'
)"
CURRENT_CONTRACT_SHA256="$(
    sha256sum "${RUN_DIR}/input/invariant-contract.json" |
        awk '{print $1}'
)"
CURRENT_VERIFICATION_SHA256="$(
    sha256sum "${RUN_DIR}/verification.json" |
        awk '{print $1}'
)"

VERIFIED_MANIFEST_SHA256="$(
    jq_read \
        '.inputs.manifest_sha256 // ""' \
        "verification.json"
)"
VERIFIED_CONTRACT_SHA256="$(
    jq_read \
        '.inputs.invariant_contract_sha256 // ""' \
        "verification.json"
)"

[[ "${CURRENT_MANIFEST_SHA256}" == \
    "${VERIFIED_MANIFEST_SHA256}" ]] ||
    die "Manifest changed after verification"

[[ "${CURRENT_CONTRACT_SHA256}" == \
    "${VERIFIED_CONTRACT_SHA256}" ]] ||
    die "Invariant contract changed after verification"

OVERWRITE_EXPORT="${VRP_LAB_OVERWRITE_EXPORT:-0}"

[[ "${OVERWRITE_EXPORT}" == "0" ||
    "${OVERWRITE_EXPORT}" == "1" ]] ||
    die "VRP_LAB_OVERWRITE_EXPORT must be 0 or 1"

VERDICT_LOWER="${VERDICT,,}"
ARCHIVE_BASENAME="${RUN_ID}-${VERDICT_LOWER}-evidence.tar.gz"
ARCHIVE_PATH="${EXPORT_DIR}/${ARCHIVE_BASENAME}"
SIDECAR_PATH="${ARCHIVE_PATH}.sha256"
SUMMARY_PATH="${REPORT_DIR}/summary.md"
EXPORT_MANIFEST_PATH="${REPORT_DIR}/export-manifest.json"
PACKAGE_CHECKSUMS_PATH="${REPORT_DIR}/package-SHA256SUMS"

prepare_destination "${ARCHIVE_PATH}" "${OVERWRITE_EXPORT}"
prepare_destination "${SIDECAR_PATH}" "${OVERWRITE_EXPORT}"
prepare_destination "${SUMMARY_PATH}" "${OVERWRITE_EXPORT}"
prepare_destination "${EXPORT_MANIFEST_PATH}" "${OVERWRITE_EXPORT}"
prepare_destination "${PACKAGE_CHECKSUMS_PATH}" "${OVERWRITE_EXPORT}"

STAGING_DIR="$(mktemp -d /tmp/vrp-lab-export.XXXXXXXX)"
PACKAGE_ROOT="${STAGING_DIR}/${RUN_ID}"

mkdir -p -- \
    "${PACKAGE_ROOT}/input" \
    "${PACKAGE_ROOT}/witness" \
    "${PACKAGE_ROOT}/subject" \
    "${PACKAGE_ROOT}/report"

for relative_path in "${SOURCE_ARTIFACTS[@]}"; do
    destination="${PACKAGE_ROOT}/${relative_path}"

    mkdir -p -- "$(dirname "${destination}")"

    cp -- \
        "${RUN_DIR}/${relative_path}" \
        "${destination}"
done

RUN_STARTED_AT="$(
    jq_read '.started_at_utc // ""' "manifest.json"
)"
RUN_COMPLETED_AT="$(
    jq_read '.completed_at_utc // ""' "manifest.json"
)"
CONTRACT_VERSION="$(
    jq_read \
        '.contract_version // ""' \
        "input/invariant-contract.json"
)"

cat >"${PACKAGE_ROOT}/report/summary.md" <<EOF
# VRP Docker Continuity Evidence Report

| Field | Value |
|---|---|
| Run ID | $(markdown_escape "${RUN_ID}") |
| Scenario | $(markdown_escape "${SCENARIO_ID}") |
| Verdict | **$(markdown_escape "${VERDICT}")** |
| Run started | $(markdown_escape "${RUN_STARTED_AT}") |
| Run completed | $(markdown_escape "${RUN_COMPLETED_AT}") |
| Verification generated | $(markdown_escape "${VERIFICATION_TIME}") |
| Invariant contract | $(markdown_escape "${CONTRACT_VERSION}") |
| Manifest SHA-256 | \`${CURRENT_MANIFEST_SHA256}\` |
| Verification SHA-256 | \`${CURRENT_VERIFICATION_SHA256}\` |
| Contract SHA-256 | \`${CURRENT_CONTRACT_SHA256}\` |

## Verification Checks

| Invariant | Status | Observation |
|---|---|---|
EOF

while IFS=$'\t' read -r \
    invariant_id \
    check_status \
    check_message; do
    printf '| %s | %s | %s |\n' \
        "$(markdown_escape "${invariant_id}")" \
        "$(markdown_escape "${check_status}")" \
        "$(markdown_escape "${check_message}")" \
        >>"${PACKAGE_ROOT}/report/summary.md"
done < <(
    jq_container \
        -r \
        '
          .checks[]
          | [
              .invariant_id,
              .status,
              .message
            ]
          | @tsv
        ' \
        /evidence/verification.json
)

cat >>"${PACKAGE_ROOT}/report/summary.md" <<'EOF'

## Interpretation Boundary

This report evaluates only the public black-box observations declared by the selected scenario and invariant contract.

It does not contain or establish:

- protected VRP runtime source code;
- proprietary internal algorithms;
- private authority calculations;
- cryptographic key material;
- formal verification of the hidden implementation;
- production-readiness certification;
- behavior outside the recorded bounded run.

A `PASS` verdict means that the required public observations were consistent for this run.

A `FAIL` verdict means that at least one required public invariant was contradicted.

An `INCOMPLETE` verdict means that the available evidence was insufficient for a valid final decision.
EOF

ARTIFACT_ENTRIES=""
FIRST_ENTRY=1

declare -a MANIFESTED_ARTIFACTS=(
    "manifest.json"
    "verification.json"
    "input/scenario.yaml"
    "input/schedule.tsv"
    "input/invariant-contract.json"
    "witness/environment.json"
    "witness/events.jsonl"
    "subject/subject-evidence.json"
    "subject/subject-events.jsonl"
    "report/summary.md"
)

for relative_path in "${MANIFESTED_ARTIFACTS[@]}"; do
    artifact_path="${PACKAGE_ROOT}/${relative_path}"
    artifact_digest="$(
        sha256sum "${artifact_path}" |
            awk '{print $1}'
    )"
    artifact_size="$(stat -c '%s' "${artifact_path}")"

    if ((FIRST_ENTRY == 0)); then
        ARTIFACT_ENTRIES+=","
    fi

    ARTIFACT_ENTRIES+=$'\n'
    ARTIFACT_ENTRIES+="    {"
    ARTIFACT_ENTRIES+="\"path\":\"$(json_escape "${relative_path}")\","
    ARTIFACT_ENTRIES+="\"sha256\":\"${artifact_digest}\","
    ARTIFACT_ENTRIES+="\"bytes\":${artifact_size}"
    ARTIFACT_ENTRIES+="}"

    FIRST_ENTRY=0
done

cat >"${PACKAGE_ROOT}/report/export-manifest.json" <<EOF
{
  "schema_version": "vrp-continuity-lab/export-manifest-v1",
  "run_id": "$(json_escape "${RUN_ID}")",
  "scenario_id": "$(json_escape "${SCENARIO_ID}")",
  "verdict": "$(json_escape "${VERDICT}")",
  "evidence_scope": "public-black-box-observations",
  "verification_generated_at_utc": "$(json_escape "${VERIFICATION_TIME}")",
  "source_manifest_sha256": "${CURRENT_MANIFEST_SHA256}",
  "source_verification_sha256": "${CURRENT_VERIFICATION_SHA256}",
  "source_invariant_contract_sha256": "${CURRENT_CONTRACT_SHA256}",
  "included_artifacts": [${ARTIFACT_ENTRIES}
  ],
  "excluded_by_policy": [
    "protected runtime source code",
    "runtime binaries",
    "container registry credentials",
    "cryptographic keys",
    "raw protected packets",
    "private authority material",
    "container logs",
    "host filesystem paths",
    "unexpected run-directory files"
  ]
}
EOF

(
    cd -- "${PACKAGE_ROOT}"

    while IFS= read -r relative_path; do
        sha256sum "${relative_path}"
    done < <(
        find . \
            -type f \
            ! -name 'SHA256SUMS' \
            -print |
            sort
    )
) >"${PACKAGE_ROOT}/SHA256SUMS"

find "${PACKAGE_ROOT}" \
    -type d \
    -exec chmod 0755 {} +

find "${PACKAGE_ROOT}" \
    -type f \
    -exec chmod 0644 {} +

ARCHIVE_TEMP="${EXPORT_DIR}/.${ARCHIVE_BASENAME}.tmp.$$"
SIDECAR_TEMP="${EXPORT_DIR}/.${ARCHIVE_BASENAME}.sha256.tmp.$$"
SUMMARY_TEMP="${REPORT_DIR}/.summary.md.tmp.$$"
EXPORT_MANIFEST_TEMP="${REPORT_DIR}/.export-manifest.json.tmp.$$"
PACKAGE_CHECKSUMS_TEMP="${REPORT_DIR}/.package-SHA256SUMS.tmp.$$"

tar \
    --sort=name \
    --format=posix \
    --pax-option=delete=atime,delete=ctime \
    --mtime='UTC 1970-01-01' \
    --owner=0 \
    --group=0 \
    --numeric-owner \
    -C "${STAGING_DIR}" \
    -cf - \
    "${RUN_ID}" |
    gzip -n -9 >"${ARCHIVE_TEMP}"

ARCHIVE_SHA256="$(
    sha256sum "${ARCHIVE_TEMP}" |
        awk '{print $1}'
)"

printf '%s  %s\n' \
    "${ARCHIVE_SHA256}" \
    "${ARCHIVE_BASENAME}" \
    >"${SIDECAR_TEMP}"

cp -- \
    "${PACKAGE_ROOT}/report/summary.md" \
    "${SUMMARY_TEMP}"

cp -- \
    "${PACKAGE_ROOT}/report/export-manifest.json" \
    "${EXPORT_MANIFEST_TEMP}"

cp -- \
    "${PACKAGE_ROOT}/SHA256SUMS" \
    "${PACKAGE_CHECKSUMS_TEMP}"

mv -f -- "${ARCHIVE_TEMP}" "${ARCHIVE_PATH}"
mv -f -- "${SIDECAR_TEMP}" "${SIDECAR_PATH}"
mv -f -- "${SUMMARY_TEMP}" "${SUMMARY_PATH}"
mv -f -- "${EXPORT_MANIFEST_TEMP}" "${EXPORT_MANIFEST_PATH}"
mv -f -- "${PACKAGE_CHECKSUMS_TEMP}" "${PACKAGE_CHECKSUMS_PATH}"

printf '[vrp-lab-exporter] VERDICT=%s\n' "${VERDICT}"
printf '[vrp-lab-exporter] ARCHIVE=%s\n' "${ARCHIVE_PATH}"
printf '[vrp-lab-exporter] ARCHIVE_SHA256=%s\n' "${ARCHIVE_SHA256}"
printf '[vrp-lab-exporter] SUMMARY=%s\n' "${SUMMARY_PATH}"
printf '[vrp-lab-exporter] EXPORT_MANIFEST=%s\n' \
    "${EXPORT_MANIFEST_PATH}"
