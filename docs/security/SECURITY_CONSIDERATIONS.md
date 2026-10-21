# VRP Security Considerations

**Veil Routing Protocol (VRP)**  
**Security Properties, Attack Surface, Failure Boundaries, and Residual Risk**

> Continuity without integrity is not success.  
> Recovery without authority is not recovery.

## 1. Purpose

This document defines the security considerations that should accompany technical evaluation of the Veil Routing Protocol.

VRP does not treat the word `secure` as a sufficient security claim.

Security must instead be decomposed into specific properties, attacker capabilities, trust assumptions, failure conditions, validation scenarios, and residual risks.

This document is not a claim that VRP is immune to every attack.

It defines how security claims should be reasoned about and evaluated.

---

## 2. Security Philosophy

VRP is designed around environments in which network conditions may be unstable, hostile, ambiguous, or rapidly changing.

A transport becoming available does not automatically make it trustworthy.

A previously valid state does not automatically remain valid forever.

A successful reconnection does not automatically mean recovery was secure.

VRP therefore separates:

- connectivity;
- continuity;
- identity;
- authority;
- state validity;
- recovery;
- evidence.

Security evaluation must preserve these distinctions.

---

## 3. Core Security Principle

The architectural principle:

**SESSION ≠ TRANSPORT**

has direct security consequences.

Transport is treated as replaceable.

Therefore, authority must not be inferred solely from:

- current network path;
- source address;
- transport existence;
- previous transport validity;
- successful packet delivery.

A replacement transport must not silently become a replacement identity or replacement authority.

---

## 4. Security Objectives

Depending on the implementation and deployment, relevant VRP security objectives may include:

- session identity integrity;
- authoritative-state integrity;
- transition integrity;
- replay resistance;
- stale-state rejection;
- authenticated state transitions;
- recovery integrity;
- authority preservation;
- key-context binding;
- epoch or generation integrity;
- path-context validation;
- evidence integrity;
- historical integrity;
- confidentiality where applicable;
- fail-closed behavior for critical ambiguity;
- bounded resource behavior under hostile input.

Not every deployment necessarily requires every property.

Required properties should be explicit.

---

## 5. Security Properties Must Be Scoped

Statements such as:

`VRP rejects replay`

should be interpreted according to a defined implementation, replay model, state context, and validation scenario.

A stronger statement identifies:

- what was replayed;
- when it was replayed;
- which context had changed;
- which component evaluated it;
- what rejection means;
- whether authoritative state remained unchanged.

Security claims become stronger when their boundaries become narrower and more testable.

---

## 6. Threat Categories

VRP security evaluation should consider relevant threat categories including:

- passive observation;
- message replay;
- stale-state presentation;
- message duplication;
- message reordering;
- message insertion;
- message deletion;
- message modification;
- forged transitions;
- unauthorized authority use;
- invalid recovery;
- path manipulation;
- transport disruption;
- state rollback;
- state fork;
- evidence tampering;
- history rewriting;
- resource exhaustion;
- concurrency pressure;
- restart races;
- denial of service;
- compromised credentials;
- compromised endpoints.

This list is not exhaustive.

---

## 7. Passive Observation

Where confidentiality is required, evaluation should consider what information an observer can learn without modifying traffic.

Potentially observable information may include:

- packet timing;
- packet size;
- connection timing;
- transport changes;
- recovery timing;
- endpoint metadata;
- traffic volume;
- public protocol metadata.

Encryption of payload content does not automatically eliminate traffic-analysis exposure.

---

## 8. Replay

Previously valid input may become invalid when its context changes.

Replay evaluation should consider whether an attacker can reuse previously observed material to:

- repeat an operation;
- restore stale authority;
- advance state incorrectly;
- trigger duplicate behavior;
- interfere with recovery;
- create inconsistent history.

Replay protection should be evaluated against the actual protocol context rather than treated as a generic boolean property.

---

## 9. Stale State

Cryptographically authentic data may still be stale.

VRP security therefore distinguishes:

`AUTHENTIC`

from:

`CURRENTLY AUTHORIZED`

A previously valid state must not automatically override newer authoritative state merely because its original authentication remains valid.

---

## 10. State Rollback

An attacker or failure condition may attempt to return the system to an older state.

Rollback evaluation should consider:

- epochs;
- generations;
- authority state;
- recovery state;
- session lifetime;
- history;
- version state.

Where monotonic progression is required, rollback should not silently violate it.

---

## 11. State Fork

Distributed state may diverge.

Security evaluation should consider whether conflicting branches can:

- simultaneously claim authority;
- independently advance canonical state;
- produce contradictory evidence;
- survive reconciliation incorrectly.

Fork handling should preserve the protocol's defined authority and convergence rules.

---

## 12. Message Modification

Where integrity protection applies, unauthorized modification should be detectable or rejected according to the relevant protocol rule.

Testing should distinguish between:

- protected payload modification;
- metadata modification;
- context substitution;
- authenticated but semantically invalid state.

Cryptographic integrity does not automatically guarantee semantic validity.

---

## 13. Message Insertion

An attacker may attempt to inject protocol material that was never legitimately generated for the current context.

Evaluation should determine whether inserted material can:

- create state;
- advance state;
- obtain authority;
- trigger recovery;
- alter routing;
- alter history;
- consume resources.

---

## 14. Message Deletion

An attacker capable of dropping traffic may prevent progress even when unable to forge valid state.

Security analysis should therefore distinguish:

- integrity preservation;
- availability;
- continuity;
- progress.

A system may remain secure while temporarily unable to make progress.

---

## 15. Reordering

Network packets may arrive in a different order from transmission.

Reordering should not automatically be interpreted as malicious, but hostile reordering may be used to expose state-management weaknesses.

Evaluation should consider:

- ordering assumptions;
- replay windows;
- epoch transitions;
- recovery transitions;
- duplicate handling.

---

## 16. Duplication

Networks and attackers may duplicate traffic.

Duplicate input should not cause unintended duplicate authority, state transitions, resource growth, or application-visible side effects beyond the defined protocol behavior.

---

## 17. Transport Disruption

An attacker or infrastructure failure may remove the active transport.

VRP should distinguish:

`TRANSPORT FAILURE`

from:

`SESSION INVALIDATION`

where the architecture and security state permit that distinction.

Transport disappearance must not automatically authorize unsafe recovery behavior.

---

## 18. Path Manipulation

Path changes may be legitimate or adversarial.

Evaluation should consider whether a new path can improperly inherit:

- identity;
- authority;
- key context;
- recovery privileges;
- canonical state.

A reachable path is not automatically an authorized path.

---

## 19. NAT Rebinding and Address Change

Address changes are common in real networks.

A protocol designed for continuity must not rely on address stability in ways that contradict its architectural model.

At the same time, acceptance of a new address must not create an authority bypass.

The relevant security context must remain authoritative.

---

## 20. Authority

Authority is a critical trust boundary.

Security analysis should ask:

- Who may initiate a transition?
- How is authority represented?
- How long is authority valid?
- Which context binds it?
- Can it be replayed?
- Can it cross sessions?
- Can it cross generations?
- Can it be forged?
- Can it survive an invalid transition?
- Can concurrent operations misuse it?

Authority mechanisms should be treated as security capabilities rather than convenience metadata.

---

## 21. Recovery Security

Recovery is a security-sensitive state transition.

A recovery mechanism should not restore service by silently accepting state that normal operation would reject.

Recovery evaluation should consider:

- stale state;
- replay;
- authority;
- competing recovery attempts;
- concurrent transitions;
- interrupted recovery;
- restart during recovery;
- evidence continuity.

**Connectivity restored** is not sufficient evidence of secure recovery.

---

## 22. Concurrency

Security invariants may fail under concurrency even when sequential execution appears correct.

Relevant evaluation may include:

- race detection;
- simultaneous transitions;
- concurrent authority use;
- concurrent recovery;
- competing migrations;
- state observation during mutation;
- atomicity boundaries.

A concurrency defect can become a security defect when it permits an otherwise invalid state transition.

---

## 23. TOCTOU Risk

Time-of-check to time-of-use behavior should be considered wherever mutable state is validated and later consumed.

Security-sensitive decisions should not assume that validated state remains unchanged unless the implementation provides the required synchronization or ownership guarantee.

---

## 24. Resource Exhaustion

Valid-looking or invalid input may attempt to consume:

- memory;
- CPU;
- state entries;
- replay-window capacity;
- recovery history;
- evidence storage;
- goroutines or threads;
- sockets;
- other finite resources.

Security evaluation should distinguish rejection correctness from resource-bounded rejection.

Rejecting an attack only after unbounded resource growth is not sufficient.

---

## 25. Denial of Service

No VRP documentation should claim universal immunity to denial of service.

An attacker capable of removing all usable communication paths may prevent communication.

Other attackers may exhaust resources or dependencies outside VRP's control.

The security objective may therefore be:

- preserve integrity;
- reject invalid state;
- remain bounded;
- recover when valid infrastructure returns;

rather than guarantee uninterrupted availability under every attacker capability.

---

## 26. Fail-Closed Behavior

When accepting ambiguous state could violate a critical security invariant, rejection should be preferred where the protocol requires fail-closed behavior.

Fail-closed does not mean every error must terminate the entire session.

The relevant containment boundary should be explicit.

---

## 27. Cryptographic Protection

Where cryptography is used, documentation should distinguish the intended function.

Examples include:

- confidentiality;
- integrity;
- authentication;
- replay protection;
- key binding;
- session binding;
- epoch binding;
- generation binding;
- path binding;
- operation binding.

A cryptographic primitive does not automatically provide all of these properties.

The protocol construction determines how the primitive is used.

---

## 28. Key Management

Cryptographic security depends on key management.

Relevant considerations may include:

- generation;
- storage;
- access control;
- rotation;
- revocation;
- destruction;
- compromise recovery;
- lifetime;
- context binding.

A protocol may use strong cryptography and still fail because keys are handled incorrectly.

---

## 29. Key Compromise

If an attacker obtains valid key material, some protocol guarantees may no longer hold.

The exact consequences depend on:

- which key was compromised;
- key scope;
- key lifetime;
- session scope;
- epoch or generation;
- revocation behavior;
- recovery design.

Documentation should avoid claiming that protocol logic universally neutralizes valid-key compromise.

---

## 30. Endpoint Compromise

A fully compromised authorized endpoint may operate with legitimate credentials and access.

This is materially different from an external network attacker.

VRP cannot universally guarantee security against an attacker who completely controls a trusted endpoint.

Deployment threat models should state whether endpoint compromise is in scope.

---

## 31. Dependency Risk

VRP may depend on:

- operating systems;
- cryptographic libraries;
- runtimes;
- network stacks;
- virtualization;
- storage;
- time sources;
- other infrastructure.

A vulnerability in a dependency may affect VRP even when the protocol logic is correct.

Dependency risk remains part of the operational security model.

---

## 32. Evidence Security

Validation evidence itself may become a target.

An attacker may attempt to:

- delete evidence;
- modify logs;
- substitute verdicts;
- rewrite history;
- replace artifacts;
- alter manifests.

Important evidence may therefore require integrity protection independent of the runtime behavior being tested.

---

## 33. Evidence Does Not Replace Security

A cryptographic hash proves an integrity relationship for the hashed bytes.

A signed record can provide additional evidence about control of a signing key.

Neither proves that the underlying software is free from vulnerabilities.

Integrity evidence and security correctness are different properties.

---

## 34. Logging Security

Logs can assist validation and incident response but may also expose sensitive information.

Logging design should consider:

- secrets;
- keys;
- identifiers;
- topology;
- internal state;
- personal data;
- operational metadata.

Security evidence should expose enough information for investigation without unnecessarily expanding the information-leakage surface.

---

## 35. Error Behavior

Error messages may reveal internal information.

External error surfaces should be evaluated for:

- excessive implementation detail;
- authority-state leakage;
- state-machine leakage;
- timing differences;
- identifier leakage;
- cryptographic context leakage.

Useful diagnostics and information minimization may require different interfaces for public and protected environments.

---

## 36. Timing and Side Channels

Cryptographic protection does not automatically eliminate side channels.

Depending on deployment sensitivity, evaluation may need to consider:

- timing;
- response size;
- error behavior;
- traffic pattern;
- resource consumption;
- observable recovery behavior.

No general side-channel resistance claim should be made without appropriate evidence.

---

## 37. Privacy

Security and privacy overlap but are not identical.

A secure VRP deployment may still expose metadata that creates privacy concerns.

Future protocol specifications should separately document privacy considerations where applicable.

---

## 38. Trust Assumptions

Every security claim depends on assumptions.

Examples may include:

- trusted endpoint;
- uncompromised key material;
- correct cryptographic implementation;
- sufficient entropy;
- correct system time where relevant;
- correct operating-system behavior;
- authorized operator;
- protected evidence storage.

Assumptions should be explicit when they materially affect the claim.

---

## 39. Out-of-Scope Conditions

A security evaluation should identify conditions that are not covered.

Examples may include:

- fully compromised endpoint;
- stolen valid credentials;
- compromised operating-system kernel;
- compromised cryptographic library;
- physical hardware compromise;
- unlimited resource attacker;
- permanent destruction of all communication paths.

Out-of-scope does not mean impossible.

It means the corresponding guarantee is not being claimed by that evaluation.

---

## 40. Residual Risk

Successful validation reduces uncertainty.

It does not eliminate all risk.

Residual risk may include:

- undiscovered implementation defects;
- untested concurrency behavior;
- dependency vulnerabilities;
- configuration mistakes;
- operator mistakes;
- untested network environments;
- future attack techniques;
- cryptographic implementation defects;
- endpoint compromise;
- resource exhaustion;
- incomplete observability.

Residual risk should be considered before production deployment.

---

## 41. Adversarial Validation

Security claims should be challenged through executable scenarios where practical.

Relevant scenarios may include:

- replay attempts;
- stale-state injection;
- forged authority;
- invalid transition;
- transport collapse;
- path replacement;
- concurrent recovery;
- history modification;
- evidence substitution;
- resource pressure.

A security design becomes stronger when engineers actively attempt to falsify its assumptions.

---

## 42. Vulnerability Reporting

Potential security issues should be reported privately before public disclosure when the issue could create unnecessary risk for users, pilot participants, or protected infrastructure.

Reports should include, where possible:

- affected component;
- implementation/version;
- environment;
- attack prerequisites;
- reproduction steps;
- observed result;
- expected security property;
- logs or traces;
- proof-of-concept material;
- impact assessment.

Security contact:

`jumpingvpn@proton.me`

---

## 43. Responsible Testing

Security research against VRP should be performed only against systems and environments for which the researcher has authorization.

Public availability of validation tooling does not authorize attacks against third-party infrastructure.

Controlled pilot participants must remain within the testing boundaries agreed for their engagement.

---

## 44. Security Claim Language

Preferred language:

`validated against the following replay scenario`

`rejected under the tested stale-state condition`

`preserved the defined authority invariant during the tested transition`

Avoid unsupported absolute language such as:

`unhackable`

`impossible to break`

`secure against every attacker`

`cannot fail`

Engineering claims should remain falsifiable.

---

## 45. Security Review Evolution

This document should evolve as VRP evolves.

Material changes in:

- protocol state;
- cryptography;
- authority;
- recovery;
- wire format;
- trust boundaries;
- deployment model;

may require corresponding security review.

Security documentation is not a one-time release artifact.

---

## 46. Final Security Principles

A packet being authentic does not automatically make it current.

A path being reachable does not automatically make it authorized.

A transport recovering does not automatically mean the session recovered securely.

A successful recovery does not justify abandoning authority.

A PASS does not prove universal security.

A failure that reveals a real weakness is useful evidence.

**SESSION ≠ TRANSPORT.**

**CONTINUITY ≠ AUTHORITY.**

**CONNECTIVITY ≠ TRUST.**

**RECOVERY ≠ PERMISSION.**

**Evidence over assumptions.**

---

## Related Documentation

- `docs/CONTROLLED_PILOT_PROGRAM.md`
- `docs/validation/IMPLEMENTATION_STATUS.md`
- `docs/validation/VALIDATION_EVIDENCE_STANDARD.md`
- `docs/validation/INTEROPERABILITY_AND_DEPLOYMENT_READINESS.md`
- `docs/security/THREAT_MODEL_AND_TRUST_BOUNDARIES.md`
- `docs/governance/VRP_MATURITY_AND_RELEASE_POLICY.md`

---

**Veil Routing Protocol (VRP)**  
**Security Considerations**