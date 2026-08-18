# VRP Runtime Observation Report

## Audit Scope

This document records controlled runtime observation performed during
the VRP Independent Trust Audit.

Audit date:

`2026-08-16`

Repository:

`vrp-validation-kit`

Audited repository commit:

`db0e61e739b88ac9a923e2f595a4208f62ad80dd`

Audit schema:

`vrp-independent-trust-audit-v1`

Covered phases:

- Phase 3A — Runtime Observability Preflight
- Phase 3B — Controlled Runtime Side-Effect Trace
- Phase 3C — Instrumented Functional Execution

Functional execution verdict:

**PASS**

---

## 1. Objective

The purpose of runtime observation was to inspect the externally
observable behavior of the audited executables while preserving a
cryptographic binding to the exact binaries produced by the
reproducible-build phase.

The audit examined:

- executable identity;
- runtime exit behavior;
- functional verdicts;
- process-related system calls;
- filesystem mutation system calls;
- socket-related system calls;
- outbound `connect()` activity;
- DNS port 53 references;
- repository mutation;
- Git working-state mutation;
- instrumentation effectiveness through a negative control.

The central runtime observation invariant was:

> Functional execution should produce the expected validation results
> without unexplained network activity or mutation of the audited
> repository state within the observed execution boundary.

---

## 2. Audited Binary Identity

The binaries used in runtime observation were the same artifacts
produced during Phase 1 reproducible-build verification.

### attack-suite

SHA-256:

`303f0f6e945fcb71e3f0d1b66580b4f13716ea9dfe42e479aabf6edcbff72fd7`

### evidence-verify

SHA-256:

`ab66603f37fbf80b3bb4c39f896c411e2b9287a226ee8dbbc07b879593a014cf`

### vrp-runtime-scenario

SHA-256:

`487ccb78e8a7c044cfd3ed5db18715e256bf0000f9a29c8b1cfc5d0526f9f545`

### vrp-test

SHA-256:

`43e01e39b82fc6649af8f64fb3b62efd16b2099f166359cbde81d5810fc2db4f`

This provides a direct identity relationship between the binaries
examined during reproducibility testing and the binaries observed during
runtime execution.

---

## 3. Observability Environment

The audit preflight confirmed availability of the following observation
and inspection utilities:

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

Missing audited binaries:

`0`

Runtime observability preflight:

**PASS**

---

## 4. Preliminary Side-Effect Trace

Before functional execution, the four binaries were executed under
controlled tracing using their discovery/help execution profiles.

Observed totals:

| Observation | Result |
|---|---:|
| Binaries traced | 4 |
| Timeouts | 0 |
| Network syscalls | 0 |
| `connect()` calls | 0 |
| DNS port 53 references | 0 |
| Process creation syscalls | 22 |
| Filesystem write intents | 12 |

Observed network activity:

`NONE OBSERVED`

Observed DNS activity:

`NONE OBSERVED`

Repository immutability:

**PASS**

Git-state immutability:

**PASS**

Phase 3B execution status:

**PASS**

---

## 5. Why a Negative Control Was Required

A trace reporting zero network activity is useful only if the
instrumentation is capable of observing network activity when such
activity actually occurs.

For this reason, Phase 3C included a deliberate negative control.

The negative control attempted a TCP connection to:

`127.0.0.1:9`

The trace observed:

`socket(AF_INET, SOCK_STREAM|SOCK_CLOEXEC, IPPROTO_IP)`

and:

`connect(... 127.0.0.1:9 ...)`

Observed negative-control socket calls:

`1`

Observed negative-control connect calls:

`1`

Negative-control result:

**PASS**

This demonstrates that the tracing procedure used in the audit was able
to detect the network system-call class being measured.

---

## 6. Functional Execution

The four audited binaries were then executed under instrumentation using
functional execution paths rather than only help/discovery paths.

No execution timed out.

Non-zero functional exits:

`0`

Functional verdict:

**PASS**

---

## 7. attack-suite

Binary SHA-256:

`303f0f6e945fcb71e3f0d1b66580b4f13716ea9dfe42e479aabf6edcbff72fd7`

Exit code:

`0`

Timed out:

`NO`

Final verdict:

`ATTACK_SUITE_PASSED`

Observed network syscalls:

`0`

Observed `connect()` calls:

`0`

Observed DNS port 53 references:

`0`

Observed process syscalls:

`5`

Observed file mutation syscalls:

`41`

Functional result:

**PASS**

---

## 8. evidence-verify

Binary SHA-256:

`ab66603f37fbf80b3bb4c39f896c411e2b9287a226ee8dbbc07b879593a014cf`

Input evidence:

`evidence/sample/core-evidence.json`

Input evidence SHA-256:

`8a711b1a2a22de20486fa9593c7053951dad2b204ad3fb19ea57de818790755a`

Exit code:

`0`

Timed out:

`NO`

Final verdict:

`EVIDENCE_VERIFIED`

Observed network syscalls:

`0`

Observed `connect()` calls:

`0`

Observed DNS port 53 references:

`0`

Observed process syscalls:

`5`

Observed file mutation syscalls:

`15`

Functional result:

**PASS**

---

## 9. vrp-runtime-scenario

Binary SHA-256:

`487ccb78e8a7c044cfd3ed5db18715e256bf0000f9a29c8b1cfc5d0526f9f545`

Exit code:

`0`

Timed out:

`NO`

Final verdict:

`CONTINUITY_PRESERVED`

Observed network syscalls:

`0`

Observed `connect()` calls:

`0`

Observed DNS port 53 references:

`0`

Observed process syscalls:

`5`

Observed file mutation syscalls:

`60`

Functional result:

**PASS**

---

## 10. vrp-test

Binary SHA-256:

`43e01e39b82fc6649af8f64fb3b62efd16b2099f166359cbde81d5810fc2db4f`

Exit code:

`0`

Timed out:

`NO`

Final verdict:

`VALIDATION_PASSED`

Observed network syscalls:

`0`

Observed `connect()` calls:

`0`

Observed DNS port 53 references:

`0`

Observed process syscalls:

`5`

Observed file mutation syscalls:

`79`

Functional result:

**PASS**

---

## 11. Functional Runtime Matrix

| Binary | Exit | Verdict | Network Syscalls | Connect Calls | DNS :53 | Process Syscalls | File Mutation Syscalls |
|---|---:|---|---:|---:|---:|---:|---:|
| `attack-suite` | 0 | `ATTACK_SUITE_PASSED` | 0 | 0 | 0 | 5 | 41 |
| `evidence-verify` | 0 | `EVIDENCE_VERIFIED` | 0 | 0 | 0 | 5 | 15 |
| `vrp-runtime-scenario` | 0 | `CONTINUITY_PRESERVED` | 0 | 0 | 0 | 5 | 60 |
| `vrp-test` | 0 | `VALIDATION_PASSED` | 0 | 0 | 0 | 5 | 79 |

Totals:

`Binaries executed = 4`

`Timeouts = 0`

`Non-zero exits = 0`

`Network syscalls observed = 0`

`Connect calls observed = 0`

`DNS port 53 references = 0`

`Process syscalls observed = 20`

`File mutation syscalls observed = 195`

---

## 12. Repository Immutability

The repository tree was hashed before and after functional execution.

Repository tree before:

`c66e15c8a87bd6c1daa685661a1f8a86103b6ec03f59dcb16e2f04e00583edd4`

Repository tree after:

`c66e15c8a87bd6c1daa685661a1f8a86103b6ec03f59dcb16e2f04e00583edd4`

Result:

**PASS**

The measured repository tree remained unchanged across the instrumented
functional execution.

---

## 13. Git-State Immutability

Git state was independently measured before and after execution.

Git state before:

`dbc529e556afa2a3381d6fce011d7a553d1a2ec3834da1994da8d768878db31a`

Git state after:

`dbc529e556afa2a3381d6fce011d7a553d1a2ec3834da1994da8d768878db31a`

Result:

**PASS**

No Git-state change was detected across the measured execution.

---

## 14. Network Observation

During the four instrumented functional executions:

`NETWORK_SYSCALLS_OBSERVED=0`

`CONNECT_CALLS_OBSERVED=0`

`DNS_PORT53_REFERENCES=0`

The separately executed negative control produced both an observable
socket call and an observable `connect()` call.

Therefore the audit supports the narrower statement:

> No socket/network activity belonging to the measured syscall classes
> was observed from the four audited functional executions under the
> tested invocation paths.

This is materially stronger than simply reporting that an application
did not print network-related output.

---

## 15. Backdoor Claim Boundary

This audit does **not** claim mathematical or universal proof that the
software contains no backdoor.

Such a claim cannot be established merely by observing several runtime
executions.

The evidence produced here supports a narrower and reproducible
statement:

> During the audited execution paths, using the exact binaries bound by
> the recorded SHA-256 identities, the instrumentation observed no
> network syscalls, outbound connect calls, or DNS port 53 references,
> while a deliberate negative control demonstrated that the tracing
> method could detect a connection attempt.

This distinction matters.

Absence of observed behavior during defined execution paths is evidence
about those paths.

It is not proof that unreachable, dormant, environment-dependent,
time-triggered, input-triggered, or otherwise unexecuted behavior cannot
exist.

---

## 16. What Would Strengthen the Claim Further

A stronger future assurance programme could additionally include:

- static source review;
- static binary analysis;
- dependency and module provenance review;
- syscall allow-list enforcement;
- namespace-isolated execution;
- network namespace execution with no external route;
- seccomp enforcement;
- long-duration execution tracing;
- randomized argument/input execution;
- environment-variable mutation;
- time-trigger testing;
- filesystem-trigger testing;
- packet-level observation;
- process-tree observation;
- dynamic library inspection where applicable;
- independent reproduction on another host;
- independent third-party execution.

These would extend the evidence boundary without changing the meaning of
the results already recorded here.

---

## 17. Phase 3A Seal

Phase 3A report SHA-256:

`65cfea27d83e75aac38b7b7d4146b4bdb7127b673067011b07c96e4e4a7b9276`

Phase 3A result SHA-256:

`d2082d40c9d533f130c64df260a00483148414b04aa6a9860a501ee3f3425b4c`

Phase 3A root SHA-256:

`a2cad1b3eb1ef9fdb9f3a7316a002dab26fdaee119c2fdbffe88f0b6280efb08`

---

## 18. Phase 3B Seal

Phase 3B report SHA-256:

`6ddeed2ba4f0455ca957d08b61e9005c2dc90d1b1c0fe7ce91b1be48661c8c38`

Phase 3B result SHA-256:

`d0262151e4909cb6cebc1b57c82482803045cae9e638dab0f15d415cead95212`

Phase 3B root SHA-256:

`4128d5582d7c8db78b107ebf6757d0e3331d521d5dbd1278a7276f92be5319ca`

---

## 19. Phase 3C Seal

Phase 3C report SHA-256:

`a6e604cb5474fc84f43adb5edb1aabcb510703a2bb313eb1edd85631c9ab559a`

Phase 3C result SHA-256:

`616265ac5f6cc63933b887d1c3619ceeeee30323c9d615f6126a0b345a956a5f`

Phase 3C root SHA-256:

`fca4cd706e211b32f5cf83cd22cf43144d2fdd99ba758ca35507fb11155258a9`

---

## 20. Final Audit Binding

Audited repository commit:

`db0e61e739b88ac9a923e2f595a4208f62ad80dd`

Final phase-roots SHA-256:

`ed9022f140733f44fa9c3a92cf81c44154f6ec855e6554368537f049f287a122`

Final audit root SHA-256:

`bf49d7c13fb62da9fcc1da8fcdf3ee6121312c563a7fecb5928b5f60daa243ca`

Final audit seal root:

`2f13538d46a2a064e4b803f0af7c89520c775d132e57fc8f41922b8f17c8bc01`

Final audit verdict:

**PASS**

---

## Conclusion

The instrumented runtime phase completed successfully.

All four audited functional executions returned the expected successful
verdicts.

No functional execution timed out.

No functional execution returned a non-zero exit status.

No network syscall, outbound `connect()` call, or DNS port 53 reference
was observed in the measured execution paths.

The network negative control was successfully detected.

The repository tree remained unchanged.

The Git state remained unchanged.

**FUNCTIONAL EXECUTION: PASS**

**NETWORK NEGATIVE CONTROL: PASS**

**OBSERVED FUNCTIONAL CONNECT CALLS: 0**

**OBSERVED FUNCTIONAL DNS :53 REFERENCES: 0**

**REPOSITORY IMMUTABILITY: PASS**

**GIT STATE IMMUTABILITY: PASS**