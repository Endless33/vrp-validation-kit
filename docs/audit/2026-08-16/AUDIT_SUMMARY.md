# VRP Independent Trust Audit — Technical Summary

## Audit Identity

Repository:

`vrp-validation-kit`

Audited repository commit:

`db0e61e739b88ac9a923e2f595a4208f62ad80dd`

Audit date:

`2026-08-16`

Audit schema:

`vrp-independent-trust-audit-v1`

Final result:

**PASS**

Sealed phases:

**10 / 10**

Verification failures:

**0**

---

## 1. Reproducible Build Verification

The exact audited Git revision was exported into two independent
clean-room source trees.

Both source trees were independently tested and built.

Test results:

- Clean room A: `PASS`
- Clean room B: `PASS`
- Test exit code A: `0`
- Test exit code B: `0`

Four executable targets were independently produced.

### attack-suite

SHA-256, build A:

`303f0f6e945fcb71e3f0d1b66580b4f13716ea9dfe42e479aabf6edcbff72fd7`

SHA-256, build B:

`303f0f6e945fcb71e3f0d1b66580b4f13716ea9dfe42e479aabf6edcbff72fd7`

Result:

`IDENTICAL`

### evidence-verify

SHA-256, build A:

`ab66603f37fbf80b3bb4c39f896c411e2b9287a226ee8dbbc07b879593a014cf`

SHA-256, build B:

`ab66603f37fbf80b3bb4c39f896c411e2b9287a226ee8dbbc07b879593a014cf`

Result:

`IDENTICAL`

### vrp-runtime-scenario

SHA-256, build A:

`487ccb78e8a7c044cfd3ed5db18715e256bf0000f9a29c8b1cfc5d0526f9f545`

SHA-256, build B:

`487ccb78e8a7c044cfd3ed5db18715e256bf0000f9a29c8b1cfc5d0526f9f545`

Result:

`IDENTICAL`

### vrp-test

SHA-256, build A:

`43e01e39b82fc6649af8f64fb3b62efd16b2099f166359cbde81d5810fc2db4f`

SHA-256, build B:

`43e01e39b82fc6649af8f64fb3b62efd16b2099f166359cbde81d5810fc2db4f`

Result:

`IDENTICAL`

Reproducibility verdict:

**PASS**

---

## 2. Historical Baseline Forensics

Eight historical evidence runs were examined.

The first verification attempt identified a common operational
condition:

`verification.json already exists`

This was preserved as a forensic result rather than silently
overwriting the existing evidence.

The audit then re-verified copied evidence in isolated sandboxes.

Results:

- Runs examined: `8`
- Accepted: `2`
- Rejected: `6`
- Original evidence mutations detected: `0`

Valid baselines:

- `replay-attempt-20260815t073311z-4d3f33e5`
- `stale-authority-20260815t073135z-1ecc0e7c`

Selected adversarial-test baseline:

`replay-attempt-20260815t073311z-4d3f33e5`

Baseline status:

**VALID_BASELINE_AVAILABLE**

---

## 3. Frozen Baseline

The selected replay baseline was copied into the audit evidence
boundary and independently verified.

Subject evidence SHA-256:

`11e1456c88f9f7b7cb80eb95e21a01d2cddc13ffa613a85bc53d2fd1a8206b81`

Subject events SHA-256:

`a7b9f9bcd56c6aa620f7dc421c08dd7daeb4576339ceee3a1e78ff2d2fe8c27f`

Baseline verifier exit:

`0`

Baseline verdict:

**PASS**

Original evidence immutability:

**PASS**

---

## 4. Adversarial Evidence Mutation Matrix

Fifteen cases were executed:

- one unmodified control;
- fourteen adversarial mutations.

Results:

- Cases total: `15`
- Cases passed: `15`
- Cases failed: `0`

The control evidence was accepted.

Every adversarially modified case was rejected.

The tested mutation classes included:

1. evidence run-ID substitution;
2. replay-verdict tampering;
3. replay-counter tampering;
4. replay-event deletion;
5. event duplication;
6. event reordering;
7. event-sequence rollback;
8. continuity-reference substitution;
9. manifest-hash tampering;
10. event-stream truncation;
11. malformed evidence JSON;
12. missing subject evidence;
13. missing subject events;
14. manifest run-ID substitution.

Adversarial mutation verdict:

**PASS**

---

## 5. Runtime Observation Preflight

The audit environment confirmed availability of instrumentation required
for runtime observation.

Observed tooling included:

- `strace`
- `ss`
- `lsof`
- `tcpdump`
- `timeout`
- `sha256sum`
- `file`
- `readelf`
- `objdump`
- `strings`
- `ps`
- `pstree`
- `ip`
- `jq`
- `python3`

All four audited binaries were present.

Missing binaries:

`0`

Runtime observability preflight:

**PASS**

---

## 6. Controlled Side-Effect Observation

A preliminary `--help` execution profile was traced.

Across the four binaries:

- Network syscalls observed: `0`
- Connect calls observed: `0`
- DNS port-53 references: `0`
- Timeouts: `0`

This preliminary observation was followed by functional execution rather
than being treated as sufficient by itself.

---

## 7. Instrumented Functional Execution

A network-observation negative control was executed before interpreting
the functional traces.

The negative control generated:

- socket calls: `1`
- connect calls: `1`

Negative-control result:

**PASS**

The same observation mechanism was then used during functional execution
of the four audited binaries.

### attack-suite

Exit code:

`0`

Functional verdict:

`ATTACK_SUITE_PASSED`

Observed network syscalls:

`0`

Observed connect calls:

`0`

Observed DNS port-53 references:

`0`

### evidence-verify

Exit code:

`0`

Functional verdict:

`EVIDENCE_VERIFIED`

Observed network syscalls:

`0`

Observed connect calls:

`0`

Observed DNS port-53 references:

`0`

### vrp-runtime-scenario

Exit code:

`0`

Functional verdict:

`CONTINUITY_PRESERVED`

Observed network syscalls:

`0`

Observed connect calls:

`0`

Observed DNS port-53 references:

`0`

### vrp-test

Exit code:

`0`

Functional verdict:

`VALIDATION_PASSED`

Observed network syscalls:

`0`

Observed connect calls:

`0`

Observed DNS port-53 references:

`0`

Aggregate functional result:

- Binaries executed: `4`
- Timeouts: `0`
- Non-zero exits: `0`
- Network syscalls observed: `0`
- Connect calls observed: `0`
- DNS port-53 references: `0`

Functional verdict:

**PASS**

---

## 8. Repository Immutability

Repository tree SHA-256 before functional execution:

`c66e15c8a87bd6c1daa685661a1f8a86103b6ec03f59dcb16e2f04e00583edd4`

Repository tree SHA-256 after functional execution:

`c66e15c8a87bd6c1daa685661a1f8a86103b6ec03f59dcb16e2f04e00583edd4`

Repository-tree immutability:

**PASS**

Git-state identity before:

`dbc529e556afa2a3381d6fce011d7a553d1a2ec3834da1994da8d768878db31a`

Git-state identity after:

`dbc529e556afa2a3381d6fce011d7a553d1a2ec3834da1994da8d768878db31a`

Git-state immutability:

**PASS**

---

## 9. Cryptographic Audit Chain

The manifests produced by the preceding audit phases were subsequently
re-verified.

The final audit seal contains ten phase manifests.

Phases expected:

`10`

Phases sealed:

`10`

Verification failures:

`0`

Phase roots SHA-256:

`ed9022f140733f44fa9c3a92cf81c44154f6ec855e6554368537f049f287a122`

Final audit root SHA-256:

`bf49d7c13fb62da9fcc1da8fcdf3ee6121312c563a7fecb5928b5f60daa243ca`

Phase 4C manifest root SHA-256:

`2f13538d46a2a064e4b803f0af7c89520c775d132e57fc8f41922b8f17c8bc01`

Final verdict:

**PASS**

Seal integrity:

**PASS**

---

## 10. Security Interpretation

The audit provides reproducible evidence for the exact repository
revision and execution profiles covered by the test.

It establishes that:

- the tested source revision produced reproducible binaries in the two
  clean-room builds;
- the independently built binary pairs were byte-for-byte identical;
- the selected valid evidence baseline passed independent verification;
- fourteen adversarial evidence modifications were rejected;
- the unmodified control remained accepted;
- functional execution completed successfully for all four tested
  binaries;
- no network syscall, connect call, or DNS port-53 reference was observed
  during those covered functional executions;
- the same instrumentation successfully detected a deliberately generated
  network connection;
- the repository tree and Git state remained unchanged;
- the covered audit artifacts were cryptographically sealed and
  re-verified.

## Scope Boundary

This audit is not a universal proof that the software can never contain
or execute a backdoor.

Dynamic observation can establish what occurred during measured
execution paths. It cannot establish the behavior of every unexecuted
path under every possible input, environment, compiler, operating
system, configuration, or future revision.

The results therefore apply specifically to:

`db0e61e739b88ac9a923e2f595a4208f62ad80dd`

and to the artifacts and execution profiles described by this audit.

The evidence is intended to make those claims independently inspectable
rather than requiring trust in a marketing statement.