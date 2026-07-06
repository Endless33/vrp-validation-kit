VRP External Validation Kit v1.0

A standalone validation environment focused on observable runtime behavior rather than implementation details.

---

Repository

https://github.com/Endless33/vrp-validation-kit

Official Release

https://github.com/Endless33/vrp-validation-kit/releases/tag/v1.0.0

---

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

Evidence Verification

Execute:

go run ./cmd/evidence-verify --file evidence/sample/core-evidence.json

Expected result:

FINAL_VERDICT=EVIDENCE_VERIFIED

---

Tamper Rejection

Execute:

go run ./cmd/evidence-verify --file evidence/sample/tampered-evidence.json

Expected result:

FINAL_VERDICT=EVIDENCE_VERIFY_FAILED

---

What The Attack Suite Tests

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

- REPLAY_WINDOW_ENFORCED
- DUPLICATE_COMMIT_REJECTED
- AUTHORITY_ROLLBACK_REJECTED
- STALE_EPOCH_REJECTED
- AUTHORITY_RACE_RESOLVED
- TRANSPORT_MIGRATION_PRESERVED
- SESSION_RECOVERY_PRESERVED
- CANONICAL_HISTORY_REWRITE_REJECTED

---

Validation Coverage

Current validation coverage includes:

- Replay containment
- Duplicate commit rejection
- Authority rollback rejection
- Epoch rollback rejection
- Authority race resolution
- Runtime recovery preservation
- Transport migration preservation
- Canonical history protection
- Evidence bundle verification
- Evidence tamper detection

---

Tested Environments

Validation has been reproduced on:

- Windows 11
- Oracle Linux
- Android Termux

The same observable verdicts were produced across all tested environments.

---

External Review Workflow

Suggested review process:

1. Clone repository
2. Read README
3. Execute validation harness
4. Execute runtime scenario
5. Execute attack suite
6. Execute evidence verification
7. Execute tamper verification
8. Review verdicts
9. Review documentation
10. Attempt independent validation

The objective is not agreement.

The objective is reproducible evaluation.

---

What Is Included

- Validation harness
- Runtime scenario
- External attack suite
- Evidence verifier
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

---

Reporting Issues

Use the official v1.0.0 release when evaluating results.

If you modify the code, include the diff.

If the unmodified release fails, provide:

- exact command
- output
- environment
- commit hash

Independent criticism is more valuable than agreement.

---

## Challenge The Model

The purpose of this repository is not passive observation.

Run it.

Inspect it.

Challenge it.

If you believe a validation path is incorrect, open an issue and provide:

- environment
- result observed
- failure cases attempted
- verdict observed
- expected behavior
- actual behavior

Evidence-backed criticism is more valuable than agreement.

---

# VRP Public Validation Kit

This repository provides everything required for a public engineering evaluation of VRP.

## Resources

- Public Pilot Deployment Guide
- Validation Kit
- Example Adapter
- Evidence Reports
- Pilot Application

## Documentation

➡️ See: `docs/PUBLIC_PILOT_DEPLOYMENT_GUIDE.md`

## Pilot Application

https://tally.so/r/ZjQLN0

## Contact

jumpingvpn@proton.me