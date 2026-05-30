Failure Injection Model

Purpose

Validation requires deliberate failure introduction.

This document describes the failure classes intentionally injected into the validation environment.

---

Replay Injection

Injected Failure

A previously observed packet is replayed repeatedly.

Expected Behavior

Replay
    ↓
Replay Window
    ↓
Rejected

Expected Verdict

VERDICT=REPLAY_WINDOW_ENFORCED

---

Authority Rollback Injection

Injected Failure

A candidate authority attempts to move execution ownership to an older epoch.

Expected Behavior

epoch=10
candidate_epoch=5
    ↓
Rejected

Expected Verdict

VERDICT=AUTHORITY_ROLLBACK_REJECTED

---

Recovery Injection

Injected Failure

Runtime failure followed by snapshot restoration.

Expected Behavior

Snapshot
    ↓
Runtime Failure
    ↓
Recovery
    ↓
State Preserved

Expected Verdict

VERDICT=SESSION_RECOVERY_PRESERVED

---

Future Injection Areas

Potential future failure classes:

- Transport oscillation
- Transport migration storms
- Authority churn
- Snapshot aging
- Long-duration downtime
- Resource pressure
- Multi-authority recovery

---

Validation Philosophy

Failure injection is used to validate observable runtime behavior.

Injected failures should produce deterministic and reproducible outcomes.