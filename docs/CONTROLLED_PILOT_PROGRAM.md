# VRP Controlled Pilot Program

**Veil Routing Protocol (VRP)**  
**Controlled Technical Validation — Pilot Access**

> SESSION ≠ TRANSPORT  
> Evidence over assumptions.

This document describes the commercial and technical process for organizations that want to evaluate VRP under their own controlled conditions.

This is not an offer to purchase the VRP source code.

The Protected Core remains private, proprietary, and access-controlled.

The purpose of the pilot is simple:

**define the failure scenario, define the invariants, run the test, and examine the evidence.**

---

## 1. Pilot Fee

Current pilot fee:

**€25,000 EUR**

Pilot duration:

**up to 14 calendar days**

The fee covers a controlled technical evaluation within an agreed scope.

The pilot is not an unlimited penetration-testing engagement, production SLA, source-code sale, patent license, or transfer of VRP intellectual property.

Future pilot pricing may change as VRP development, validation, deployment experience, and commercial scope evolve.

The applicable price is the price agreed in writing before the pilot begins.

---

## 2. Before Any Payment

Before payment, both sides should agree in writing on:

- organization and authorized contact;
- pilot environment;
- intended use case;
- network topology relevant to the evaluation;
- failure scenarios to be tested;
- success criteria;
- critical invariants;
- test boundaries;
- permitted adversarial actions;
- duration of the pilot;
- evidence expected from the evaluation;
- confidentiality requirements;
- delivery method;
- payment method;
- refund conditions;
- any additional commercial or legal terms.

No organization should send funds merely because it discovered a wallet address in this repository.

**Contact me first and obtain written confirmation of the pilot scope and payment instructions.**

---

## 3. What You Bring

The participating organization should bring a real technical question.

Examples include:

- transport interruption;
- path migration;
- NAT rebinding;
- address change;
- temporary network loss;
- packet duplication;
- packet reordering;
- stale state;
- replay attempts;
- recovery scenarios;
- concurrency pressure;
- infrastructure restart;
- multi-path transitions;
- application continuity requirements;
- other agreed failure conditions.

Bring your engineers.

Bring your environment.

Bring the scenario you believe matters.

Do not design the test to make VRP look good.

Design it to answer the technical question.

---

## 4. Success Criteria Are Defined First

The pilot does not begin with a desired conclusion.

Before execution, we define what constitutes:

- `PASS`
- `FAIL`
- `INCONCLUSIVE`
- infrastructure/environment failure
- out-of-scope behavior

Where practical, critical invariants should be written before testing begins.

Examples may include:

- session identity remains valid across an allowed transport transition;
- stale state is rejected;
- replayed input is rejected;
- unauthorized authority transitions are rejected;
- canonical state is not silently corrupted;
- recovery converges to an agreed valid state;
- evidence corresponds to the observed verdict.

The exact criteria depend on the pilot.

---

## 5. Enterprise Pilot Kit

After payment confirmation and completion of the required commercial/onboarding steps, the participant receives the applicable **VRP Enterprise Pilot Kit** for the agreed evaluation.

The kit may include, depending on scope:

- pilot-specific documentation;
- deployment instructions;
- environment preparation instructions;
- validation procedures;
- scenario definitions;
- test configuration;
- evidence collection procedures;
- verification instructions;
- integrity information;
- pilot-specific artifacts required for the agreed evaluation.

The exact contents are determined by the agreed pilot scope.

Receiving a Pilot Kit does **not** grant ownership of the VRP Protected Core or unrestricted rights to copy, redistribute, reverse engineer, sublicense, publish, or commercially exploit protected VRP materials.

Any access is governed by the applicable written terms.

---

## 6. Secure Delivery

Pilot materials are delivered only to the authorized participant.

The delivery channel will be agreed before transfer.

Depending on the engagement, this may include:

- an access-controlled private repository;
- an encrypted file transfer;
- an authenticated encrypted communication channel;
- another mutually agreed secure delivery mechanism.

For smaller direct evaluations, an agreed end-to-end encrypted channel may also be used.

Sensitive pilot material should not be redistributed through public channels.

Integrity hashes may be supplied so the recipient can verify that received artifacts are identical to the artifacts issued for the pilot.

---

## 7. Evidence, Not Marketing

A successful pilot should produce technical evidence.

Depending on scope, this may include:

- test logs;
- scenario identifiers;
- timestamps;
- configuration records;
- PASS / FAIL verdicts;
- failure traces;
- recovery traces;
- integrity hashes;
- evidence manifests;
- reproducibility instructions;
- other agreed verification material.

A failed test will not be silently converted into a successful result.

If something fails, the failure should be recorded and investigated.

If something survives, the evidence should show why the verdict was reached.

---

## 8. Limited Failure Refund

I want the commercial risk to be shared fairly.

For an eligible pilot, **50% of the pilot fee may be refundable** if a pre-agreed critical VRP invariant reproducibly fails during the agreed pilot evaluation.

Eligibility for this refund must be included in the written pilot terms before payment.

A qualifying failure must:

1. occur inside the agreed pilot scope;
2. violate a critical invariant defined before testing;
3. be reproducible or otherwise supported by sufficient technical evidence;
4. be attributable to the evaluated VRP behavior rather than an unrelated participant infrastructure failure; and
5. satisfy any additional refund conditions agreed before the pilot begins.

A disagreement about performance expectations that were never included in the agreed success criteria does not automatically constitute a qualifying failure.

Out-of-scope testing does not automatically qualify.

The remaining portion of the fee compensates for pilot preparation, engineering time, delivery, test execution, investigation, and evidence production already performed.

Any refund decision and payment mechanics are governed by the written pilot agreement.

---

## 9. Payment

The pilot is priced in EUR.

Payment method is agreed during onboarding.

Cryptocurrency may be accepted where legally and operationally appropriate.

**Do not send cryptocurrency before receiving written payment confirmation and instructions.**

Current payment addresses, when cryptocurrency payment has been explicitly agreed:

### Bitcoin (BTC)

`bc1qafvdlevfeld4zvmqhvalwqdcc7jag2xanecfwx`

### Ethereum (ETH)

`0x3b51AaF84F958e082b90639bd7728544234Ff7c9`

### Litecoin (LTC)

`ltc1qden05pz46cwtk022y9cqhzzfkj2ssgq42ldmys`

Before transferring funds, independently confirm the destination address through an agreed authenticated communication channel.

A blockchain transaction alone does not define the pilot scope or create rights beyond those expressly agreed in writing.

---

## 10. Protected Core

The VRP Protected Core is not made public as part of this program.

Public validation material exists so that technical claims can be challenged without requiring unrestricted disclosure of protected implementation details.

The distinction is intentional:

**PUBLIC ARCHITECTURE ≠ PUBLIC IMPLEMENTATION**

**VALIDATION ACCESS ≠ SOURCE OWNERSHIP**

**PILOT ACCESS ≠ UNRESTRICTED LICENSE**

The exact rights granted for a pilot are those stated in the applicable written agreement.

---

## 11. Security Research and Adversarial Testing

Serious technical criticism is welcome.

Participants may attempt agreed adversarial scenarios within the authorized pilot environment and scope.

If you believe you have found a failure:

do not send a marketing argument.

Send the evidence.

Preferably provide:

- exact scenario;
- environment;
- configuration;
- commands or reproduction procedure;
- expected invariant;
- observed behavior;
- logs;
- timestamps;
- relevant hashes;
- minimal reproducible case.

A reproducible failure is useful engineering information.

---

## 12. What the Pilot Does Not Promise

No distributed system should be represented as universally unbreakable.

Participation in this program does not mean that VRP is guaranteed to survive every possible failure, attacker, infrastructure condition, implementation defect, or future environment.

The pilot evaluates the agreed scenarios and invariants.

Claims should follow evidence.

Not the other way around.

---

## 13. Pilot Outcome

At the end of the pilot, the outcome should be one of the following:

### PASS

The agreed success criteria were satisfied by the available evidence.

### FAIL

One or more agreed critical criteria were violated.

### INCONCLUSIVE

The available evidence or environment was insufficient to reach a technically defensible conclusion.

A commercial deployment or broader license is a separate decision following the pilot.

Successful pilot completion does not automatically create production deployment rights.

---

## 14. Contact

Organizations, infrastructure teams, network engineers, security engineers, researchers, and potential pilot partners may contact me directly.

**DM:** LinkedIn / agreed direct channel

**Proton Mail:**  
`jumpingvpn@proton.me`

**Email:**  
`riabovasvitalijus@gmail.com`

Suggested subject:

`VRP CONTROLLED PILOT — [Organization / Use Case]`

Please include:

- organization or team;
- technical contact;
- intended environment;
- problem you want to evaluate;
- failure scenario;
- desired pilot timeframe.

---

## 15. The Principle

You do not need to trust a LinkedIn post.

You do not need to trust a diagram.

You do not need to trust the author.

Bring the environment.

Define the invariant.

Run the scenario.

Examine the evidence.

**SESSION ≠ TRANSPORT.**

**Veil Routing Protocol — Controlled Pilot Program**