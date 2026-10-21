# VRP Pilot Engagement Lifecycle

**Veil Routing Protocol (VRP)**  
**Controlled Technical Evaluation Framework**

> SESSION ≠ TRANSPORT  
> Define first. Test second. Decide from evidence.

## 1. Purpose

This document defines the standard lifecycle for a controlled VRP pilot engagement.

A VRP pilot is not a demonstration designed to produce a predetermined result.

It is a structured technical evaluation intended to answer a specific engineering question under agreed conditions.

The process is designed around four principles:

- scope before execution;
- invariants before testing;
- evidence before conclusions;
- explicit commercial terms before payment.

---

## 2. Initial Contact

A prospective participant begins by providing enough information to determine whether the requested evaluation is technically appropriate.

Recommended information includes:

- organization or team;
- authorized technical contact;
- intended use case;
- target environment;
- principal continuity or failure problem;
- expected pilot timeframe;
- relevant infrastructure constraints.

Initial discussion does not itself create a pilot engagement or grant access to protected VRP materials.

---

## 3. Technical Qualification

Before commercial onboarding, the proposed scenario is reviewed for technical relevance and feasibility.

The discussion should establish:

- what must remain continuous;
- which transports may disappear or change;
- which state must remain authoritative;
- what constitutes stale or invalid state;
- which recovery behavior is expected;
- which adversarial conditions are relevant;
- what evidence would be considered sufficient;
- whether the requested scenario is within the current VRP evaluation capability.

A scenario may be rejected, narrowed, or deferred when it falls outside the current technical or operational scope.

VRP does not require every proposed pilot to be accepted.

---

## 4. Pilot Scope

Every accepted engagement should have a written scope before execution.

The scope may define:

- evaluation environment;
- relevant topology;
- pilot duration;
- authorized participants;
- permitted testing;
- excluded testing;
- critical invariants;
- PASS criteria;
- FAIL criteria;
- INCONCLUSIVE criteria;
- evidence requirements;
- confidentiality requirements;
- delivery method;
- commercial terms;
- refund conditions where applicable.

The purpose of the scope is to prevent success criteria from changing after the result is known.

---

## 5. Invariant Definition

Critical technical expectations should be written before adversarial execution begins.

Depending on the scenario, an invariant may concern:

- session continuity;
- session identity;
- authority;
- epoch or generation monotonicity;
- stale-state rejection;
- replay rejection;
- path migration;
- transport replacement;
- recovery;
- evidence integrity;
- canonical state;
- bounded resource behavior.

An invariant should be specific enough that the resulting evidence can support a defensible verdict.

---

## 6. Commercial Confirmation

Before payment, the participant and VRP operator should confirm in writing:

- pilot scope;
- pilot fee;
- duration;
- payment method;
- payment instructions;
- applicable refund conditions;
- authorized recipient;
- delivery mechanism;
- confidentiality requirements;
- licensing boundaries;
- technical contacts.

Published cryptocurrency addresses or public contact information do not replace this confirmation.

Payment alone does not grant rights beyond those expressly agreed for the engagement.

---

## 7. Controlled Pilot Kit Delivery

After the required onboarding and payment steps are completed, the applicable VRP Enterprise Pilot Kit may be delivered to the authorized participant.

Depending on scope, the kit may contain:

- deployment instructions;
- environment preparation material;
- scenario definitions;
- validation procedures;
- configuration;
- evidence collection instructions;
- verification procedures;
- pilot-specific artifacts;
- integrity information.

The exact contents depend on the engagement.

Protected material remains subject to the applicable written terms.

---

## 8. Secure Delivery

Pilot materials should be transferred through an agreed controlled channel.

Depending on the engagement, this may include:

- access-controlled private repository;
- authenticated encrypted file transfer;
- end-to-end encrypted communication;
- another mutually agreed secure delivery mechanism.

Where appropriate, cryptographic hashes may accompany delivered artifacts so the recipient can verify artifact integrity before execution.

---

## 9. Environment Baseline

Before adversarial testing begins, the relevant environment should be baselined.

Where applicable, the baseline records:

- software versions;
- artifact versions;
- artifact hashes;
- relevant configuration;
- topology;
- initial runtime state;
- test identifiers;
- time reference;
- known environmental limitations.

The baseline establishes what was actually tested.

---

## 10. Controlled Execution

The agreed scenarios are then executed.

The objective is not to protect VRP from difficult conditions.

The objective is to determine what actually happens when those conditions occur.

Testing may include agreed combinations of:

- transport interruption;
- path migration;
- address change;
- NAT rebinding;
- temporary network loss;
- duplication;
- reordering;
- stale state;
- replay;
- concurrency pressure;
- recovery;
- restart;
- infrastructure disruption;
- other authorized adversarial conditions.

Testing outside the agreed scope requires separate authorization.

---

## 11. Evidence Capture

Evidence should be collected during execution rather than reconstructed from memory afterward.

Depending on the engagement, evidence may include:

- runtime logs;
- state transitions;
- verdicts;
- timestamps;
- scenario identifiers;
- configuration records;
- hashes;
- failure traces;
- recovery traces;
- integrity manifests;
- reproduction instructions.

Where practical, evidence should make it possible to understand both what happened and why the final verdict was assigned.

---

## 12. Failure Handling

A failure is not hidden merely because it is commercially inconvenient.

When unexpected behavior occurs, the preferred process is:

`OBSERVE -> REPRODUCE -> ISOLATE -> EXPLAIN -> FIX -> RETEST -> RECORD`

A defect discovered during a pilot may therefore become useful engineering evidence.

A subsequent fix does not erase the historical failure.

Both events may remain part of the technical record.

---

## 13. Technical Verdict

The final result should use predefined terminology.

### PASS

The available evidence supports satisfaction of the agreed success criteria.

### FAIL

The available evidence demonstrates violation of one or more agreed critical criteria.

### INCONCLUSIVE

The environment or available evidence is insufficient to support a technically defensible PASS or FAIL verdict.

No verdict should be changed solely because another result would be commercially preferable.

---

## 14. Technical Review

At the end of execution, the participant and VRP operator may review:

- scenarios executed;
- observed behavior;
- evidence;
- failures;
- recoveries;
- limitations;
- unresolved questions;
- final verdicts.

Where appropriate, disagreements should be tied to specific evidence rather than general impressions.

---

## 15. Pilot Outcome

A completed pilot may lead to:

- no further action;
- additional validation;
- remediation and retesting;
- expanded evaluation;
- integration discussion;
- deployment evaluation;
- production licensing discussion;
- support or commercial negotiation.

A successful pilot does not automatically grant production deployment rights.

Production use requires the applicable commercial and licensing arrangement.

---

## 16. Protected Core Boundary

The VRP Protected Core remains private unless a separate written agreement explicitly provides otherwise.

Participation in a pilot does not automatically grant:

- ownership;
- source-code ownership;
- unrestricted source access;
- redistribution rights;
- sublicensing rights;
- reverse-engineering rights;
- production rights;
- exclusivity;
- transfer of VRP intellectual property.

The rights granted are limited to those expressly stated in the applicable agreement.

---

## 17. Reproducibility

Where disclosure restrictions permit, important pilot results should be reproducible.

A strong technical record should allow another authorized engineer to determine:

- what was tested;
- which version was tested;
- what conditions were introduced;
- which invariant was evaluated;
- what was expected;
- what was observed;
- how the verdict was reached.

---

## 18. No Predetermined Outcome

Payment does not purchase a PASS verdict.

The purpose of a VRP pilot is validation.

If the evidence supports PASS, the result is PASS.

If the evidence supports FAIL, the result is FAIL.

If the evidence is insufficient, the result is INCONCLUSIVE.

That boundary is intentional.

---

## 19. Engineering Principle

A serious protocol should not require belief before evaluation.

Define the environment.

Define the failure.

Define the invariant.

Run the scenario.

Preserve the evidence.

Then decide.

**SESSION ≠ TRANSPORT.**

**Evidence over assumptions.**

---

## 20. Related Documents

See also:

- `docs/CONTROLLED_PILOT_PROGRAM.md`
- `docs/commercial/PILOT_PRICING_ROADMAP.md`
- `docs/validation/VALIDATION_EVIDENCE_STANDARD.md`
- `docs/security/SECURITY_CONSIDERATIONS.md`
- `docs/security/THREAT_MODEL_AND_TRUST_BOUNDARIES.md`

---

## Contact

**Proton Mail:**  
`jumpingvpn@proton.me`

**Email:**  
`riabovasvitalijus@gmail.com`

Suggested subject:

`VRP CONTROLLED PILOT — [Organization / Use Case]`

---

**Veil Routing Protocol (VRP)**  
**Controlled Pilot Engineering Framework**