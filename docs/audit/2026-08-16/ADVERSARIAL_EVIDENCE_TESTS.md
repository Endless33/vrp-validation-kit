# VRP Adversarial Evidence Mutation Tests

## Audit Scope

This document records adversarial mutation testing performed against a
previously accepted and frozen VRP public evidence bundle.

Audit date:

`2026-08-16`

Repository:

`vrp-validation-kit`

Audited repository commit:

`db0e61e739b88ac9a923e2f595a4208f62ad80dd`

Audit schema:

`vrp-independent-trust-audit-v1`

Audit phase:

`Phase 2D — Adversarial Evidence Mutation Matrix`

Phase verdict:

**PASS**

---

## 1. Objective

The objective of this phase was to test whether the public evidence
verification pipeline accepts only an unchanged valid baseline while
rejecting deliberately corrupted, contradictory, incomplete, reordered,
duplicated, substituted, or structurally invalid evidence.

The principal invariant was:

> A valid evidence bundle must remain accepted when unchanged, while
> material mutations that violate the verified evidence contract must
> not be silently accepted.

This phase therefore included both:

1. a positive control;
2. multiple negative adversarial mutations.

---

## 2. Frozen Baseline

The baseline was selected during immutable baseline re-verification and
then copied into a frozen audit workspace before mutation testing.

Baseline run:

`replay-attempt-20260815t073311z-4d3f33e5`

Baseline scenario:

`replay-attempt`

Baseline verification:

**PASS**

Original baseline immutability:

**PASS**

Original tree root SHA-256:

`8d3acaeab9bbc6865b5190a17d0f09432557478012105deabbde6ab1b80962a7`

Frozen tree root SHA-256:

`3de36b7463865fdb4143fc545133840b2effeeaf5db9e3badf4135266f653ae9`

---

## 3. Baseline Core Artifact Identity

### Manifest

File:

`manifest.json`

SHA-256:

`77a45a8139709ba57ccb374d924a5b7085c37263d73ca37b2068fdf09635cbc2`

### Subject Evidence

File:

`subject/subject-evidence.json`

SHA-256:

`11e1456c88f9f7b7cb80eb95e21a01d2cddc13ffa613a85bc53d2fd1a8206b81`

### Subject Events

File:

`subject/subject-events.jsonl`

SHA-256:

`a7b9f9bcd56c6aa620f7dc421c08dd7daeb4576339ceee3a1e78ff2d2fe8c27f`

---

## 4. Baseline Evidence Properties

The accepted baseline reported:

`completion_state = complete`

`public_verdict = evidence-ready`

`final_active_path = wifi`

Observed summary:

| Property | Value |
|---|---:|
| Successful progress events | 10 |
| Path transitions | 0 |
| Accepted mutations | 1 |
| Duplicate accepted mutations | 0 |
| Stale-authority rejections | 0 |
| Replay rejections | 1 |

The baseline event stream contained:

`12 events`

The accepted mutation occurred at event sequence:

`6`

The replay rejection occurred at event sequence:

`7`

Replay event identifier:

`replay-attempt-001`

Replay public verdict:

`rejected-replay`

---

## 5. Test Method

Each adversarial case was executed against an isolated copy of the
frozen baseline.

The original evidence run was not modified.

For every case the audit recorded:

- case identifier;
- expected verifier behavior;
- actual verifier behavior;
- verifier exit code;
- verifier verdict;
- pre-mutation tree root;
- post-mutation tree root;
- final test result.

The test itself passed only when actual verifier behavior matched the
expected behavior.

---

## 6. Positive Control

### Case 00 — Unmodified Control

Case:

`00-control`

Expected:

`ACCEPT`

Actual:

`ACCEPT`

Verifier exit:

`0`

Verifier verdict:

`PASS`

Test result:

**PASS**

This establishes the positive control for the mutation matrix.

The verifier continued to accept the valid, unmodified evidence bundle.

---

## 7. Evidence Run-ID Substitution

### Case 01

Mutation:

The run identifier represented by the subject evidence was substituted.

Expected:

`REJECT`

Actual:

`REJECT`

Verifier exit:

`1`

Verifier verdict:

`FAIL`

Test result:

**PASS**

The altered evidence identity was not silently accepted.

---

## 8. Replay Verdict Tampering

### Case 02

Mutation:

The replay-related public verdict in the evidence stream was altered.

Expected:

`REJECT`

Actual:

`REJECT`

Verifier exit:

`1`

Verifier verdict:

`FAIL`

Test result:

**PASS**

The verifier rejected the modified replay outcome.

---

## 9. Replay Counter Tampering

### Case 03

Mutation:

The replay rejection summary counter was modified so that the summary no
longer represented the valid baseline.

Expected:

`REJECT`

Actual:

`REJECT`

Verifier exit:

`1`

Verifier verdict:

`FAIL`

Test result:

**PASS**

The inconsistent summary was rejected.

---

## 10. Replay Event Deletion

### Case 04

Mutation:

The replay rejection event was removed from the event stream.

Expected:

`REJECT`

Actual:

`REJECT`

Verifier exit:

`1`

Verifier verdict:

`FAIL`

Test result:

**PASS**

Deletion of the relevant event was detected by verification.

---

## 11. Event Duplication

### Case 05

Mutation:

An event was duplicated within the evidence stream.

Expected:

`REJECT`

Actual:

`REJECT`

Verifier exit:

`1`

Verifier verdict:

`FAIL`

Test result:

**PASS**

The duplicated event stream was not accepted as valid evidence.

---

## 12. Event Reordering

### Case 06

Mutation:

Events were reordered relative to the accepted baseline sequence.

Expected:

`REJECT`

Actual:

`REJECT`

Verifier exit:

`1`

Verifier verdict:

`FAIL`

Test result:

**PASS**

The verifier rejected the reordered event stream.

---

## 13. Sequence Rollback

### Case 07

Mutation:

An event sequence value was modified to represent a rollback or
non-monotonic sequence condition.

Expected:

`REJECT`

Actual:

`REJECT`

Verifier exit:

`1`

Verifier verdict:

`FAIL`

Test result:

**PASS**

The invalid sequence condition was rejected.

---

## 14. Continuity Reference Substitution

### Case 08

Mutation:

The continuity reference was substituted so that the evidence no longer
represented the original continuity identity.

Expected:

`REJECT`

Actual:

`REJECT`

Verifier exit:

`1`

Verifier verdict:

`FAIL`

Test result:

**PASS**

The substituted continuity identity was not accepted.

---

## 15. Manifest Hash Tampering

### Case 09

Mutation:

A hash recorded by the run manifest was deliberately altered.

Expected:

`REJECT`

Actual:

`REJECT`

Verifier exit:

`1`

Verifier verdict:

`FAIL`

Test result:

**PASS**

The verifier rejected the manifest whose recorded artifact identity no
longer matched the expected evidence.

---

## 16. Event Stream Truncation

### Case 10

Mutation:

The subject event stream was truncated.

Expected:

`REJECT`

Actual:

`REJECT`

Verifier exit:

`2`

Verifier verdict:

`INCOMPLETE`

Test result:

**PASS**

The incomplete event stream was not treated as valid evidence.

The distinction between `FAIL` and `INCOMPLETE` is preserved here
because malformed or missing evidence is not equivalent to a complete
bundle that fails an invariant.

---

## 17. Malformed Evidence JSON

### Case 11

Mutation:

The subject evidence JSON was deliberately made structurally invalid.

Expected:

`REJECT`

Actual:

`REJECT`

Verifier exit:

`2`

Verifier verdict:

`INCOMPLETE`

Test result:

**PASS**

Malformed evidence did not enter the accepted state.

---

## 18. Missing Subject Evidence

### Case 12

Mutation:

`subject/subject-evidence.json` was removed from the mutation sandbox.

Expected:

`REJECT`

Actual:

`REJECT`

Verifier exit:

`2`

Verifier verdict:

`INCOMPLETE`

Test result:

**PASS**

The verifier did not accept a bundle without the required subject
evidence artifact.

---

## 19. Missing Subject Events

### Case 13

Mutation:

`subject/subject-events.jsonl` was removed from the mutation sandbox.

Expected:

`REJECT`

Actual:

`REJECT`

Verifier exit:

`2`

Verifier verdict:

`INCOMPLETE`

Test result:

**PASS**

The verifier did not accept a bundle without the required subject event
stream.

---

## 20. Manifest Run-ID Substitution

### Case 14

Mutation:

The run identifier represented by the manifest was substituted.

Expected:

`REJECT`

Actual:

`REJECT`

Verifier exit:

`1`

Verifier verdict:

`FAIL`

Test result:

**PASS**

The inconsistent manifest identity was rejected.

---

## 21. Adversarial Test Matrix

| Case | Mutation | Expected | Actual | Exit | Verdict | Test |
|---|---|---|---|---:|---|---|
| 00 | Unmodified control | ACCEPT | ACCEPT | 0 | PASS | PASS |
| 01 | Evidence run-ID substitution | REJECT | REJECT | 1 | FAIL | PASS |
| 02 | Replay verdict tamper | REJECT | REJECT | 1 | FAIL | PASS |
| 03 | Replay counter tamper | REJECT | REJECT | 1 | FAIL | PASS |
| 04 | Replay event deletion | REJECT | REJECT | 1 | FAIL | PASS |
| 05 | Event duplication | REJECT | REJECT | 1 | FAIL | PASS |
| 06 | Event reorder | REJECT | REJECT | 1 | FAIL | PASS |
| 07 | Sequence rollback | REJECT | REJECT | 1 | FAIL | PASS |
| 08 | Continuity reference substitution | REJECT | REJECT | 1 | FAIL | PASS |
| 09 | Manifest hash tamper | REJECT | REJECT | 1 | FAIL | PASS |
| 10 | Events truncation | REJECT | REJECT | 2 | INCOMPLETE | PASS |
| 11 | Malformed evidence JSON | REJECT | REJECT | 2 | INCOMPLETE | PASS |
| 12 | Missing subject evidence | REJECT | REJECT | 2 | INCOMPLETE | PASS |
| 13 | Missing subject events | REJECT | REJECT | 2 | INCOMPLETE | PASS |
| 14 | Manifest run-ID substitution | REJECT | REJECT | 1 | FAIL | PASS |

Total cases:

`15`

Positive controls:

`1`

Adversarial mutation cases:

`14`

Cases passed:

`15`

Cases failed:

`0`

Phase verdict:

**PASS**

---

## 22. What This Demonstrates

Within the tested mutation matrix, the verifier exhibited fail-closed
behavior.

The unchanged valid baseline was accepted.

Every deliberately modified negative case was rejected or classified as
incomplete.

The tested mutation classes covered:

- identity substitution;
- replay-result tampering;
- summary-counter tampering;
- event deletion;
- event duplication;
- event reordering;
- sequence rollback;
- continuity-reference substitution;
- manifest hash tampering;
- stream truncation;
- malformed JSON;
- required artifact removal;
- manifest identity substitution.

No tested adversarial mutation produced an unexpected accepted result.

---

## 23. Important Security Boundary

This audit must not be interpreted as proof that every possible evidence
forgery, implementation defect, compromise, backdoor, or attack has been
eliminated.

The result is narrower and reproducible:

> For the exact audited commit, frozen baseline, verifier, and 14
> adversarial mutation classes exercised by this audit, all expected
> rejection conditions were observed.

This distinction is intentional.

Security evidence should describe what was actually tested rather than
claim universal absence of vulnerabilities.

---

## 24. Phase Evidence Seal

Phase 2D report SHA-256:

`adb69849a275eff230308e1eed9898856ec4672df76d0a42e63b03b41b97a0c0`

Phase 2D result SHA-256:

`07c3143a38bb3c1a0235bd79e0f73a805ff8d86de8976c5bfcae9c98ee70af47`

Phase 2D root SHA-256:

`1357dc69fe186cd2e9ad8abdcb517774fabba1d10ede7045d9557ec8dfe1110e`

The Phase 2D root was subsequently incorporated into the sealed final
audit chain.

---

## 25. Final Audit Binding

Audited repository commit:

`db0e61e739b88ac9a923e2f595a4208f62ad80dd`

Final phase-roots SHA-256:

`ed9022f140733f44fa9c3a92cf81c44154f6ec855e6554368537f049f287a122`

Final audit root SHA-256:

`bf49d7c13fb62da9fcc1da8fcdf3ee6121312c563a7fecb5928b5f60daa243ca`

Final audit verdict:

**PASS**

---

## Conclusion

The adversarial evidence mutation phase completed successfully.

The valid control remained accepted.

All 14 deliberately corrupted negative cases were prevented from
producing an accepted verification result.

**ADVERSARIAL MUTATION MATRIX: PASS**

**CASES: 15 / 15**

**UNEXPECTED ACCEPTANCES: 0**

**BASELINE IMMUTABILITY: PASS**