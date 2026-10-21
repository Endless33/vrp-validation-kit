# VRP Pilot Engagement Lifecycle

**Veil Routing Protocol (VRP)**  
**Controlled Technical Evaluation and Pilot Engagement Process**

> Define the invariant first.  
> Execute the failure second.  
> Let the evidence determine the verdict.

## 1. Purpose

This document defines the standard lifecycle for a controlled Veil Routing Protocol pilot engagement.

The purpose of a VRP pilot is not to provide unrestricted access to the Protected Core.

The purpose is to evaluate defined VRP properties against a real environment, real failure conditions, and pre-agreed technical criteria.

A pilot is therefore structured as an evidence-producing engineering engagement rather than an informal product demonstration.

---

## 2. Engagement Principle

Every pilot should follow the same basic sequence:

`CONTACT`

`QUALIFICATION`

`SCOPE`

`INVARIANTS`

`SUCCESS CRITERIA`

`COMMERCIAL CONFIRMATION`

`CONTROLLED DELIVERY`

`BASELINE`

`EXECUTION`

`EVIDENCE`

`VERDICT`

`TECHNICAL REVIEW`

`NEXT DECISION`

The verdict is not selected in advance.

The evidence determines the result.

---

## 3. Initial Contact

A prospective participant begins by describing the environment or technical problem they want to evaluate.

Useful initial information may include:

- organization or team;
- technical contact;
- intended use case;
- application type;
- operating environment;
- network environment;
- expected failure condition;
- continuity requirement;
- security requirement;
- desired evaluation outcome.

Detailed confidential infrastructure information is not required during the first contact unless both parties agree otherwise.

---

## 4. Technical Qualification

Before accepting a pilot, the proposed scenario should be evaluated for technical suitability.

Questions may include:

- Is the requested property relevant to VRP?
- Can the scenario be reproduced or observed?
- Can meaningful evidence be collected?
- Is the requested environment technically accessible?
- Are the required failure conditions controllable?
- Are the success criteria measurable?
- Does the scenario require functionality that is not currently implemented?
- Does the scenario conflict with Protected Core boundaries?

A pilot may be declined or deferred if the requested evaluation cannot currently produce a technically defensible result.

---

## 5. Scope Definition

Before payment or technical execution, the pilot scope should be defined in writing.

The scope may identify:

- target environment;
- target application;
- network topology;
- VRP components involved;
- relevant interfaces;
- test duration;
- failure scenarios;
- attacker capabilities where relevant;
- operational constraints;
- excluded conditions;
- evidence requirements;
- success criteria.

Undefined expectations should not become retroactive acceptance criteria after the pilot begins.

---

## 6. Invariant Definition

The pilot should define the critical property or properties being evaluated.

Examples may include:

- session identity remains stable across transport replacement;
- stale state cannot become authoritative;
- replay does not advance canonical state;
- unauthorized migration is rejected;
- recovery preserves the required authority boundary;
- a defined application session survives an agreed network transition;
- evidence tampering is detectable under the tested conditions.

The exact invariant depends on the engagement.

An invariant should be written so that engineers can determine whether it was preserved or violated.

---

## 7. Success Criteria

Success criteria should be established before disruptive testing begins.

A criterion should be:

- technically meaningful;
- observable;
- bounded;
- reproducible where practical;
- associated with evidence.

Example:

`During the defined Wi-Fi-to-cellular transition, the VRP session identity must remain unchanged and the application must recover within the agreed observation window without accepting stale session authority.`

This is stronger than:

`VRP should work well during migration.`

---

## 8. Commercial Confirmation

Once technical scope is agreed, commercial terms should be confirmed before controlled pilot access is provided.

The applicable terms may identify:

- pilot fee;
- pilot duration;
- payment method;
- authorized participants;
- permitted environment;
- confidentiality requirements;
- intellectual-property boundaries;
- security-testing boundaries;
- refund conditions where applicable;
- evidence-delivery expectations.

The current public pricing roadmap is documented separately.

Commercial payment does not predetermine the technical verdict.

A paid pilot may result in:

- PASS;
- FAIL;
- INCONCLUSIVE;
- or a more specific scoped technical verdict.

---

## 9. Pilot Kit

The participant may receive a controlled Enterprise Pilot Kit appropriate to the agreed evaluation.

The exact contents depend on the scenario.

Possible components include:

- pilot runtime artifact;
- configuration;
- launch instructions;
- validation harness;
- scenario definitions;
- evidence collection tooling;
- integrity hashes;
- environment requirements;
- troubleshooting guidance;
- permitted interfaces.

The pilot kit does not imply unrestricted delivery of Protected Core source code.

---

## 10. Secure Delivery

Pilot artifacts should be transferred using an agreed access-controlled mechanism.

Possible delivery methods include:

- access-controlled private repository;
- authenticated encrypted transfer;
- encrypted archive through an authenticated channel;
- another mutually agreed secure delivery mechanism.

Artifact integrity should be verifiable where practical.

Relevant artifacts may be accompanied by:

- SHA-256 hashes;
- manifests;
- Git identifiers;
- signatures where available.

Secure delivery protects the transfer process.

It does not replace the written authorization governing use of the material.

---

## 11. Baseline Establishment

Before introducing failure conditions, the environment should reach a known baseline.

The baseline may record:

- VRP implementation version;
- artifact hash;
- relevant Git identity where applicable;
- operating system;
- runtime environment;
- application state;
- network interfaces;
- network topology;
- initial route;
- session state;
- transport state;
- relevant configuration.

If the baseline is invalid, disruptive testing should not be interpreted as a valid protocol verdict.

---

## 12. Scenario Execution

The agreed scenario is then executed.

Depending on the pilot, this may include:

- transport interruption;
- interface change;
- path migration;
- NAT rebinding;
- temporary connectivity loss;
- transport restoration;
- process restart;
- recovery;
- replay attempt;
- stale-state presentation;
- resource pressure;
- concurrent transition;
- another pre-agreed failure condition.

The scenario should remain within the authorized pilot scope.

---

## 13. Evidence Collection

Evidence should be captured during execution where practical.

Evidence may include:

- structured runtime output;
- state transitions;
- timestamps;
- counters;
- packet observations;
- application behavior;
- failure events;
- recovery events;
- rejection records;
- integrity manifests;
- artifact hashes;
- environment information.

The required evidence depends on the claim being evaluated.

Evidence collection should follow the VRP Validation Evidence Standard where applicable.

---

## 14. Failure Handling

Unexpected failure is a valid pilot outcome.

If a critical invariant appears to fail:

1. preserve the available evidence;
2. identify the exact scenario;
3. confirm the environment;
4. attempt controlled reproduction where appropriate;
5. distinguish protocol behavior from infrastructure failure;
6. determine whether the result is reproducible;
7. document the technical finding.

The objective is not to protect a predetermined PASS.

The objective is to determine what actually happened.

---

## 15. Verdict

The final verdict should correspond to the predefined criteria and available evidence.

Possible verdict terminology may include:

### PASS

The predefined pilot success criteria were satisfied under the tested conditions.

### FAIL

One or more predefined critical criteria were reproducibly violated under the tested conditions.

### INCONCLUSIVE

The available evidence or environment was insufficient to support a defensible PASS or FAIL conclusion.

More specific invariant-level verdicts may include:

- PRESERVED;
- REJECTED;
- CONTAINED;
- RECOVERED;
- DETECTED.

A verdict applies only to the defined scenario and environment.

---

## 16. Technical Review

After execution, the parties may review:

- what was tested;
- what happened;
- what evidence was collected;
- which invariants were preserved;
- which failures occurred;
- whether any result requires reproduction;
- which limitations remain;
- what additional testing may be useful.

Technical disagreement should be resolved through evidence where possible.

---

## 17. Pilot Outcome

A pilot may produce several legitimate outcomes.

### Successful Validation

The agreed criteria were satisfied.

The parties may discuss:

- expanded evaluation;
- additional scenarios;
- deployment qualification;
- licensing;
- commercial integration.

### Technical Failure

A predefined critical invariant failed.

The failure should be documented and investigated according to the agreed terms.

### Inconclusive Evaluation

The environment or evidence was insufficient.

The parties may agree to repeat or redesign the scenario.

### Discovery

The pilot may reveal behavior not anticipated by either party.

Such discoveries may become new engineering or validation work.

---

## 18. Protected Core Boundary

The VRP Protected Core remains private unless a separate written agreement explicitly states otherwise.

Pilot participation does not automatically grant:

- source-code ownership;
- unrestricted source access;
- redistribution rights;
- sublicensing rights;
- reverse-engineering rights;
- publication rights;
- rights to protected implementation internals.

The applicable license and written pilot terms govern access.

Public architectural documentation should not be interpreted as public release of the Protected Core.

---

## 19. Reproducibility and Evidence

A strong pilot should make the final technical conclusion understandable after the live event has ended.

Where practical, the evidence package should allow an authorized reviewer to determine:

- which implementation was used;
- which environment was used;
- what scenario was executed;
- what invariant was evaluated;
- what was observed;
- how the verdict was reached.

A screenshot alone should not be treated as the strongest possible evidence when stronger machine-verifiable records are available.

---

## 20. No Predetermined Outcome

A commercial engagement does not purchase a PASS.

A customer expectation does not override a failed invariant.

A successful demonstration does not automatically establish universal compatibility.

A single failure does not automatically invalidate every VRP property.

Each conclusion should remain proportional to the evidence.

---

## 21. Pilot Failure and Limited Refund

Where the applicable written pilot terms include the published limited failure-refund mechanism, a participant may be eligible for a refund of up to 50% of the pilot fee if a pre-agreed critical invariant reproducibly fails within the agreed scope and environment and the failure is attributable to VRP.

The exact conditions must be confirmed in writing before payment.

A refund should not automatically apply to:

- undefined expectations;
- out-of-scope scenarios;
- unsupported environments;
- participant infrastructure failures;
- unauthorized modification;
- inability to provide required access or evidence;
- failures unrelated to VRP;
- inconclusive results unless separately agreed.

The technical verdict and commercial refund decision are related but distinct records.

---

## 22. Security Research Boundary

Pilot participants may perform security testing only within the authorization established for the engagement.

Authorized testing may include agreed:

- replay scenarios;
- stale-state scenarios;
- malformed input;
- failure injection;
- boundary testing;
- resource-pressure testing;
- adversarial sequencing.

Pilot participation does not authorize testing against unrelated third-party systems or infrastructure.

Material security findings should be disclosed privately before public disclosure where appropriate.

---

## 23. Confidentiality

A pilot may involve information that should not be published automatically.

Potentially sensitive information may include:

- infrastructure topology;
- participant configuration;
- protected logs;
- proprietary application behavior;
- credentials;
- security findings;
- Protected Core material;
- commercial terms not designated public.

Publication boundaries should be agreed where necessary.

---

## 24. Pilot Duration

The standard controlled pilot period may run for up to **14 calendar days**, subject to the applicable written engagement terms.

The duration defines the evaluation window.

It does not imply continuous engineering support for every hour of that period unless explicitly agreed.

---

## 25. Expansion After Pilot

A successful pilot may justify a broader engagement.

Possible next stages include:

- additional failure scenarios;
- additional environments;
- application integration;
- security evaluation;
- interoperability work;
- deployment qualification;
- licensing discussion;
- controlled production deployment.

Expansion is a separate decision.

It is not automatic.

---

## 26. Engineering Principle

The pilot exists to challenge VRP, not to protect it from difficult conditions.

A useful pilot should expose the implementation to an environment that can teach the project something new.

The preferred sequence remains:

`DEFINE`

`BASELINE`

`DISRUPT`

`OBSERVE`

`VERIFY`

`REPRODUCE`

`VERDICT`

**SESSION ≠ TRANSPORT.**

**PAYMENT ≠ PASS.**

**DEMONSTRATION ≠ DEPLOYMENT.**

**EVIDENCE OVER ASSUMPTIONS.**

---

## Related Documentation

- `docs/CONTROLLED_PILOT_PROGRAM.md`
- `docs/commercial/PILOT_PRICING_ROADMAP.md`
- `docs/validation/IMPLEMENTATION_STATUS.md`
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

---

**Veil Routing Protocol (VRP)**  
**Pilot Engagement Lifecycle**