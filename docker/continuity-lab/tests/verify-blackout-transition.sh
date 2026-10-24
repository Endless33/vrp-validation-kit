#!/usr/bin/env bash
set -Eeuo pipefail

LAB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"

export VRP_LAB_SUBJECT_IMAGE="${VRP_LAB_SUBJECT_IMAGE:-vrp-subject-local:test}"
export VRP_LAB_SUBJECT_UID="${VRP_LAB_SUBJECT_UID:-$(id -u)}"
export VRP_LAB_SUBJECT_GID="${VRP_LAB_SUBJECT_GID:-$(id -g)}"

echo "========================================"
echo "BLACKOUT TRANSITION REGRESSION"
echo "========================================"

"${LAB_DIR}/scripts/run-scenario.sh" \
    configs/blackout-recovery.yaml >/tmp/vrp-blackout-run.log

RUN_DIR="$(
grep 'RUN_DIR=' /tmp/vrp-blackout-run.log |
tail -1 |
sed 's/^.*RUN_DIR=//'
)"

echo "RUN_DIR=${RUN_DIR}"

VRP_LAB_OVERWRITE_VERIFICATION=1 \
"${LAB_DIR}/scripts/verify-evidence.sh" \
"${RUN_DIR}" >/tmp/vrp-blackout-verify.log

python3 - "${RUN_DIR}/subject/subject-events.jsonl" <<'PY'
import json,sys

events=[json.loads(x) for x in open(sys.argv[1]) if x.strip()]

transition=[
e for e in events
if e.get("event_kind")=="path-transition"
and e.get("public_verdict")=="observed"
]

if len(transition)!=1:
    print("ERROR: expected exactly one path-transition event")
    sys.exit(1)

print("PATH_TRANSITION_EVENT=PASS")
PY

python3 - "${RUN_DIR}/verification.json" <<'PY'
import json,sys

r=json.load(open(sys.argv[1]))

assert r["verdict"]=="PASS", r["verdict"]

print("VERIFIER_PASS=YES")
PY

echo
echo "========================================"
echo "BLACKOUT REGRESSION PASSED"
echo "========================================"
