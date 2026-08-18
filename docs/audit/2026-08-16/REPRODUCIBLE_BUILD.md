# VRP Reproducible Build Verification

## Audit Scope

This document records the reproducible-build verification performed as
part of the VRP Independent Trust Audit.

Audit date:

`2026-08-16`

Repository:

`vrp-validation-kit`

Audited repository commit:

`db0e61e739b88ac9a923e2f595a4208f62ad80dd`

Audit schema:

`vrp-independent-trust-audit-v1`

Audit phase:

`Phase 1 — Dual Clean-Room Reproducible Build`

Final phase verdict:

**PASS**

---

## 1. Objective

The objective of this phase was to determine whether the exact audited
source revision could independently produce byte-identical executable
artifacts when built from two separately exported clean-room source
trees.

The verification procedure was designed around the following invariant:

> The same audited source revision, built independently under the same
> recorded build environment and procedure, must produce identical
> executable artifacts.

A successful result reduces ambiguity between the reviewed source
revision and the binaries produced from that revision.

---

## 2. Source Revision

The exact Git commit used for both clean-room builds was:

`db0e61e739b88ac9a923e2f595a4208f62ad80dd`

The commit was exported independently into:

- Clean Room A
- Clean Room B

The exported source trees were checked before compilation.

Source-tree verification:

**PASS**

---

## 3. Discovered Build Targets

Four executable targets were discovered and included in the
reproducibility test.

### Target 1

Package:

`github.com/Endless33/vrp-validation-kit/cmd/attack-suite`

Binary:

`attack-suite`

### Target 2

Package:

`github.com/Endless33/vrp-validation-kit/cmd/evidence-verify`

Binary:

`evidence-verify`

### Target 3

Package:

`github.com/Endless33/vrp-validation-kit/cmd/vrp-runtime-scenario`

Binary:

`vrp-runtime-scenario`

### Target 4

Package:

`github.com/Endless33/vrp-validation-kit/cmd/vrp-test`

Binary:

`vrp-test`

Total targets:

`4`

---

## 4. Independent Test Execution

Tests were executed independently against both clean-room source trees
before binary comparison.

### Clean Room A

Test exit code:

`0`

Result:

**PASS**

### Clean Room B

Test exit code:

`0`

Result:

**PASS**

The tested packages completed without test execution failure.

---

## 5. Independent Builds

Each of the four executable targets was compiled separately from Clean
Room A and Clean Room B.

The resulting binaries were then compared using:

- SHA-256 digest;
- binary size;
- byte-for-byte identity.

No binary mismatch was detected.

Binary failures:

`0`

---

## 6. attack-suite

Package:

`github.com/Endless33/vrp-validation-kit/cmd/attack-suite`

### Clean Room A

SHA-256:

`303f0f6e945fcb71e3f0d1b66580b4f13716ea9dfe42e479aabf6edcbff72fd7`

Size:

`2481925 bytes`

### Clean Room B

SHA-256:

`303f0f6e945fcb71e3f0d1b66580b4f13716ea9dfe42e479aabf6edcbff72fd7`

Size:

`2481925 bytes`

Comparison:

**IDENTICAL**

---

## 7. evidence-verify

Package:

`github.com/Endless33/vrp-validation-kit/cmd/evidence-verify`

### Clean Room A

SHA-256:

`ab66603f37fbf80b3bb4c39f896c411e2b9287a226ee8dbbc07b879593a014cf`

Size:

`3467829 bytes`

### Clean Room B

SHA-256:

`ab66603f37fbf80b3bb4c39f896c411e2b9287a226ee8dbbc07b879593a014cf`

Size:

`3467829 bytes`

Comparison:

**IDENTICAL**

---

## 8. vrp-runtime-scenario

Package:

`github.com/Endless33/vrp-validation-kit/cmd/vrp-runtime-scenario`

### Clean Room A

SHA-256:

`487ccb78e8a7c044cfd3ed5db18715e256bf0000f9a29c8b1cfc5d0526f9f545`

Size:

`2477008 bytes`

### Clean Room B

SHA-256:

`487ccb78e8a7c044cfd3ed5db18715e256bf0000f9a29c8b1cfc5d0526f9f545`

Size:

`2477008 bytes`

Comparison:

**IDENTICAL**

---

## 9. vrp-test

Package:

`github.com/Endless33/vrp-validation-kit/cmd/vrp-test`

### Clean Room A

SHA-256:

`43e01e39b82fc6649af8f64fb3b62efd16b2099f166359cbde81d5810fc2db4f`

Size:

`2483275 bytes`

### Clean Room B

SHA-256:

`43e01e39b82fc6649af8f64fb3b62efd16b2099f166359cbde81d5810fc2db4f`

Size:

`2483275 bytes`

Comparison:

**IDENTICAL**

---

## 10. Binary Format Observation

The produced executables were identified as Linux x86-64 ELF
executables.

Observed properties included:

- ELF 64-bit;
- LSB executable;
- x86-64;
- statically linked;
- debug information present;
- not stripped.

This observation applies to the artifacts generated during this audit
environment and should not be generalized to binaries produced by other
build configurations.

---

## 11. Reproducibility Matrix

| Binary | Build A SHA-256 | Build B SHA-256 | Size Match | Result |
|---|---|---|---|---|
| `attack-suite` | `303f0f6e945fcb71e3f0d1b66580b4f13716ea9dfe42e479aabf6edcbff72fd7` | `303f0f6e945fcb71e3f0d1b66580b4f13716ea9dfe42e479aabf6edcbff72fd7` | YES | IDENTICAL |
| `evidence-verify` | `ab66603f37fbf80b3bb4c39f896c411e2b9287a226ee8dbbc07b879593a014cf` | `ab66603f37fbf80b3bb4c39f896c411e2b9287a226ee8dbbc07b879593a014cf` | YES | IDENTICAL |
| `vrp-runtime-scenario` | `487ccb78e8a7c044cfd3ed5db18715e256bf0000f9a29c8b1cfc5d0526f9f545` | `487ccb78e8a7c044cfd3ed5db18715e256bf0000f9a29c8b1cfc5d0526f9f545` | YES | IDENTICAL |
| `vrp-test` | `43e01e39b82fc6649af8f64fb3b62efd16b2099f166359cbde81d5810fc2db4f` | `43e01e39b82fc6649af8f64fb3b62efd16b2099f166359cbde81d5810fc2db4f` | YES | IDENTICAL |

Binary comparison failures:

`0`

Reproducibility verdict:

**PASS**

---

## 12. Phase Evidence Seal

The Phase 1 evidence was collected into:

`PHASE1-SHA256SUMS`

SHA-256 of the Phase 1 manifest:

`780499a2d287681acc7cf3a1c0701ddfa29e8c8493ca083c0ee44adee13e478d`

This phase manifest was later incorporated into the final audit chain.

Final audit phase-roots SHA-256:

`ed9022f140733f44fa9c3a92cf81c44154f6ec855e6554368537f049f287a122`

Final audit root SHA-256:

`bf49d7c13fb62da9fcc1da8fcdf3ee6121312c563a7fecb5928b5f60daa243ca`

---

## 13. Interpretation

For the exact audited commit and build procedure covered by this audit,
the two independent clean-room builds produced byte-identical versions
of all four tested executable targets.

This provides evidence that the tested build procedure was reproducible
for the measured environment.

The result is stronger than confirming only that both builds compiled:
the resulting executable bytes and SHA-256 identities matched.

---

## 14. Scope Boundary

This result does not claim that arbitrary builds performed with
different:

- toolchains;
- operating systems;
- architectures;
- environment variables;
- build flags;
- dependency states;
- future source revisions

will necessarily produce the same hashes.

The reproducibility claim applies to the exact audited revision and
controlled procedure represented by this audit.

Audited commit:

`db0e61e739b88ac9a923e2f595a4208f62ad80dd`

Phase verdict:

**PASS**