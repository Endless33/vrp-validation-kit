# VRP Implementation Status

**Veil Routing Protocol (VRP)**  
**Public Implementation and Validation Status**

> SESSION ≠ TRANSPORT  
> Running code. Reproducible evidence. Explicit boundaries.

## 1. Purpose

This document describes the current public implementation status of the Veil Routing Protocol project.

VRP is not presented solely as a theoretical architecture.

A running private implementation exists and is actively developed, tested, hardened, and validated against defined failure and adversarial scenarios.

This document does not claim IETF standardization, certification, universal interoperability, or universal production readiness.

---

## 2. Current Project State

VRP currently operates as:

- an actively developed protocol architecture;
- a protected private implementation;
- a public validation program;
- a collection of public protocol and runtime-boundary materials;
- an adversarial engineering effort;
- a controlled pilot candidate.

The project is moving from internal engineering and validation toward controlled external technical evaluation.

---

## 3. Running Implementation

The VRP architecture is backed by running code.

The implementation is not published in full.

The current development model intentionally separates the public technical surface from the Protected Core.

This allows protocol behavior, validation methodology, architectural claims, and selected runtime properties to be examined without unrestricted publication of proprietary implementation internals.

---

## 4. Public Technical Surface

Public VRP material may include:

- protocol architecture;
- design principles;
- validation tooling;
- adversarial scenarios;
- selected runtime demonstrations;
- public boundary implementations;
- evidence methodology;
- pilot documentation;
- selected test results;
- reproducibility instructions;
- integrity records;
- implementation-status documentation.

Public availability of these materials does not imply public availability of the Protected Core.

---

## 5. Protected Implementation Surface

The Protected Core may contain non-public implementation material including:

- internal runtime logic;
- state-management implementation;
- recovery implementation;
- authority enforcement;
- internal security mechanisms;
- proprietary engineering decisions;
- non-public test infrastructure;
- non-public deployment material;
- other protected implementation details.

Access to public VRP repositories does not grant access to this material.

**PUBLIC ARCHITECTURE ≠ PUBLIC IMPLEMENTATION**

---

## 6. Core Architectural Principle

VRP is built around the distinction:

**SESSION ≠ TRANSPORT**

A session is not treated as identical to the transport currently carrying its traffic.

Transport may disappear, change, migrate, recover, or be replaced.

The validity of session identity, authority, state, and recovery must therefore be evaluated independently from the mere existence of a transport path.

---

## 7. Engineering Model

VRP development follows an evidence-oriented engineering model.

A typical hardening cycle is:

`INSPECT -> HYPOTHESIS -> RED -> PROVE FAIL -> MINIMAL FIX -> PASS -> VERIFY -> RECORD`

The objective is not to avoid discovering defects.

The objective is to make defects reproducible, understandable, correctable, and resistant to regression.

---

## 8. Validation Areas

VRP validation may exercise areas including:

- transport interruption;
- path migration;
- network transition;
- temporary connectivity loss;
- address changes;
- NAT rebinding;
- packet duplication;
- packet reordering;
- stale state;
- replay attempts;
- recovery behavior;
- authority continuity;
- state convergence;
- concurrency;
- restart behavior;
- resource pressure;
- evidence integrity;
- historical integrity.

A successful result applies to the tested scenario and its defined conditions.

It must not automatically be generalized to every possible environment.

---

## 9. Security Posture

VRP does not use the phrase "secure" as a substitute for threat modeling.

Security evaluation should distinguish between properties such as:

- confidentiality;
- integrity;
- authentication;
- authority;
- replay resistance;
- stale-state rejection;
- recovery correctness;
- evidence integrity;
- fail-closed behavior;
- resource containment.

A protocol can preserve connectivity while violating security.

VRP does not consider that outcome successful when the violated property is part of the required invariant.

---

## 10. Evidence Model

Where appropriate, important technical artifacts may be associated with:

- Git commit identifiers;
- Git tree identifiers;
- SHA-256 hashes;
- file manifests;
- aggregate evidence roots;
- cryptographic signatures where available;
- runtime logs;
- test verdicts;
- reproduction instructions.

These mechanisms help identify exactly what material was evaluated.

Cryptographic integrity records do not by themselves prove every technical or legal claim concerning the material.

---

## 11. Protected Core Integrity

Protected implementation snapshots may be independently hashed and re-verified within the controlled development environment.

Such records are intended to establish a reproducible integrity reference for a specific snapshot.

A snapshot record should identify, where applicable:

- exact commit;
- exact Git tree;
- tracked-file count;
- per-file hashes;
- verification result;
- aggregate evidence root.

A later implementation change creates a different snapshot and should be treated accordingly.

---

## 12. Public Validation

Public validation material exists so that engineers can challenge VRP without requiring unrestricted access to the Protected Core.

The intended model is:

**claim -> scenario -> invariant -> execution -> evidence -> verdict**

The objective is not to ask external engineers to trust private implementation details.

The objective is to expose enough measurable behavior to make meaningful technical challenges possible.

---

## 13. Failure Policy

A discovered failure is engineering information.

VRP does not define maturity as the absence of discovered bugs.

When practical, unexpected behavior should move through:

`OBSERVE -> REPRODUCE -> ISOLATE -> FIX -> RETEST -> RECORD`

A corrected defect does not retroactively erase the original failure.

Historical evidence should remain distinguishable from subsequent corrected evidence.

---

## 14. Implementation Maturity Vocabulary

VRP uses the following public maturity vocabulary.

### Level 1 — Research

Architectural exploration, hypotheses, experiments, and early engineering.

### Level 2 — Prototype

Running implementation exists, but substantial behavior may remain subject to change.

### Level 3 — Validated Prototype

Important properties have reproducible validation evidence.

This does not imply universal production readiness.

### Level 4 — Pilot Candidate

The implementation and validation surface are sufficiently mature for controlled external evaluation under defined conditions.

### Level 5 — Pilot Validated

One or more controlled external pilots have produced documented results for their defined scope.

### Level 6 — Deployment Candidate

A specific use case has sufficient integration, operational, security, and validation evidence to justify controlled deployment consideration.

### Level 7 — Production Deployment

VRP is operating in a real production environment under an explicit operational and commercial arrangement.

Production status applies to the specific deployment.

It does not automatically imply universal production readiness.

---

## 15. Current Maturity Position

The current public position of VRP is:

**PILOT CANDIDATE**

This means the project has progressed beyond architecture-only discussion and internal prototyping and is being prepared for controlled external evaluation.

It does not mean:

- every environment has been tested;
- every threat has been defeated;
- every integration has been validated;
- every deployment is supported;
- no implementation defects remain;
- production use is automatically authorized.

The purpose of controlled pilots is to expand the evidence beyond environments controlled solely by the project author.

---

## 16. Interoperability

Internal correctness and interoperability are different properties.

A private implementation may provide meaningful running-code evidence without proving interoperability between independent implementations.

If independent VRP implementations are developed in the future, interoperability between them should be evaluated separately and documented explicitly.

Compatibility claims should identify the environment actually tested.

---

## 17. Deployment Readiness

Deployment readiness should be determined per environment and use case.

Relevant evidence may include:

- application requirements;
- network topology;
- operating systems;
- cloud or physical infrastructure;
- NAT behavior;
- routing behavior;
- firewall behavior;
- transport transitions;
- recovery behavior;
- operational procedures;
- observability;
- security requirements;
- known limitations.

VRP does not define deployment readiness as a single universal boolean.

---

## 18. Controlled Pilot Program

Organizations that want to evaluate VRP may request a controlled pilot.

A pilot should begin with:

1. environment definition;
2. failure scenario;
3. critical invariants;
4. success and failure criteria;
5. evidence requirements.

Execution follows only after those boundaries are understood.

Payment does not purchase a PASS verdict.

The evidence determines the result.

---

## 19. Licensing Boundary

The Protected Core remains proprietary.

Public documentation, validation material, demonstrations, architecture, or evidence do not automatically grant:

- ownership of VRP;
- ownership of the Protected Core;
- unrestricted source access;
- redistribution rights;
- sublicensing rights;
- production deployment rights;
- exclusivity;
- unrestricted commercial exploitation.

Rights are determined by the applicable license and written agreement.

---

## 20. What This Document Does Not Claim

This implementation-status document does not claim that VRP is:

- an Internet Standard;
- an IETF-approved protocol;
- formally verified in its entirety;
- universally secure;
- universally interoperable;
- immune to denial of service;
- immune to implementation defects;
- immune to endpoint compromise;
- validated under every possible network condition;
- appropriate for every production environment.

Such claims would require evidence beyond the scope of this document.

---

## 21. Evaluation Principle

A serious protocol should become easier to challenge as it matures, not harder.

The public question is therefore not:

**"Do you believe VRP?"**

The better questions are:

**What property is being claimed?**

**Under what conditions?**

**What would falsify it?**

**Can the result be reproduced?**

**Does the evidence support the verdict?**

---

## 22. Related Documentation

See also:

- `docs/CONTROLLED_PILOT_PROGRAM.md`
- `docs/commercial/PILOT_PRICING_ROADMAP.md`
- `docs/commercial/PILOT_ENGAGEMENT_LIFECYCLE.md`
- `docs/validation/VALIDATION_EVIDENCE_STANDARD.md`
- `docs/validation/INTEROPERABILITY_AND_DEPLOYMENT_READINESS.md`
- `docs/security/SECURITY_CONSIDERATIONS.md`
- `docs/security/THREAT_MODEL_AND_TRUST_BOUNDARIES.md`
- `docs/governance/VRP_MATURITY_AND_RELEASE_POLICY.md`

---

## Contact

**Proton Mail:**  
`jumpingvpn@proton.me`

**Email:**  
`riabovasvitalijus@gmail.com`

Suggested subject:

`VRP TECHNICAL EVALUATION — [Organization / Use Case]`

---

**Veil Routing Protocol (VRP)**

**Running code. Defined boundaries. Reproducible evidence.**