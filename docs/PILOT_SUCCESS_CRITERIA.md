Pilot Success Criteria

Purpose

This document defines the criteria used to evaluate whether a pilot has been technically successful.

The objective is not to prove production readiness.

The objective is to determine whether execution correctness remains preserved under selected validation conditions.

---

Replay Validation

Success criteria:

- Replay scenario executed
- Replay rejection observed
- Replay verdict confirmed

Expected verdict:

VERDICT=REPLAY_WINDOW_ENFORCED

---

Authority Validation

Success criteria:

- Authority rollback scenario executed
- Epoch monotonicity preserved
- Rollback rejection observed

Expected verdict:

VERDICT=AUTHORITY_ROLLBACK_REJECTED

---

Recovery Validation

Success criteria:

- Runtime recovery scenario executed
- Snapshot restoration verified
- Session identity preserved
- History preserved

Expected verdict:

VERDICT=SESSION_RECOVERY_PRESERVED

---

Session Continuity Validation

Success criteria:

- Session continuity preserved
- No unintended session recreation observed
- Identity remained stable across validation scope

Expected result:

SESSION_IDENTITY_PRESERVED

---

Evidence Validation

Success criteria:

- Runtime evidence collected
- Verdicts recorded
- Results reproducible
- Validation artifacts preserved

---

Invariant Validation

Success criteria:

- No invariant violations observed
- Canonical history preserved
- Monotonic authority progression preserved
- Monotonic epoch progression preserved

---

Technical Pilot Success

A pilot is considered technically successful when:

- Expected verdicts are observed
- Validation scenarios execute successfully
- Evidence is reproducible
- Canonical execution correctness remains preserved
- No invariant violations are observed

---

Next-Step Eligibility

A pilot may proceed to further evaluation when:

- Technical success criteria are satisfied
- Validation evidence has been reviewed
- Remaining risks are documented
- Additional objectives are clearly defined