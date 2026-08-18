Pilot Failure Checklist

Purpose

This checklist provides a structured validation workflow during pilot evaluations.

The objective is to verify that execution correctness remains preserved under expected failure conditions.

---

Replay Validation

- [ ] Replay scenario executed
- [ ] Replay verdict collected
- [ ] Replay rejection confirmed
- [ ] Evidence recorded

Expected verdict:

VERDICT=REPLAY_WINDOW_ENFORCED

---

Authority Validation

- [ ] Authority rollback scenario executed
- [ ] Rollback rejection confirmed
- [ ] Epoch monotonicity verified
- [ ] Evidence recorded

Expected verdict:

VERDICT=AUTHORITY_ROLLBACK_REJECTED

---

Recovery Validation

- [ ] Recovery scenario executed
- [ ] Snapshot restoration verified
- [ ] Session continuity verified
- [ ] History preservation verified
- [ ] Evidence recorded

Expected verdict:

VERDICT=SESSION_RECOVERY_PRESERVED

---

Transport Validation

- [ ] Transport migration evaluated
- [ ] Session identity preserved
- [ ] Evidence recorded

Expected result:

SESSION_IDENTITY_PRESERVED

---

Validation Evidence

- [ ] Runtime logs collected
- [ ] Verdicts recorded
- [ ] Failure observations documented
- [ ] Reproduction steps documented

---

Pilot Completion Criteria

A pilot is considered technically successful when:

- All selected validation scenarios execute successfully
- Expected verdicts are observed
- Execution correctness remains preserved
- Evidence is reproducible
- No invariant violations are observed