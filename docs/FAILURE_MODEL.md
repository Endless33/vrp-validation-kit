VRP Failure Model

Purpose

This document describes the failure conditions currently evaluated by the VRP validation suite.

The objective is not to prevent failures from occurring.

The objective is to ensure that failures do not corrupt canonical execution state.

Each failure condition is expected to produce deterministic and reproducible behavior.

---

Failure Classification

VRP treats failures as observable runtime events.

Failures are expected.

Incorrect execution is not.

The validation model focuses on preserving execution correctness despite transport instability, duplication, recovery events, and authority transitions.

---

Replay Packet

Failure

A packet that has already been admitted is received again.

Risk

Duplicate execution.

Expected Behavior

Replay packet
    ↓
Rejected

Validation Scenario

replay-storm

Expected Verdict

VERDICT=REPLAY_WINDOW_ENFORCED

---

Duplicate Mutation

Failure

The same logical mutation is submitted multiple times.

Risk

Multiple commits for a single logical operation.

Expected Behavior

Duplicate mutation
    ↓
Rejected

Expected Result

One logical mutation
may commit at most once.

---

Commit Replay

Failure

A previously committed operation is replayed.

Risk

Canonical history corruption.

Expected Behavior

Committed operation
    ↓
Replay attempt
    ↓
Rejected

Expected Result

Canonical history preserved

---

Stale Authority

Failure

A non-current authority attempts to mutate state.

Risk

Conflicting execution ownership.

Expected Behavior

Stale authority
    ↓
Rejected

Expected Result

Current authority preserved

---

Authority Rollback

Failure

An authority transition attempts to move to an older epoch.

Risk

Authority rollback.

Expected Behavior

epoch=10
candidate_epoch=5
    ↓
Rejected

Validation Scenario

authority-rollback

Expected Verdict

VERDICT=AUTHORITY_ROLLBACK_REJECTED

---

Stale Epoch

Failure

A mutation arrives from an older execution epoch.

Risk

Execution rollback.

Expected Behavior

Stale epoch
    ↓
Rejected

Expected Result

Monotonic epoch progression preserved

---

Transport Migration

Failure

The transport path changes during execution.

Examples:

- Wi-Fi → LTE
- LTE → Wi-Fi
- NAT rebinding
- Route migration

Risk

Session discontinuity.

Expected Behavior

Transport changes
    ↓
Session identity preserved

Expected Result

Execution continuity preserved

---

Authority Migration

Failure

Execution ownership transitions to a newer authority.

Risk

Dual ownership.

Expected Behavior

Old authority
    ↓
New authority
    ↓
Single owner preserved

Expected Result

Monotonic authority progression

---

Runtime Recovery

Failure

Runtime failure followed by recovery.

Risk

Loss of session state.

Expected Behavior

Snapshot
    ↓
Runtime failure
    ↓
Recovery
    ↓
Canonical state restored

Validation Scenario

runtime-recovery

Expected Verdict

VERDICT=SESSION_RECOVERY_PRESERVED

---

Canonical History Integrity

Failure

Recovery or replay attempts introduce history divergence.

Risk

Inconsistent execution state.

Expected Behavior

History validation
    ↓
Canonical history preserved

Expected Result

Single canonical execution history

---

Failure Matrix

Failure Condition| Expected Behavior
Replay Packet| Rejected
Duplicate Mutation| Rejected
Commit Replay| Rejected
Stale Authority| Rejected
Authority Rollback| Rejected
Stale Epoch| Rejected
Transport Migration| Session Preserved
Authority Migration| Monotonic Transition
Runtime Recovery| Session Preserved
Canonical History Integrity| History Preserved

---

Validation Philosophy

The purpose of validation is not to claim correctness.

The purpose of validation is to demonstrate correctness through observable runtime behavior.

Failures are intentionally introduced.

Execution correctness is expected to remain deterministic.

Validation evidence should be:

- Observable
- Reproducible
- Deterministic
- Independently verifiable