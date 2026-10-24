#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"

FAILED=0

echo "============================================================"
echo "VRP CONTINUITY LAB REGRESSION SUITE"
echo "============================================================"

for t in \
    verify-event-semantics.sh \
    verify-blackout-transition.sh
do
    echo
    echo "============================================================"
    echo "RUNNING: $t"
    echo "============================================================"

    if "$ROOT/$t"; then
        echo "[PASS] $t"
    else
        echo "[FAIL] $t"
        FAILED=1
    fi
done

echo
echo "============================================================"

if [ "$FAILED" -eq 0 ]; then
    echo "ALL REGRESSION TESTS PASSED"
    exit 0
else
    echo "REGRESSION SUITE FAILED"
    exit 1
fi
