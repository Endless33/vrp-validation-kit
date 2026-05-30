External Validation Guide

Purpose

This document describes how an independent engineer can evaluate the validation artifacts contained in this repository.

No prior knowledge of VRP is required.

---

Step 1 — Review Architecture

Read:

docs/ARCHITECTURE_OVERVIEW.md

Objective:

Understand the execution model.

---

Step 2 — Review Failure Model

Read:

docs/FAILURE_MODEL.md

Objective:

Understand expected behavior under failure conditions.

---

Step 3 — Review Invariant Mapping

Read:

docs/FAILURE_INVARIANT_MAPPING.md

Objective:

Understand which invariants protect against which failures.

---

Step 4 — Execute Validation Harness

Run:

Linux:

./vrp-test-linux-amd64

Windows:

.\vrp-test-windows-amd64.exe

Expected result:

FINAL_VERDICT=VALIDATION_PASSED

---

Step 5 — Execute Runtime Scenario

Run:

Linux:

./vrp-runtime-scenario-linux-amd64

Windows:

.\vrp-runtime-scenario-windows-amd64.exe

Expected result:

FINAL_VERDICT=CONTINUITY_PRESERVED

---

Step 6 — Execute Replay Scenario

Run:

./vrp-core-runner-linux-amd64 --scenario replay-storm --packets 10000

Expected result:

VERDICT=REPLAY_WINDOW_ENFORCED

---

Step 7 — Execute Authority Rollback Scenario

Run:

./vrp-core-runner-linux-amd64 --scenario authority-rollback --epoch 5

Expected result:

VERDICT=AUTHORITY_ROLLBACK_REJECTED

---

Step 8 — Execute Recovery Scenario

Run:

./vrp-core-runner-linux-amd64 --scenario runtime-recovery

Expected result:

VERDICT=SESSION_RECOVERY_PRESERVED

---

Step 9 — Review Evidence

Compare:

- Observed verdicts
- Expected verdicts
- Runtime outputs
- Validation documents

---

Step 10 — Attempt Independent Evaluation

Questions worth exploring:

What assumptions are being made?

Which failure classes matter most?

Which validation areas should be extended?

What evidence is convincing?

What evidence is missing?

---

Technical Feedback

Technical criticism is encouraged.

The objective is not agreement.

The objective is independent evaluation of observable behavior.

---

Validation Philosophy

The fastest way to understand a validation artifact is not to read claims about it.

The fastest way is to execute it, inspect the output, and attempt to challenge the assumptions behind it.