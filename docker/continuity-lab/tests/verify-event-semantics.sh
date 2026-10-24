#!/usr/bin/env bash
set -Eeuo pipefail

LAB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
BASE="$LAB_DIR/out/replay-attempt-20260815t073311z-4d3f33e5"

test -f "$BASE/manifest.json"
test -f "$BASE/subject/subject-events.jsonl"

TMP="$(mktemp -d /tmp/vrp-event-semantics.XXXXXX)"
trap 'rm -rf "$TMP"' EXIT

cp -a "$BASE" "$TMP/control"

cp -a "$TMP/control" "$TMP/bad-binding"

python3 - "$TMP/bad-binding/subject/subject-events.jsonl" <<'PYTHON'
import json, sys

p = sys.argv[1]
events = [json.loads(x) for x in open(p) if x.strip()]

for e in events:
    if e.get("public_verdict") == "rejected-replay":
        e["event_kind"] = "lifecycle"

with open(p, "w") as f:
    for e in events:
        f.write(json.dumps(e, separators=(",", ":")) + "\n")
PYTHON

echo "MUTATION=OK"

HASH="$(sha256sum "$TMP/bad-binding/subject/subject-events.jsonl" | awk '{print $1}')"

python3 - "$TMP/bad-binding/manifest.json" "$HASH" <<'PYTHON'
import json, sys

p, digest = sys.argv[1], sys.argv[2]

with open(p) as f:
    manifest = json.load(f)

manifest["artifacts"]["subject_events"]["sha256"] = digest

with open(p, "w") as f:
    json.dump(manifest, f, indent=2)
    f.write("\n")
PYTHON

echo "HASH_REBOUND=OK"

rm -f "$TMP/bad-binding/verification.json"

set +e
VRP_LAB_OVERWRITE_VERIFICATION=1 \
    "$LAB_DIR/scripts/verify-evidence.sh" \
    "$TMP/bad-binding" >/dev/null 2>&1
VERIFY_RC=$?
set -e

echo "VERIFY_RC=$VERIFY_RC"

SCHEMA_STATUS="$(
python3 - "$TMP/bad-binding/verification.json" <<'PYTHON'
import json, sys
r=json.load(open(sys.argv[1]))
for c in r["checks"]:
    if c["invariant_id"]=="VRP-LAB-SCHEMA-COMPATIBLE":
        print(c["status"])
        break
PYTHON
)"

echo "SCHEMA_STATUS=$SCHEMA_STATUS"

if [ "$VERIFY_RC" -eq 0 ]; then
    echo "ERROR: semantically invalid rebound evidence was accepted"
    exit 1
fi

if [ "$SCHEMA_STATUS" != "INCOMPLETE" ]; then
    echo "ERROR: expected schema status INCOMPLETE, got $SCHEMA_STATUS"
    exit 1
fi

echo "INVALID_EVENT_BINDING_REJECTED=YES"
echo "FAIL_CLOSED_ASSERTION=PASS"

echo "EVENT_SEMANTICS_TEST=READY"
echo "BASELINE=$(basename "$BASE")"
echo "TEMP_COPY=OK"
