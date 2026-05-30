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
- Replay window enforcement
- Authority rollback rejection
- Commit replay rejection
- Session recovery preservation
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

Integrated Runtime Scenario

go run ./cmd/vrp-runtime-scenario

Expected verdict:

FINAL_VERDICT=CONTINUITY_PRESERVED

---

Example Output

=== VRP VALIDATION KIT ===
Runtime: standalone invariant validation harness

TEST: DUPLICATE MUTATION
VERDICT=DUPLICATE_COMMIT_REJECTED

TEST: STALE AUTHORITY
VERDICT=STALE_AUTHORITY_REJECTED

TEST: STALE EPOCH
VERDICT=STALE_EPOCH_REJECTED

TEST: TRANSPORT MIGRATION
VERDICT=SESSION_IDENTITY_PRESERVED

TEST: AUTHORITY MIGRATION
VERDICT=AUTHORITY_MIGRATION_PRESERVED

TEST: REPLAY WINDOW VALIDATION
VERDICT=REPLAY_WINDOW_ENFORCED

TEST: AUTHORITY ROLLBACK REJECTION
VERDICT=AUTHORITY_ROLLBACK_REJECTED

TEST: COMMIT REPLAY REJECTION
VERDICT=COMMIT_REPLAY_REJECTED

TEST: SESSION RECOVERY VALIDATION
VERDICT=SESSION_RECOVERY_PRESERVED

TEST: CANONICAL HISTORY
VERDICT=CANONICAL_HISTORY_CONSISTENT

=== VALIDATION SUMMARY ===
canonical_commits=3

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
- Replay containment
- Monotonic authority transitions
- Authority rollback rejection
- Monotonic epoch progression
- Duplicate mutation containment
- Commit replay protection
- Session continuity across transport changes
- Snapshot-based session recovery
- Canonical execution history preservation

---

What This Kit Does Not Demonstrate

This kit does not prove:

- Production readiness
- Formal verification
- Cryptographic security
- Performance characteristics
- Regulatory compliance
- Resistance to all adversarial conditions

Those require separate validation processes.

---

Validation Evidence

The validation kit has been successfully executed in an independent Linux environment.

Observed result:

FINAL_VERDICT=VALIDATION_PASSED

This demonstrates that the repository can be cloned, built, and executed without modification while producing deterministic validation results.

---

Status

Current validation status:

VALIDATION_PASSED

The protocol architecture and validation suite continue to evolve through staged testing and external engineering review.