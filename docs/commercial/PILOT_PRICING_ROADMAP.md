# VRP Pilot Pricing Roadmap

**Veil Routing Protocol (VRP)**  
**Published Commercial Pilot Schedule**

> SESSION ≠ TRANSPORT  
> Pricing follows maturity, evidence, scope, and engineering responsibility.

## 1. Purpose

This document publishes the planned pricing progression for controlled VRP technical pilot engagements.

It exists so prospective participants can see the commercial direction in advance.

The schedule is not intended to manufacture artificial scarcity.

VRP development, validation depth, pilot experience, deployment knowledge, engineering responsibility, and commercial value are expected to evolve over time.

Pilot pricing is intended to evolve with them.

## 2. Planned Schedule

| Period | Planned Base Pilot Fee |
|---|---:|
| 2026 Q4 | €25,000 |
| 2027 Q1 | €25,000 |
| 2027 Q2 | €50,000 |
| 2027 Q3 | €75,000 |
| 2027 Q4 | €100,000 |

Unless separately agreed, the standard controlled pilot duration is up to 14 calendar days.

The applicable price is the price confirmed in writing before an engagement begins.

## 3. After €100,000

No automatic price increase beyond €100,000 is announced by this document.

After the planned €100,000 level is reached, pricing will be reviewed based on actual evidence, including:

- completed pilot experience;
- deployment complexity;
- engineering effort;
- support requirements;
- validated use cases;
- infrastructure requirements;
- commercial demand;
- licensing scope;
- operational responsibility;
- maturity of the technology.

Future pricing may remain unchanged, increase, decrease, or move to a different commercial model.

Any change will be published separately.

## 4. What the Pilot Fee Represents

The fee is not payment for a slide deck.

Depending on the agreed scope, it may cover:

- technical intake;
- scenario definition;
- invariant definition;
- environment preparation;
- pilot artifacts;
- controlled execution;
- adversarial validation;
- engineering participation;
- evidence collection;
- failure investigation;
- technical review;
- final evidence package.

The Protected Core is not sold by payment of a pilot fee.

## 5. No Retroactive Price Changes

Once a pilot scope, fee, and payment terms have been accepted in writing, a later public pricing change does not retroactively change that engagement.

## 6. Pilot vs. Production

Pilot pricing is not production licensing.

Production deployment, commercial licensing, integration, support, SLA obligations, source access, exclusivity, geographic rights, and other commercial rights require separate written terms.

## 7. Evidence Before Expansion

The commercial model follows the same principle as the engineering model:

**claims should follow evidence.**

VRP does not assume that a higher price proves higher technical value.

Technical value must continue to be demonstrated through validation and real deployment experience.

---

**Current entry point:**  
See `docs/CONTROLLED_PILOT_PROGRAM.md`


================================================================================
FILE: docs/commercial/PILOT_ENGAGEMENT_LIFECYCLE.md
================================================================================

# VRP Pilot Engagement Lifecycle

## 1. Objective

A VRP pilot is a controlled technical evaluation.

It is designed to answer a defined engineering question using agreed criteria and reproducible evidence.

## 2. Stage 1 — Initial Contact

The prospective participant provides:

- organization or team;
- authorized technical contact;
- intended use case;
- target environment;
- principal failure scenario;
- desired timeframe.

No payment is required merely to begin a technical discussion.

## 3. Stage 2 — Technical Qualification

Both sides determine whether the requested scenario is appropriate for the current VRP pilot program.

Questions may include:

- What must remain continuous?
- Which transports may disappear or change?
- Which state must remain authoritative?
- What constitutes stale state?
- What adversarial conditions are relevant?
- What evidence will be considered sufficient?

A scenario may be rejected or deferred if it is outside the current evaluation capability.

## 4. Stage 3 — Scope

The engagement scope records:

- environment;
- topology;
- duration;
- authorized participants;
- permitted testing;
- excluded testing;
- critical invariants;
- PASS criteria;
- FAIL criteria;
- INCONCLUSIVE criteria;
- evidence requirements;
- commercial terms.

## 5. Stage 4 — Commercial Confirmation

Before payment:

- scope is confirmed;
- price is confirmed;
- refund conditions are confirmed where applicable;
- payment method is confirmed;
- delivery channel is confirmed;
- confidentiality and licensing conditions are confirmed.

## 6. Stage 5 — Pilot Kit Delivery

After the required onboarding and payment steps, the applicable Enterprise Pilot Kit is delivered through an agreed controlled channel.

Artifact integrity information may be supplied with the kit.

## 7. Stage 6 — Baseline

Before adversarial testing, the environment is baselined.

Where applicable, the baseline records:

- versions;
- relevant configuration;
- artifact hashes;
- topology;
- starting state;
- test identifiers;
- time reference.

## 8. Stage 7 — Execution

The agreed scenarios are executed.

The objective is not to protect VRP from difficult tests.

The objective is to determine what actually happens.

## 9. Stage 8 — Evidence Capture

Evidence may include:

- logs;
- state transitions;
- verdicts;
- hashes;
- timestamps;
- scenario identifiers;
- failure traces;
- recovery traces;
- configuration;
- reproduction instructions.

## 10. Stage 9 — Technical Review

Results are classified as:

### PASS
The agreed criteria were satisfied.

### FAIL
One or more agreed critical criteria were violated.

### INCONCLUSIVE
The evidence or environment was insufficient to reach a defensible conclusion.

## 11. Stage 10 — Next Decision

Possible outcomes include:

- no further action;
- additional validation;
- remediation and retest;
- expanded pilot;
- integration discussion;
- production deployment discussion;
- commercial licensing discussion.

A successful pilot does not automatically create production rights.

## 12. Principle

No hidden success criteria.

No moving the goalposts after execution.

Define first.

Test second.

Judge from evidence.


================================================================================
FILE: docs/validation/IMPLEMENTATION_STATUS.md
================================================================================

# VRP Implementation Status

## Status

**Project:** Veil Routing Protocol (VRP)

**Implementation model:** Protected private implementation with public validation surfaces.

**Current characterization:** Active engineering and validation; controlled pilot evaluation.

This document records implementation status and should not be interpreted as an IETF endorsement, Internet Standard status, or certification.

## Running Code

VRP is not presented solely as a conceptual architecture.

A private implementation exists and is actively developed and tested.

Public repositories expose selected architecture, validation, runtime-boundary, and demonstration material without publishing the Protected Core.

## Implementation Boundary

The project intentionally separates:

### Public

- architectural material;
- validation tooling;
- selected demonstrations;
- selected evidence;
- boundary behavior;
- pilot documentation.

### Protected

- private implementation;
- protected runtime internals;
- non-public engineering material;
- other proprietary implementation details.

**PUBLIC ARCHITECTURE ≠ PUBLIC IMPLEMENTATION**

## Validation Philosophy

Implementation maturity is evaluated through running code and reproducible evidence.

Relevant categories include:

- transport interruption;
- continuity;
- stale-state rejection;
- replay rejection;
- recovery;
- concurrency;
- authority boundaries;
- evidence integrity;
- long-running validation;
- resource behavior.

Individual results must be interpreted according to the exact scenario and evidence that produced them.

A PASS in one scenario does not imply universal correctness.

## Maturity Vocabulary

VRP uses the following public maturity vocabulary:

1. Research
2. Prototype
3. Validated Prototype
4. Pilot Candidate
5. Pilot Validated
6. Deployment Candidate
7. Production Deployment

Movement between levels should be evidence-driven.

## Current Position

VRP currently maintains a protected implementation and public validation program and is opening controlled pilot evaluation.

This statement does not represent a universal production-readiness claim.

## Licensing

The Protected Core is proprietary.

Public repositories are governed by their respective license terms.

Public availability of architecture, documentation, validation artifacts, or demonstrations does not imply unrestricted rights to the Protected Core.

## Contact

Technical and pilot inquiries:

`jumpingvpn@proton.me`

`riabovasvitalijus@gmail.com`


================================================================================
FILE: docs/validation/VALIDATION_EVIDENCE_STANDARD.md
================================================================================

# VRP Validation Evidence Standard

## 1. Purpose

VRP technical claims should be connected to inspectable evidence.

This document defines the preferred structure for public and controlled validation records.

## 2. Evidence Unit

A validation record should identify, where applicable:

- scenario;
- test objective;
- implementation/version;
- environment;
- preconditions;
- invariant;
- actions performed;
- expected result;
- observed result;
- verdict;
- relevant logs;
- hashes;
- timestamp;
- reproduction information.

## 3. Verdict Vocabulary

### PASS

The evidence supports satisfaction of the predefined success criteria.

### FAIL

The evidence demonstrates violation of one or more predefined critical criteria.

### INCONCLUSIVE

The evidence is insufficient to support PASS or FAIL.

### CONTAINED

A failure or hostile condition occurred but remained inside the predefined containment boundary.

### REJECTED

An input or transition was refused according to the relevant validation rule.

### PRESERVED

The targeted continuity or invariant remained valid through the tested condition.

These terms must be interpreted within the scope of the specific scenario.

## 4. Evidence Integrity

Where appropriate, evidence artifacts should be bound using cryptographic hashes.

Possible evidence anchors include:

- Git commit identifiers;
- Git tree identifiers;
- SHA-256 file hashes;
- manifests;
- aggregate evidence roots;
- signed records where available.

A hash demonstrates content identity/integrity relative to the hashed material.

A hash alone does not establish every legal or technical conclusion about that material.

## 5. Reproducibility

A strong result should allow another engineer to understand:

- what was tested;
- how it was tested;
- what was expected;
- what happened;
- why the verdict was assigned.

Where disclosure constraints permit, commands and test procedures should be provided.

## 6. Failure Handling

Failures are evidence.

They must not be deleted merely because they are inconvenient.

A discovered defect should, where practical, move through:

`OBSERVE -> REPRODUCE -> ISOLATE -> FIX -> RETEST -> RECORD`

Historical evidence should not be rewritten to pretend the failure never occurred.

## 7. Claim Boundary

Evidence from one test does not automatically prove:

- universal security;
- universal availability;
- correctness under every implementation;
- correctness under every network;
- immunity from every attacker;
- production suitability for every organization.

Claims must remain bounded by evidence.

## 8. Independent Evaluation

Independent reproduction is encouraged where practical.

A third party should be able to challenge:

- scenario design;
- invariant definition;
- reproduction method;
- evidence integrity;
- verdict reasoning.

## 9. Principle

**Evidence over assumptions.**

A difficult reproducible failure is more valuable than an easy unchallenged PASS.


================================================================================
FILE: docs/validation/INTEROPERABILITY_AND_DEPLOYMENT_READINESS.md
================================================================================

# VRP Interoperability and Deployment Readiness

## 1. Purpose

This document defines what VRP should demonstrate before broader deployment claims are made.

## 2. Interoperability Is Separate From Internal Correctness

An implementation may behave correctly in isolation and still fail when integrated into a real environment.

VRP therefore treats interoperability as a separate validation dimension.

## 3. Areas to Evaluate

Depending on the use case:

- operating systems;
- network interfaces;
- NAT behavior;
- address changes;
- transport replacement;
- firewalls;
- routing behavior;
- application behavior;
- cloud environments;
- virtual machines;
- containers;
- observability systems;
- failure recovery;
- operational restart;
- mixed network conditions.

## 4. Deployment Evidence

A deployment-readiness record should identify:

- environment;
- topology;
- versions;
- integration boundary;
- expected continuity property;
- failure conditions;
- observed behavior;
- limitations;
- unresolved issues.

## 5. Independent Implementations

A private implementation demonstrating a protocol property is meaningful running-code evidence.

It is not the same as demonstrating interoperability between independent implementations.

If independent VRP implementations are created in the future, their interoperability should be tested and documented separately.

## 6. Compatibility Claims

Compatibility claims should identify the tested environment.

Avoid statements such as:

`works everywhere`

Prefer:

`validated under the following environment and conditions: ...`

## 7. Pilot Role

Controlled pilots are intended to expand deployment evidence by placing VRP into environments not controlled solely by the author.

## 8. Promotion Criteria

A use case should move toward deployment only when:

- required invariants are explicit;
- critical scenarios have been exercised;
- known limitations are documented;
- integration behavior is understood;
- evidence is reviewable;
- operational ownership is clear.

## 9. Principle

Deployment readiness is earned environment by environment.


================================================================================
FILE: docs/security/SECURITY_CONSIDERATIONS.md
================================================================================

# VRP Security Considerations

## 1. Purpose

Security is not a single property.

This document records the security questions that must be considered when evaluating VRP.

It is not a claim that VRP is immune to every attack.

## 2. Security Objectives

Depending on the component and deployment, relevant objectives may include:

- state integrity;
- authority integrity;
- session identity integrity;
- replay resistance;
- stale-state rejection;
- controlled recovery;
- evidence integrity;
- authenticated state transitions;
- confidentiality where cryptographic protection applies;
- fail-closed behavior where required.

## 3. Threat Categories

VRP validation should consider, where applicable:

- eavesdropping;
- replay;
- message insertion;
- message deletion;
- message modification;
- reordering;
- duplication;
- stale state;
- unauthorized state transition;
- authority misuse;
- path manipulation;
- transport interruption;
- network partition;
- resource pressure;
- denial of service;
- concurrency races;
- recovery manipulation;
- evidence tampering.

## 4. In-Scope vs. Out-of-Scope

Every serious security evaluation should identify which attacks are:

- in scope and expected to be rejected;
- in scope and expected to be contained;
- in scope but known limitations;
- outside the evaluated threat model.

An out-of-scope condition must not be silently presented as a protected condition.

## 5. Cryptographic Boundaries

Where cryptography is used, documentation should distinguish the intended protection:

- confidentiality;
- integrity;
- authentication;
- replay protection;
- key/epoch binding;
- other context binding.

Cryptographic algorithms do not compensate for incorrect state-machine behavior, authority handling, key management, implementation defects, or operational mistakes.

## 6. Denial of Service

No protocol should casually claim immunity to denial of service.

VRP evaluations should distinguish:

- continuity failure;
- resource exhaustion;
- intentional rejection;
- containment;
- unavailable underlying infrastructure.

## 7. Recovery Security

Recovery is itself a security boundary.

A recovery mechanism must not silently authorize stale, replayed, forged, or otherwise invalid state merely to restore connectivity.

Continuity must not be purchased by abandoning authority or integrity.

## 8. Residual Risk

Successful validation reduces uncertainty for tested conditions.

It does not eliminate residual risk.

Residual risks may include:

- undiscovered implementation defects;
- dependency vulnerabilities;
- cryptographic implementation mistakes;
- operational misconfiguration;
- untested environments;
- resource exhaustion;
- compromised endpoints;
- compromised credentials or keys;
- future attack techniques.

## 9. Security Reporting

A credible security report should include enough information to reproduce or investigate the issue.

Contact:

`jumpingvpn@proton.me`

## 10. Principle

**Continuity without integrity is not success.**

**Recovery without authority is not recovery.**

**No system is declared unbreakable.**


================================================================================
FILE: docs/security/THREAT_MODEL_AND_TRUST_BOUNDARIES.md
================================================================================

# VRP Threat Model and Trust Boundaries

## 1. Objective

VRP assumes that transports and network conditions may change or fail.

It must not automatically assume that every observed input, path, state, or recovery attempt is trustworthy.

## 2. Core Distinction

**SESSION ≠ TRANSPORT**

Transport is treated as replaceable.

Session identity and authoritative state must not become valid merely because a new transport exists.

## 3. Potentially Hostile Conditions

Depending on deployment, VRP should expect conditions such as:

- transport disappearance;
- address change;
- NAT rebinding;
- duplicated packets;
- delayed packets;
- reordered packets;
- replayed packets;
- stale epochs;
- forged or invalid transitions;
- partial connectivity;
- path changes;
- restart races;
- concurrent state changes;
- corrupted or manipulated evidence.

## 4. Trust Boundaries

A deployment should explicitly identify trust boundaries around:

- endpoint identity;
- session identity;
- authority;
- key material;
- epoch/generation state;
- transport/path metadata;
- recovery state;
- evidence;
- operator control;
- external dependencies.

## 5. Authority

Possession of network reachability must not automatically imply authority.

Possession of stale state must not automatically restore authority.

A recovery path must not silently become an authorization bypass.

## 6. Replay and Stale State

Previously valid data may become invalid because context has changed.

Validation therefore must consider not only whether data was once authentic, but whether it remains valid for the current:

- session;
- epoch;
- generation;
- authority;
- path;
- operation;
- other relevant context.

## 7. Fail-Closed Principle

Where accepting ambiguous state could violate a critical invariant, rejection is preferred over silently manufacturing continuity.

Specific behavior remains implementation- and scenario-dependent.

## 8. Compromised Endpoints

If an authorized endpoint, credential, or key is fully compromised, some guarantees may no longer hold.

The exact consequence depends on the deployment and affected trust boundary.

VRP must not claim that network protocol logic can universally compensate for complete endpoint compromise.

## 9. Validation Requirement

Threat-model claims should be connected to executable scenarios where practical.

A threat model without adversarial testing is incomplete.

## 10. Principle

Do not trust a path because it exists.

Do not trust state because it existed before.

Do not trust recovery because it restored connectivity.

Validate authority and context.


================================================================================
FILE: docs/governance/VRP_MATURITY_AND_RELEASE_POLICY.md
================================================================================

# VRP Maturity and Release Policy

## 1. Purpose

VRP maturity claims should have stable meanings.

This document defines the public vocabulary used to describe project progress.

## 2. Maturity Levels

### Level 1 — Research

Architecture, hypotheses, experiments, and early engineering.

### Level 2 — Prototype

Running implementation exists, but substantial behavior may still change.

### Level 3 — Validated Prototype

Important properties have reproducible validation evidence.

This does not imply production readiness.

### Level 4 — Pilot Candidate

The implementation and validation surface are sufficiently mature for controlled external evaluation under defined conditions.

### Level 5 — Pilot Validated

At least one controlled external pilot has completed with documented results for its defined scope.

This does not imply universal validation.

### Level 6 — Deployment Candidate

A defined use case has sufficient integration, operational, security, and validation evidence to justify controlled deployment consideration.

### Level 7 — Production Deployment

VRP is operating in a real production environment under an explicitly defined operational and commercial arrangement.

Production status applies to the specific deployment and does not imply universal production readiness.

## 3. Evidence Required

Promotion between maturity levels should consider:

- reproducible tests;
- adversarial testing;
- known limitations;
- security analysis;
- implementation status;
- interoperability evidence;
- operational evidence;
- failure history;
- pilot results;
- deployment results.

## 4. Failures Do Not Automatically Reduce Maturity

Discovering a defect is not automatically evidence that a project is becoming less mature.

A mature engineering process should discover defects.

The relevant questions are:

- Was the defect reproducible?
- Was its impact understood?
- Was it fixed correctly?
- Was regression evidence added?
- Were affected claims corrected?

## 5. Release Evidence

Important public releases should, where practical, record:

- version;
- Git commit;
- Git tree;
- relevant hashes;
- validation status;
- known limitations;
- release date.

## 6. No Silent Claim Inflation

Terms such as:

- production-ready;
- secure;
- independently validated;
- interoperable;
- self-healing;
- fail-safe;

must be bounded by evidence and context.

If a term could reasonably imply more than has been demonstrated, the surrounding documentation should clarify its scope.

## 7. Protected Core

Public maturity reporting does not require publication of proprietary implementation internals.

Evidence may be exposed through controlled or public validation surfaces while the Protected Core remains private.

## 8. Versioning

Public documentation and validation artifacts should evolve through visible version control.

Material changes should be committed rather than silently replacing historical records.

## 9. Corrections

Incorrect documentation should be corrected transparently.

Where a correction materially affects a prior technical claim, the correction should identify the affected claim or evidence where practical.

## 10. Principle

VRP maturity is not determined by how impressive a post looks.

It is determined by what the implementation can repeatedly demonstrate.