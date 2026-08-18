Failure Invariant Mapping

Purpose

This document maps failure conditions to the invariants responsible for preserving execution correctness.

The objective is to make protection mechanisms explicit and observable.

---

Failure Condition| Protected By| Expected Result
Replay Packet| Replay Window Invariant| Packet Rejected
Duplicate Mutation| Commit Uniqueness Invariant| Single Commit Preserved
Commit Replay| Canonical Commit Invariant| Replay Rejected
Stale Authority| Authority Ownership Invariant| Mutation Rejected
Authority Rollback| Monotonic Authority Invariant| Rollback Rejected
Stale Epoch| Monotonic Epoch Invariant| Mutation Rejected
Transport Migration| Session Identity Invariant| Session Preserved
Authority Migration| Monotonic Authority Invariant| Single Owner Preserved
Runtime Recovery| Canonical Recovery Invariant| Session Restored
History Divergence| Canonical History Invariant| History Preserved

---

Execution Model

Failure
    ↓
Invariant
    ↓
Admission Decision
    ↓
Verdict

Failures are expected.

Invariant violations are not.

---

Objective

The purpose of validation is not to demonstrate that failures never occur.

The purpose is to demonstrate that failures cannot violate canonical execution correctness.