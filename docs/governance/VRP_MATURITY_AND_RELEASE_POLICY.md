# VRP Maturity and Release Policy

**Veil Routing Protocol (VRP)**  
**Engineering Maturity, Evidence Gates, Release Integrity, and Public Status Policy**

> Maturity is not declared.  
> Maturity is earned through evidence.

## 1. Purpose

This document defines the public maturity and release policy for the Veil Routing Protocol project.

Its purpose is to establish consistent meanings for terms such as:

- research;
- prototype;
- validated prototype;
- pilot candidate;
- pilot validated;
- deployment candidate;
- production deployment.

The policy exists to prevent maturity terminology from becoming marketing language disconnected from engineering evidence.

A VRP maturity level represents a bounded technical status.

It is not a universal guarantee.

---

## 2. Governance Principle

VRP development follows a simple rule:

**STATUS MUST FOLLOW EVIDENCE**

A maturity level should not be promoted because:

- a demonstration looked convincing;
- a social-media post performed well;
- a benchmark produced a large number;
- development has continued for a long time;
- a commercial opportunity exists;
- the project wants to appear more mature.

Promotion should occur when the relevant technical evidence supports it.

---

## 3. Maturity Is Multidimensional

Protocol maturity cannot be represented completely by one number.

Relevant dimensions may include:

- architecture;
- implementation;
- correctness;
- security;
- adversarial validation;
- recovery;
- concurrency;
- resource behavior;
- interoperability;
- deployment experience;
- operational experience;
- documentation;
- evidence integrity;
- independent evaluation.

A project may be mature in one dimension while remaining experimental in another.

The public maturity level therefore represents an overall engineering classification, not perfection in every dimension.

---

## 4. Level 1 — Research

### Definition

VRP is in architectural exploration.

Work may include:

- protocol hypotheses;
- design principles;
- threat analysis;
- experiments;
- state-machine exploration;
- transport models;
- recovery models;
- proof-of-concept code.

### Evidence Expectations

Evidence may be incomplete or experimental.

Breaking architectural changes are expected.

### Public Claim Boundary

At this level, VRP should not be represented as deployment-ready.

---

## 5. Level 2 — Prototype

### Definition

A running implementation exists.

Important protocol concepts have moved beyond architecture-only discussion into executable behavior.

### Expected Evidence

Evidence may include:

- running code;
- basic functional tests;
- initial failure testing;
- early security testing;
- implementation traces;
- reproducible demonstrations.

### Limitations

Substantial implementation and protocol behavior may still change.

Interoperability and deployment readiness may remain largely untested.

---

## 6. Level 3 — Validated Prototype

### Definition

Important protocol properties have reproducible validation evidence.

The implementation has survived meaningful testing beyond basic functionality.

### Expected Evidence

Evidence should include a meaningful subset of:

- explicit invariants;
- reproducible validation scenarios;
- negative tests;
- adversarial tests;
- recovery tests;
- replay or stale-state tests;
- concurrency tests;
- evidence integrity records;
- regression tests for discovered defects.

### Promotion Gate

Promotion from Prototype should require evidence that important architectural claims are implemented and testable.

### Claim Boundary

Validated Prototype does not mean production-ready.

---

## 7. Level 4 — Pilot Candidate

### Definition

The implementation and validation infrastructure are sufficiently mature for controlled external technical evaluation under explicitly defined conditions.

### Expected Evidence

A Pilot Candidate should have:

- running implementation;
- documented architectural boundaries;
- defined validation methodology;
- explicit verdict terminology;
- security considerations;
- threat model;
- reproducible internal validation;
- known limitations;
- controlled pilot process;
- evidence collection capability;
- implementation integrity records where appropriate.

### Commercial Meaning

Pilot Candidate means organizations may be invited to evaluate VRP under controlled terms.

It does not mean production use is automatically authorized.

### Current VRP Status

**VRP CURRENT MATURITY: LEVEL 4 — PILOT CANDIDATE**

This status should remain until sufficient external pilot evidence exists to justify promotion.

---

## 8. Level 5 — Pilot Validated

### Definition

One or more controlled external pilot engagements have produced documented technical results for their defined scope.

### Minimum Promotion Gate

Promotion should require at least one genuine external pilot in an environment not controlled solely by the VRP author.

The pilot should have:

- predefined scope;
- predefined critical invariants;
- predefined success criteria;
- identifiable implementation version;
- identifiable environment;
- captured evidence;
- explicit verdict;
- documented limitations.

### Important Boundary

One successful pilot does not establish universal deployment readiness.

The correct statement is:

`VRP has completed controlled external pilot validation under documented conditions.`

Not:

`VRP is proven everywhere.`

---

## 9. Level 6 — Deployment Candidate

### Definition

Evidence supports consideration of VRP for a specific controlled deployment.

### Expected Evidence

Depending on the deployment, evidence should address:

- application integration;
- network integration;
- relevant security requirements;
- relevant failure scenarios;
- recovery;
- observability;
- resource behavior;
- operational ownership;
- known limitations;
- incident considerations;
- upgrade considerations;
- rollback considerations.

### Promotion Gate

At least one defined use case should have enough accumulated evidence that responsible engineers can make a defensible deployment-risk decision.

### Claim Boundary

Deployment Candidate applies to defined environments and use cases.

It is not a universal property of every possible VRP deployment.

---

## 10. Level 7 — Production Deployment

### Definition

VRP is operating in a real production environment under an explicit operational and commercial arrangement.

### Required Characteristics

A production deployment should identify:

- organization or responsible operator;
- deployed implementation version;
- environment;
- operational owner;
- security owner where applicable;
- supported topology;
- monitoring expectations;
- recovery procedures;
- known limitations;
- applicable commercial and licensing rights.

### Important Boundary

Production status applies to the actual deployment.

It does not automatically mean every VRP use case is production-ready.

---

## 11. Promotion Requires Evidence

Maturity promotion should be intentional.

Before increasing the public maturity level, review:

1. What new evidence exists?
2. Which previous uncertainty has been reduced?
3. Which new environment has been tested?
4. Which failure modes have been exercised?
5. Which limitations remain?
6. Has the relevant documentation been updated?
7. Is the new status defensible to an independent technical reviewer?

If the answer cannot be supported, promotion should wait.

---

## 12. Evidence Gates

VRP may use evidence gates to determine whether a maturity transition is justified.

### Architecture Gate

Required architecture and invariants are sufficiently defined.

### Implementation Gate

The relevant architecture exists as running code.

### Validation Gate

Important claims have executable validation.

### Adversarial Gate

Relevant hostile and failure conditions have been exercised.

### Security Gate

Threat assumptions and security boundaries are documented and tested where practical.

### Concurrency Gate

Relevant concurrent behavior has been evaluated.

### Resource Gate

Relevant resource behavior has been evaluated.

### Interoperability Gate

Required interoperability evidence exists for the claimed scope.

### Pilot Gate

External controlled evaluation has occurred.

### Deployment Gate

A specific real environment has sufficient evidence for deployment consideration.

Not every maturity transition requires every gate.

The required gates depend on the claim being made.

---

## 13. Failure Does Not Automatically Reduce Maturity

A mature engineering process discovers defects.

The discovery of a bug does not automatically mean the project has become less mature.

Relevant questions include:

- Was the defect reproducible?
- Was its impact understood?
- Was affected evidence reviewed?
- Was the defect corrected?
- Was regression coverage added?
- Were public claims corrected where necessary?

Discovering and correctly handling defects may itself demonstrate engineering maturity.

---

## 14. Maturity Downgrade

A maturity level may be reduced if new evidence materially invalidates the assumptions supporting the existing level.

Possible reasons include:

- critical architectural flaw;
- invalidated validation evidence;
- serious security defect;
- major regression;
- incorrect interoperability assumption;
- deployment failure revealing unsupported claims.

Downgrading status is not project failure.

It is evidence-driven governance.

---

## 15. No Silent Status Inflation

VRP should not silently change from:

`Pilot Candidate`

to:

`Production Ready`

without an evidence trail explaining why.

Material maturity changes should be recorded in version-controlled documentation.

Where appropriate, the relevant release should identify the evidence supporting the transition.

---

## 16. Release Philosophy

A VRP release should represent an identifiable technical state.

Important releases should be connected to enough metadata that the released state can be reconstructed or identified later.

Where practical, a release record should include:

- release identifier;
- date;
- Git commit;
- Git tree;
- repository;
- implementation status;
- validation status;
- relevant artifact hashes;
- known limitations;
- security notes;
- compatibility notes;
- maturity level.

---

## 17. Release Classes

VRP may distinguish releases using classes such as:

### Research Release

Experimental architecture or implementation.

### Validation Release

Created primarily to exercise or demonstrate defined technical properties.

### Pilot Release

Prepared for controlled pilot evaluation.

### Deployment Candidate Release

Prepared for evaluation in a defined deployment environment.

### Production Release

Authorized for a specific production deployment under the applicable commercial and operational arrangement.

The existence of one production release does not automatically promote every branch or experimental build to production status.

---

## 18. Version Identity

A version label alone may not uniquely identify source state.

Important evidence should therefore use stronger identifiers where practical, including:

- Git commit;
- Git tree;
- artifact SHA-256;
- manifest;
- evidence root.

This reduces ambiguity when multiple builds or branches exist.

---

## 19. Git Commit Identity

A Git commit identifies a specific repository history state.

Where a validation result depends on source state, the commit should be recorded when practical.

A later commit should not silently inherit every validation result from an earlier commit.

The relevance of earlier evidence should be evaluated according to the changes introduced.

---

## 20. Git Tree Identity

A Git tree identifies repository content independent of some commit metadata.

Recording both commit and tree can strengthen technical identification of the evaluated source snapshot.

The interpretation of these identifiers should remain technically precise.

---

## 21. Artifact Hashing

Released or evaluated artifacts may be accompanied by SHA-256 hashes.

Hashes may be used to verify that an artifact has not changed relative to the recorded bytes.

A hash should not be described as proof that the artifact is secure or legally owned merely because its integrity can be verified.

---

## 22. Evidence Root

Larger evidence sets may use an aggregate root.

The root construction should be reproducible.

The record should identify:

- hash algorithm;
- input artifacts;
- ordering;
- encoding;
- metadata included;
- root-construction method.

Different evidence-root formats may produce different roots for the same underlying repository snapshot.

That difference should not automatically be interpreted as corruption.

---

## 23. Signed Release Evidence

Where cryptographic signatures are used, the release record should identify:

- signing mechanism;
- signed object;
- signing-key identity or fingerprint where appropriate;
- verification result.

A valid signature demonstrates a relationship between the signed data and the corresponding signing key.

Additional evidence may be required to establish organizational or legal identity.

---

## 24. Clean Worktree Requirement

For important source-integrity records, the worktree state should be known.

Where the objective is to seal an exact committed snapshot, a clean worktree is preferred.

If evidence is intentionally generated from a dirty worktree, that condition should be recorded explicitly.

---

## 25. Release Validation

Before an important release is promoted, relevant validation should be executed against the intended release state.

Where appropriate, this may include:

- unit tests;
- integration tests;
- adversarial tests;
- race detection;
- static analysis;
- resource tests;
- recovery tests;
- integrity verification;
- deployment-specific tests.

The exact qualification depends on release class.

---

## 26. Release Candidate

A release candidate should be treated as a candidate until qualification is complete.

If the candidate changes materially after validation, the changed state may require requalification.

The phrase:

`we tested almost the same code`

is weaker than identifying the exact tested snapshot.

---

## 27. Known Limitations

Important releases should document known limitations.

Examples may include:

- unsupported environment;
- unsupported topology;
- unresolved performance issue;
- incomplete interoperability;
- known security assumption;
- deployment restriction;
- operational constraint.

Known limitations should not be hidden merely to make the release appear stronger.

---

## 28. Regression Policy

A previously fixed defect should have regression coverage where practical.

Future releases should continue to exercise that regression.

If a regression returns, the new evidence supersedes assumptions based solely on earlier PASS results.

---

## 29. Historical Integrity

Release history should not be silently rewritten to make development appear cleaner than it was.

Historical records may include:

- failed tests;
- superseded implementations;
- corrected documentation;
- discovered defects;
- previous evidence roots;
- obsolete release candidates.

History can be deprecated.

It should not be falsified.

---

## 30. Corrections

Documentation errors should be corrected transparently.

A material correction should identify, where practical:

- what was incorrect;
- what has changed;
- which claim was affected;
- whether technical evidence is affected.

Correcting a mistake is preferable to preserving an incorrect public claim.

---

## 31. Superseded Evidence

Evidence may become superseded when:

- implementation changes;
- test methodology improves;
- a defect invalidates an earlier conclusion;
- stronger evidence becomes available;
- an environment changes.

Superseded evidence may remain historically valid for the state that produced it.

It should not automatically be treated as current evidence.

---

## 32. Evidence Inheritance

A new release may inherit some evidence from an earlier release when the relevant behavior is unchanged.

Inheritance should not be automatic for security-critical or materially modified components.

When uncertainty exists, rerun the validation.

---

## 33. Security-Sensitive Changes

Changes affecting any of the following should receive additional scrutiny:

- session identity;
- authority;
- cryptography;
- key handling;
- epoch or generation;
- replay handling;
- recovery;
- canonical state;
- public boundary;
- evidence integrity.

Previous security evidence may need to be repeated after such changes.

---

## 34. Protocol-Sensitive Changes

Changes to externally observable protocol semantics may require:

- specification update;
- compatibility analysis;
- version update;
- interoperability retesting;
- migration guidance.

Implementation convenience should not silently redefine protocol behavior.

---

## 35. Documentation as Release Surface

Documentation is part of the public engineering surface.

Material documents should therefore be version-controlled.

Important changes to:

- pilot terms;
- security boundaries;
- maturity claims;
- validation methodology;
- pricing;
- protocol semantics;

should be committed rather than silently edited outside the project history.

---

## 36. Commercial Documentation

Commercial documentation and technical documentation serve different purposes.

A pricing change does not prove technical maturity.

A maturity increase does not automatically determine price.

Commercial decisions may consider technical maturity, but the two records should remain distinguishable.

---

## 37. Pricing Roadmap Boundary

The published pilot pricing roadmap represents planned commercial pricing.

It is not a technical maturity scale.

For example:

`€100,000 pilot price`

does not mean:

`Level 7 Production Deployment`

Likewise, a lower-priced pilot may produce technically significant evidence.

Price and engineering verdict remain separate.

---

## 38. Pilot Evidence

A pilot should identify the exact implementation evaluated.

A later VRP release should not claim that an earlier organization validated the later implementation unless the relevant evidence actually supports that statement.

Preferred language:

`Organization X evaluated VRP snapshot Y under scenario Z.`

Avoid:

`Organization X proved all future VRP versions.`

---

## 39. Independent Validation

Where independent validation occurs, documentation should identify what was independently evaluated.

Possible distinctions include:

- evidence verification;
- test reproduction;
- implementation review;
- black-box evaluation;
- interoperability test;
- security review;
- pilot deployment.

The phrase `independently validated` should not be broader than the actual independent work performed.

---

## 40. Production Claims

The phrase `production-ready` should be used carefully.

Preferred language identifies the actual state:

`validated as a deployment candidate for environment X`

or:

`operating in production deployment Y`

This is more informative than a universal production-readiness label.

---

## 41. Deprecation

A protocol feature, implementation version, validation artifact, or document may become deprecated.

Deprecation should identify, where practical:

- deprecated item;
- reason;
- replacement;
- migration path;
- relevant date.

Deprecated material may remain accessible for historical analysis.

---

## 42. Release Rejection

A release candidate may be rejected.

Reasons may include:

- failed critical invariant;
- unresolved race;
- integrity mismatch;
- security regression;
- resource regression;
- broken interoperability;
- invalid evidence;
- incomplete qualification.

Rejecting a release is normal engineering behavior.

A release schedule should not override a critical technical failure.

---

## 43. Emergency Release

A critical defect may require an accelerated release.

Even under urgency, the release should preserve as much evidence as practical.

After stabilization, the emergency change should receive the validation that time constraints prevented before deployment.

Urgency does not permanently remove the requirement for evidence.

---

## 44. Reproducibility

Important release evidence should be reproducible where practical.

An authorized engineer should be able to determine:

- which source state was released;
- which artifacts were produced;
- which tests were run;
- which results were obtained;
- which limitations were known.

---

## 45. Public Release Record

A future formal VRP release record may use a structure such as:

`RELEASE`

`DATE`

`MATURITY LEVEL`

`COMMIT`

`TREE`

`ARTIFACT HASHES`

`VALIDATION SUMMARY`

`SECURITY STATUS`

`KNOWN LIMITATIONS`

`INTEROPERABILITY STATUS`

`DEPLOYMENT STATUS`

`EVIDENCE REFERENCES`

This creates a stable technical identity for the release.

---

## 46. Current Status Record

At the time this policy is introduced, VRP is publicly characterized as:

**LEVEL 4 — PILOT CANDIDATE**

The project has:

- a running protected implementation;
- public validation surfaces;
- adversarial validation methodology;
- implementation integrity practices;
- controlled pilot documentation;
- explicit evidence and security frameworks.

Promotion beyond this level should require new evidence corresponding to the definitions in this policy.

---

## 47. Next Maturity Gate

The next major maturity transition is:

**LEVEL 4 — PILOT CANDIDATE**

to:

**LEVEL 5 — PILOT VALIDATED**

The defining new evidence should come from controlled external evaluation.

The purpose of that transition is important:

internal validation demonstrates what VRP can do in environments controlled by its own engineering process;

external pilot validation begins demonstrating what happens when VRP encounters another organization's infrastructure, engineers, assumptions, and failure scenarios.

---

## 48. Governance Record

Material maturity changes should eventually be accompanied by a short governance record identifying:

- previous level;
- new level;
- date;
- qualifying evidence;
- known limitations;
- responsible decision;
- relevant release.

This prevents maturity history from becoming ambiguous.

---

## 49. Engineering Independence

Technical verdicts should remain independent from commercial pressure.

A customer payment does not create a PASS.

A deadline does not make a failed release safe.

A high pilot price does not create maturity.

A successful marketing campaign does not create interoperability.

Engineering status follows technical evidence.

---

## 50. Final Governance Principles

Do not promote because the calendar changed.

Do not promote because the price changed.

Do not promote because the project became more visible.

Do not promote because a demonstration looked impressive.

Promote when the evidence changes.

Release exact states.

Preserve failures.

Record corrections.

Identify limitations.

Revalidate security-sensitive changes.

Keep commercial claims separate from technical verdicts.

**SESSION ≠ TRANSPORT.**

**PRICE ≠ MATURITY.**

**RELEASE ≠ PROOF.**

**PASS ≠ UNIVERSAL CORRECTNESS.**

**MATURITY = ACCUMULATED, REVIEWABLE EVIDENCE.**

---

## Related Documentation

- `docs/CONTROLLED_PILOT_PROGRAM.md`
- `docs/commercial/PILOT_PRICING_ROADMAP.md`
- `docs/commercial/PILOT_ENGAGEMENT_LIFECYCLE.md`
- `docs/validation/IMPLEMENTATION_STATUS.md`
- `docs/validation/VALIDATION_EVIDENCE_STANDARD.md`
- `docs/validation/INTEROPERABILITY_AND_DEPLOYMENT_READINESS.md`
- `docs/security/SECURITY_CONSIDERATIONS.md`
- `docs/security/THREAT_MODEL_AND_TRUST_BOUNDARIES.md`

---

## Contact

**Proton Mail:**  
`jumpingvpn@proton.me`

**Email:**  
`riabovasvitalijus@gmail.com`

---

**Veil Routing Protocol (VRP)**  
**Maturity and Release Policy**