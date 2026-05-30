VRP Validation Kit

VRP Validation Kit is a standalone executable validation harness for validating core VRP continuity invariants.

The goal is not to expose implementation details.

The goal is to provide a reproducible executable that engineers can run independently and inspect directly.

---

Purpose

Most networking demonstrations focus on connectivity.

VRP focuses on execution correctness.

Transport may fail.

Execution correctness must remain deterministic.

This validation kit allows engineers to observe that behavior through reproducible runtime evidence.

---

Tested Invariants

The validation kit currently validates:

- Duplicate commit rejection
- Stale authority rejection
- Stale epoch rejection
- Session identity preservation across transport migration
- Authority migration correctness
- Canonical commit history consistency

---

Build

Linux:

go build -o vrp-test ./cmd/vrp-test

Windows:

go build -o vrp-test.exe ./cmd/vrp-test

Cross-compile Linux binary from Windows:

GOOS=linux GOARCH=amd64 go build -o vrp-test ./cmd/vrp-test

---

Run

Linux:

./vrp-test

Windows:

vrp-test.exe

---

Example Output

=== VRP VALIDATION KIT ===
Runtime: standalone invariant validation harness

TEST: DUPLICATE MUTATION
first_commit=true
replayed_commit=false
VERDICT=DUPLICATE_COMMIT_REJECTED

TEST: STALE AUTHORITY
accepted=false
VERDICT=STALE_AUTHORITY_REJECTED

TEST: STALE EPOCH
accepted=false
VERDICT=STALE_EPOCH_REJECTED

TEST: TRANSPORT MIGRATION
old_transport=wifi
new_transport=lte
session_before=session-alpha
session_after=session-alpha
VERDICT=SESSION_IDENTITY_PRESERVED

TEST: AUTHORITY MIGRATION
VERDICT=AUTHORITY_MIGRATION_PRESERVED

TEST: CANONICAL HISTORY
VERDICT=CANONICAL_HISTORY_CONSISTENT

=== VALIDATION SUMMARY ===
canonical_commits=2

FINAL_VERDICT=VALIDATION_PASSED

---

Validation Philosophy

The purpose of the validation kit is not to prove that networks never fail.

The purpose is to demonstrate that execution correctness remains bounded and deterministic when failures occur.

Validation evidence should be:

- Observable
- Reproducible
- Deterministic
- Independently verifiable

---

What This Kit Demonstrates

This kit demonstrates:

- Deterministic commit admission
- Monotonic authority transitions
- Monotonic epoch progression
- Duplicate mutation containment
- Session continuity across transport changes

---

What This Kit Does Not Demonstrate

This kit does not prove:

- Production readiness
- Formal verification
- Cryptographic security
- Performance characteristics
- Regulatory compliance

Those require separate validation processes.

---

Status

Experimental validation harness for independent engineering review.

The protocol architecture and validation suite continue to evolve through staged testing and external evaluation.