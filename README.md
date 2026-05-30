VRP Validation Kit

VRP Validation Kit is a standalone executable validation harness for testing core VRP continuity invariants.

The purpose of this repository is not to expose implementation details.

The purpose is to provide a reproducible environment where engineers can execute validation scenarios and inspect runtime evidence directly.

---

What Is Being Validated

The validation kit focuses on execution correctness under unreliable network conditions.

The following invariants are tested:

- Duplicate logical mutations must not commit twice
- Stale authority decisions must be rejected
- Stale epochs must be rejected
- Session identity must survive transport changes
- Canonical execution must remain deterministic
- Runtime evidence must be reproducible

---

Why This Exists

Most networking demonstrations focus on connectivity.

VRP focuses on execution continuity.

Transport may fail.

Execution correctness must remain preserved.

This validation kit allows independent engineers to observe the resulting behavior directly.

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

./vrp-test

Example output:

=== VRP VALIDATION KIT ===

TEST: duplicate mutation

RESULT:
accepted=1
rejected=1

VERDICT:
DUPLICATE_COMMIT_REJECTED

FINAL_VERDICT:
VALIDATION_PASSED

---

Validation Philosophy

The goal is not to prove that networks never fail.

The goal is to verify that execution correctness remains bounded and deterministic when failures occur.

Validation evidence should be observable, reproducible, and independently verifiable.

---

Status

Experimental validation harness.

The protocol and runtime architecture continue to evolve through staged validation and external review.