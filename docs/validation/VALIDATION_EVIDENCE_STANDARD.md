# VRP Validation Evidence Standard

**Veil Routing Protocol (VRP)**  
**Technical Evidence, Reproducibility, and Verdict Framework**

> Evidence over assumptions.  
> A verdict is only as strong as the evidence behind it.

## 1. Purpose

This document defines the preferred evidence standard for technical validation performed within the Veil Routing Protocol project.

Its purpose is to make VRP validation results:

- explicit;
- reproducible where practical;
- attributable to a specific implementation state;
- resistant to ambiguous interpretation;
- reviewable by other engineers;
- bounded by the conditions actually tested.

A successful test is not treated as universal proof.

A failed test is not treated as something to hide.

Both are engineering evidence.

---

## 2. Evidence Principle

A VRP technical claim should, where practical, be reducible to the following chain:

`CLAIM -> SCENARIO -> INVARIANT -> EXECUTION -> OBSERVATION -> EVIDENCE -> VERDICT`

If one of these elements is missing, the strength of the resulting conclusion should be reduced accordingly.

---

## 3. Validation Record

A validation record should identify the relevant information required to understand what actually occurred.

Depending on the scenario, this may include:

- validation identifier;
- scenario identifier;
- test objective;
- implementation version;
- Git commit;
- Git tree;
- environment;
- operating system;
- runtime version;
- topology;
- configuration;
- preconditions;
- invariant under evaluation;
- actions performed;
- expected behavior;
- observed behavior;
- timestamps;
- relevant logs;
- hashes;
- final verdict;
- known limitations;
- reproduction instructions.

Not every validation requires every field.

The record should contain enough information to support its conclusion.

---

## 4. Scenario Identity

Important validation runs should have an identifiable scenario or run reference.

A scenario identifier allows:

- logs to be associated with the correct execution;
- repeated runs to be distinguished;
- failures to be reproduced;
- evidence to be grouped;
- later investigation to reference the exact experiment.

Where practical, identifiers should be machine-readable and unique within the relevant evidence set.

---

## 5. Implementation Identity

Evidence should identify the implementation state that produced it.

Where Git is used, useful anchors include:

- commit identifier;
- tree identifier;
- branch where relevant;
- repository identity;
- clean or dirty worktree status.

A result generated from one implementation snapshot must not automatically be attributed to a later implementation snapshot.

---

## 6. Environment Identity

The environment can materially affect protocol behavior.

Important records should therefore identify relevant environmental information such as:

- operating system;
- kernel;
- architecture;
- runtime or compiler;
- virtualization platform;
- container environment;
- network interfaces;
- transport type;
- relevant routing configuration;
- relevant firewall configuration;
- relevant application environment.

The required detail depends on the scenario.

---

## 7. Invariant Definition

An invariant is a property expected to remain valid throughout or after a defined scenario.

Examples may include:

- session identity remains unchanged across transport replacement;
- stale state is not accepted as current state;
- replayed input does not advance authoritative state;
- an unauthorized transition does not mutate canonical state;
- recovery does not silently restore invalid authority;
- evidence history does not accept unauthorized rewriting.

An invariant should be defined before the result is known whenever practical.

---

## 8. Preconditions

A test should identify conditions that must be true before execution.

Examples include:

- session established;
- baseline state verified;
- required transport available;
- test artifact integrity verified;
- expected authority established;
- evidence capture enabled;
- environment configuration recorded.

A failed precondition may make the resulting test inconclusive rather than failed.

---

## 9. Expected Behavior

Expected behavior should be defined before execution.

This prevents the result from being reinterpreted after observation.

Examples:

`Transport A disappears -> session identity remains authoritative while an authorized replacement path is established.`

`Previously accepted sequence is replayed -> replay is rejected and authoritative state does not advance.`

`Invalid authority is presented -> operation is rejected without unauthorized canonical mutation.`

---

## 10. Observed Behavior

Observed behavior should describe what actually happened without rewriting the observation to match expectations.

Where appropriate, preserve:

- stdout;
- stderr;
- structured logs;
- packet traces;
- timestamps;
- state transitions;
- counters;
- verdict records;
- failure messages;
- recovery events.

Interpretation should remain distinguishable from raw observation.

---

## 11. Standard Verdict Vocabulary

VRP uses explicit verdict terminology.

### PASS

The available evidence supports satisfaction of the predefined success criteria for the tested scenario.

### FAIL

The available evidence demonstrates violation of one or more predefined critical criteria.

### INCONCLUSIVE

The available evidence or environment is insufficient to support a technically defensible PASS or FAIL verdict.

### PRESERVED

The targeted invariant remained valid through the tested condition.

### REJECTED

The tested input, transition, authority, replay, stale state, or other invalid condition was refused according to the relevant rule.

### CONTAINED

A hostile, degraded, or failure condition occurred but remained within the predefined containment boundary.

### RECOVERED

The tested system returned to the defined acceptable operational state after the failure condition.

### DETECTED

The tested invalid or unexpected condition was identified by the relevant validation mechanism.

These terms describe scoped results.

They are not universal guarantees.

---

## 12. PASS Requirements

A PASS verdict should require:

1. valid preconditions;
2. execution of the intended scenario;
3. sufficient observation;
4. satisfaction of predefined criteria;
5. no known contradictory evidence within the same run.

If critical evidence is missing, `INCONCLUSIVE` may be more appropriate than `PASS`.

---

## 13. FAIL Requirements

A FAIL verdict should identify:

- the violated criterion;
- the observed behavior;
- the evidence supporting the violation;
- the relevant implementation state;
- the environment;
- reproduction information where practical.

A reproducible failure is especially valuable because it creates a concrete engineering target.

---

## 14. INCONCLUSIVE Requirements

Examples of conditions that may justify `INCONCLUSIVE` include:

- incomplete logs;
- corrupted evidence;
- environment failure unrelated to the tested property;
- incorrect baseline;
- inability to execute the intended scenario;
- insufficient observability;
- ambiguous result;
- uncontrolled external interference.

`INCONCLUSIVE` is not equivalent to PASS.

It is also not automatically equivalent to FAIL.

---

## 15. Evidence Integrity

Important evidence artifacts may be protected using cryptographic integrity records.

Possible mechanisms include:

- SHA-256 hashes;
- per-file manifests;
- aggregate evidence roots;
- Git commits;
- Git trees;
- signed Git objects where available;
- other authenticated integrity records.

Integrity mechanisms should make silent modification easier to detect.

---

## 16. Hash Interpretation

A cryptographic hash can establish that two byte sequences are identical with respect to the applied hash comparison, subject to the assumptions of the cryptographic function and verification process.

A hash does not by itself establish:

- authorship;
- legal ownership;
- infringement;
- acquisition circumstances;
- independent development;
- security correctness;
- absence of vulnerabilities.

Technical integrity evidence and legal conclusions are separate questions.

---

## 17. Evidence Manifest

For larger evidence sets, a manifest should identify the artifacts included in the record.

A manifest may contain:

- relative artifact path;
- SHA-256 digest;
- artifact type;
- run identifier;
- generation timestamp;
- relevant metadata.

The manifest itself may also be hashed or otherwise authenticated.

---

## 18. Aggregate Evidence Root

Where an aggregate root is used, the construction method should be documented sufficiently to allow independent reproduction.

The root should not be presented without identifying:

- the input set;
- ordering rules;
- encoding rules;
- normalization rules;
- hash algorithm;
- relevant metadata included in root construction.

Different root construction methods may legitimately produce different roots for the same underlying files.

---

## 19. Reproducibility

Where disclosure boundaries permit, another authorized engineer should be able to determine:

- what command was executed;
- what environment was used;
- which implementation was tested;
- what failure was introduced;
- what invariant was evaluated;
- what result was expected;
- what result was observed;
- how the verdict was calculated.

Perfect reproducibility is not possible for every real-world failure scenario.

Where exact reproduction is impossible, the limitations should be stated.

---

## 20. Repeated Validation

Some properties require repeated execution rather than a single run.

Repeated validation records should distinguish:

- number of executions;
- number of successful executions;
- number of failures;
- environmental variation;
- deterministic versus non-deterministic behavior;
- concurrency or scheduler sensitivity where relevant.

`1 PASS` and `1,000 repeated PASS executions` are different evidence statements and should not be represented as equivalent.

---

## 21. Concurrency Evidence

Concurrency-related validation should use appropriate tooling where available.

Relevant evidence may include:

- race detection;
- stress execution;
- repeated schedules;
- invariant checking;
- deadlock detection;
- deterministic reproduction;
- runtime diagnostics.

The absence of a detected race in one execution is not proof that no race exists.

---

## 22. Network Failure Evidence

Network validation should identify the actual condition introduced.

Examples:

- transport removed;
- interface disabled;
- path changed;
- address changed;
- NAT mapping changed;
- packet reordered;
- packet duplicated;
- latency introduced;
- connectivity removed;
- connectivity restored.

A simulated failure and a physical network failure should be described differently when that distinction matters.

---

## 23. Adversarial Evidence

An adversarial validation scenario should identify:

- attack or hostile condition;
- expected defense or containment behavior;
- permitted attacker capability;
- excluded attacker capability;
- targeted invariant;
- observed result.

Statements such as `attack rejected` are incomplete without identifying what attack was actually attempted.

---

## 24. Failure Preservation

Unexpected failures should not be silently removed from the engineering history.

Where practical, retain:

- original failing test;
- original evidence;
- diagnosis;
- corrective change;
- regression test;
- subsequent PASS evidence.

This creates a trace from defect discovery to verified correction.

---

## 25. Regression Evidence

A defect is not considered fully addressed merely because the source code changed.

A strong remediation record should include:

`ORIGINAL FAILURE -> REPRODUCTION -> FIX -> REGRESSION TEST -> PASS`

Where appropriate, race detection, static analysis, stress testing, or additional adversarial validation should follow.

---

## 26. Negative Evidence

A failed attempt to reproduce a vulnerability is not proof that the vulnerability cannot exist.

Likewise:

`NO FAILURE OBSERVED`

is not automatically equivalent to:

`PROVEN IMPOSSIBLE`

Claims should reflect the strength of the actual evidence.

---

## 27. Independent Verification

Independent verification is encouraged.

An independent evaluator may challenge:

- scenario design;
- assumptions;
- invariant definition;
- environment;
- commands;
- evidence integrity;
- verdict logic;
- reproducibility.

A result becomes stronger when another party can reproduce it without relying on hidden interpretation.

---

## 28. Protected Core and Public Evidence

Public validation does not require unrestricted publication of proprietary implementation internals.

Where possible, VRP should expose enough external evidence to evaluate the claimed behavior while preserving legitimate Protected Core boundaries.

This may include:

- black-box behavior;
- public test harnesses;
- public scenario definitions;
- signed or hashed evidence;
- boundary interfaces;
- reproducible external observations.

---

## 29. Claim Scope

Every technical claim should remain bounded by the evidence supporting it.

A PASS under one environment does not automatically prove:

- universal availability;
- universal security;
- universal interoperability;
- correctness under every network;
- correctness under every implementation;
- immunity from every attacker;
- immunity from future vulnerabilities;
- suitability for every production environment.

---

## 30. Evidence Conflict

If two evidence records appear to contradict one another, neither should be silently discarded.

Investigation should determine whether the difference results from:

- implementation version;
- environment;
- configuration;
- timing;
- scenario definition;
- non-determinism;
- regression;
- measurement error;
- another relevant variable.

The contradiction itself becomes an engineering question.

---

## 31. Evidence Retention

Important evidence should be retained according to its technical and commercial significance.

High-value records may include:

- major validation milestones;
- security failures;
- regression evidence;
- pilot results;
- release evidence;
- integrity manifests;
- signed records;
- historical implementation snapshots.

Retention policy may evolve as VRP matures.

---

## 32. Evidence Publication

Not all evidence must be public.

Evidence may be classified as:

### PUBLIC

Suitable for unrestricted publication under the applicable repository terms.

### CONTROLLED

Available to authorized pilot participants, evaluators, or partners.

### PROTECTED

Contains implementation or security-sensitive material that remains private.

Evidence classification must not be confused with the technical verdict.

A protected PASS and a public PASS are both verdicts; their disclosure boundaries differ.

---

## 33. Corrections

If a published verdict is later found to be incorrect, the record should be corrected transparently where practical.

A correction should identify:

- the affected claim;
- why the previous conclusion was insufficient or incorrect;
- the corrected result;
- supporting evidence.

Engineering credibility depends more on correctable records than on pretending mistakes never happen.

---

## 34. Minimum Public Evidence Statement

When publishing a significant validation result, the preferred minimum statement is:

`WHAT WAS TESTED`

`WHICH IMPLEMENTATION WAS TESTED`

`UNDER WHAT CONDITIONS`

`WHICH INVARIANT WAS EVALUATED`

`WHAT WAS OBSERVED`

`WHAT VERDICT WAS ASSIGNED`

`WHAT EVIDENCE SUPPORTS IT`

Anything less should be treated as a summary rather than a complete validation record.

---

## 35. Validation Philosophy

VRP does not define success as producing the maximum possible number of PASS labels.

The purpose of validation is to reduce uncertainty.

A reproducible FAIL that exposes a real defect may improve the protocol more than an easy PASS.

A difficult test that survives repeated execution creates stronger evidence than an unchallenged claim.

---

## 36. Final Principle

Do not trust a diagram because it looks convincing.

Do not trust a benchmark because the number is large.

Do not trust a PASS because the word is green.

Inspect the scenario.

Inspect the invariant.

Inspect the environment.

Inspect the evidence.

Then evaluate the verdict.

**SESSION ≠ TRANSPORT.**

**Evidence over assumptions.**

---

## Related Documentation

- `docs/CONTROLLED_PILOT_PROGRAM.md`
- `docs/validation/IMPLEMENTATION_STATUS.md`
- `docs/validation/INTEROPERABILITY_AND_DEPLOYMENT_READINESS.md`
- `docs/security/SECURITY_CONSIDERATIONS.md`
- `docs/security/THREAT_MODEL_AND_TRUST_BOUNDARIES.md`
- `docs/governance/VRP_MATURITY_AND_RELEASE_POLICY.md`

---

**Veil Routing Protocol (VRP)**  
**Validation Evidence Standard**