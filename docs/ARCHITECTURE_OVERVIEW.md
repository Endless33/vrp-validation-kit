VRP Architecture Overview

Purpose

VRP focuses on execution correctness under transport instability.

The objective is not to guarantee that networks never fail.

The objective is to ensure that execution state remains deterministic when failures occur.

---

Core Principle

Transport may fail.

Execution correctness must remain deterministic.

---

Execution Pipeline

Transport
    ↓
Session Identity
    ↓
Replay Window
    ↓
Authority Validation
    ↓
Epoch Validation
    ↓
Commit Admission
    ↓
Canonical History
    ↓
Snapshot Recovery

Each stage exists to prevent invalid mutations from entering canonical execution history.

---

Session Identity

Session identity is independent from transport.

A transport migration must not automatically create a new logical session.

Examples:

- Wi-Fi → LTE
- LTE → Wi-Fi
- NAT rebinding
- Path migration

Expected behavior:

Session identity preserved

---

Replay Protection

Replay protection prevents duplicate execution.

A logical mutation may commit at most once.

Expected behavior:

Duplicate packet
    ↓
Rejected

---

Authority Model

Authority is epoch-bound.

Authority transitions must be monotonic.

Rollback is prohibited.

Expected behavior:

epoch=10
candidate_epoch=5

Rejected

---

Recovery Model

Recovery restores canonical state from snapshots.

Recovery must preserve:

- Session identity
- Authority state
- Epoch state
- Commit history

Expected behavior:

Snapshot
    ↓
Recovery
    ↓
Canonical state preserved

---

Validation Philosophy

Observable runtime behavior is preferred over conceptual claims.

Validation artifacts should be:

- Reproducible
- Deterministic
- Independently verifiable
- Observable