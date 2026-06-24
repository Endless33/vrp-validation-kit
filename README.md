Quick Evaluation

Clone the repository:

git clone https://github.com/Endless33/vrp-validation-kit.git

cd vrp-validation-kit

---

Validation Harness

Execute:

go run ./cmd/vrp-test

Expected result:

FINAL_VERDICT=VALIDATION_PASSED

---

Integrated Runtime Scenario

Execute:

go run ./cmd/vrp-runtime-scenario

Expected result:

FINAL_VERDICT=CONTINUITY_PRESERVED

---

External Attack Suite

Execute:

go run ./cmd/attack-suite

Expected result:

FINAL_VERDICT=ATTACK_SUITE_PASSED

---

What The Attack Suite Tests

The attack suite attempts to violate observable runtime invariants through reproducible scenarios.

Current attack scenarios:

- Replay Storm
- Duplicate Commit
- Authority Rollback
- Epoch Rollback
- Authority Race
- Transport Migration Storm
- Runtime Recovery
- Canonical History Rewrite

Expected verdicts:

REPLAY_WINDOW_ENFORCED
DUPLICATE_COMMIT_REJECTED
AUTHORITY_ROLLBACK_REJECTED
STALE_EPOCH_REJECTED
AUTHORITY_RACE_RESOLVED
TRANSPORT_MIGRATION_PRESERVED
SESSION_RECOVERY_PRESERVED
CANONICAL_HISTORY_REWRITE_REJECTED

---

External Review Workflow

Suggested review process:

1. Clone repository
2. Read README
3. Execute validation harness
4. Execute runtime scenario
5. Execute attack suite
6. Review verdicts
7. Review documentation
8. Attempt independent validation

The objective is not agreement.

The objective is reproducible evaluation.

---

What Is Included

- Validation harness
- Runtime scenario
- Attack suite
- Validation documentation
- Failure models
- Invariant mappings
- Pilot documentation
- Evaluation artifacts

---

What Is Not Included

This repository does not contain:

- Production runtime
- Private runtime internals
- Proprietary authority logic
- Customer-specific deployments
- Protected implementation mechanisms

The purpose of this repository is validation of observable behavior rather than disclosure of implementation details.