# VRP Threat Model and Trust Boundaries

**Veil Routing Protocol (VRP)**  
**Adversary Model, Protected Assets, Trust Assumptions, and Security Boundaries**

> SESSION ≠ TRANSPORT  
> Connectivity is observable. Authority must be earned.

## 1. Purpose

This document defines the threat-model framework used to reason about security boundaries within the Veil Routing Protocol.

The purpose is not to describe every possible attacker.

The purpose is to make security reasoning explicit:

- what VRP is attempting to protect;
- which components or properties are trusted;
- which inputs are not trusted by default;
- what capabilities an attacker may possess;
- where authority begins and ends;
- which failures must be rejected;
- which failures may be contained;
- which conditions remain outside a particular security claim.

A security property without an attacker model is incomplete.

---

## 2. Architectural Security Premise

VRP begins with the principle:

**SESSION ≠ TRANSPORT**

The transport carrying traffic is not the session itself.

Therefore:

- transport loss does not automatically destroy session identity;
- transport replacement does not automatically create new authority;
- address change does not automatically create a new session;
- path availability does not automatically establish trust;
- connectivity restoration does not automatically validate recovered state.

The security model must remain valid while the underlying network changes.

---

## 3. Protected Assets

Depending on deployment, VRP may need to protect assets including:

- session identity;
- authoritative state;
- session lifetime;
- epoch or generation state;
- authority capabilities;
- cryptographic key material;
- recovery state;
- path authorization state;
- canonical state transitions;
- replay state;
- historical state;
- evidence records;
- integrity manifests;
- validation verdicts;
- configuration;
- protected implementation material.

Not every asset has the same confidentiality, integrity, or availability requirements.

---

## 4. Security Property Classes

Protected assets may require different properties.

### Confidentiality

Unauthorized parties should not obtain protected information.

### Integrity

Unauthorized modification should be detectable or rejected.

### Authenticity

The relevant protocol material should be attributable to an authorized cryptographic or protocol context.

### Freshness

Previously valid material should not automatically remain valid indefinitely.

### Authority

Only an entity with valid authority for the relevant context may perform the protected operation.

### Availability

Authorized operation should remain possible within the limits of available infrastructure and the defined threat model.

### Historical Integrity

Protected evidence or protocol history should not accept unauthorized rewriting.

---

## 5. Trust Is Contextual

VRP does not define an object as universally trusted merely because it was trusted once.

Trust may depend on:

- session;
- lifetime;
- epoch;
- generation;
- key;
- path;
- operation;
- authority;
- protocol state;
- implementation version.

A value that is valid in one context may be invalid in another.

---

## 6. Primary Trust Boundaries

A VRP deployment should identify boundaries around:

### Endpoint Boundary

Which endpoint is authorized to participate?

### Session Boundary

Which state belongs to which session?

### Lifetime Boundary

Which events belong to the current session lifetime?

### Authority Boundary

Which entity or capability may perform a protected transition?

### Cryptographic Boundary

Which keys protect which context?

### Epoch or Generation Boundary

Which state belongs to the currently authoritative progression?

### Path Boundary

Which network path may carry traffic without being mistaken for identity or authority?

### Recovery Boundary

Which state may be used to reconstruct or continue operation?

### Evidence Boundary

Which evidence may be trusted when assigning a technical verdict?

---

## 7. Transport Is Not a Trust Anchor

A transport may provide connectivity.

It must not automatically define:

- session identity;
- canonical state;
- authority;
- freshness;
- recovery validity.

An attacker capable of influencing a transport should not automatically gain control of the session state associated with that transport.

---

## 8. Network Addresses Are Not Identity

IP addresses and ports may change legitimately.

They may also be spoofed, translated, rebound, reassigned, or otherwise manipulated depending on the environment.

VRP must therefore avoid treating network address stability as equivalent to session identity.

Address metadata may remain useful context.

It is not automatically an identity root.

---

## 9. Attacker Classes

Threat analysis may consider multiple attacker classes.

### Passive Network Observer

Can observe some or all network traffic but cannot necessarily modify it.

Potential capabilities:

- traffic timing observation;
- packet-size observation;
- endpoint metadata observation;
- transport-transition observation.

### Active Network Attacker

Can interfere with network traffic.

Potential capabilities:

- drop;
- delay;
- duplicate;
- reorder;
- replay;
- inject;
- modify;
- redirect traffic.

The exact capability depends on the evaluated scenario.

### Malicious or Faulty Peer

Participates in communication but may send invalid, stale, inconsistent, or adversarial protocol input.

### Resource Exhaustion Attacker

Attempts to consume finite resources through repeated or strategically constructed input.

### Evidence Attacker

Attempts to alter, replace, suppress, forge, or rewrite technical evidence.

### Compromised Authorized Endpoint

Controls an endpoint that may possess legitimate credentials, keys, or authority.

This represents a substantially stronger attacker than an external network attacker.

---

## 10. Capability-Based Threat Modeling

Attacker descriptions should focus on capabilities rather than labels.

For example:

`attacker can capture and replay previously valid packets`

is more useful than:

`advanced attacker`

Likewise:

`attacker controls the currently active network path but does not possess session key material`

is more testable than:

`powerful network adversary`

Threat models should be executable where practical.

---

## 11. Passive Network Attacker

A passive observer may be able to infer information even when protected payload content remains confidential.

Potential observations include:

- communication timing;
- traffic volume;
- endpoint addresses;
- migration timing;
- recovery events;
- connection duration;
- packet sizes.

VRP does not assume that payload encryption automatically eliminates metadata leakage.

---

## 12. Active Network Attacker

An active network attacker may attempt to manipulate delivery.

Relevant actions may include:

- dropping traffic;
- delaying traffic;
- duplicating traffic;
- reordering traffic;
- replaying captured traffic;
- inserting fabricated traffic;
- modifying unprotected traffic;
- forcing path changes;
- disrupting transport.

The protocol should preserve the required security invariants even when progress or availability cannot be preserved.

---

## 13. Replay Attacker

A replay attacker possesses protocol material that was valid previously.

The attacker attempts to reuse that material outside its intended context.

Relevant questions include:

- Is the replay still cryptographically authentic?
- Is it still fresh?
- Does it belong to the current session?
- Does it belong to the current lifetime?
- Does it belong to the current epoch or generation?
- Is the operation still authorized?
- Has the material already been consumed?

Authentication alone does not answer all of these questions.

---

## 14. Stale-State Attacker

A stale-state attacker attempts to present an older but potentially authentic state as current.

The objective may be to:

- restore old authority;
- reverse progress;
- bypass newer decisions;
- corrupt recovery;
- create divergent history.

Where monotonic progression is required, stale state must not silently regain authority.

---

## 15. Fork Attacker

A fork attacker attempts to create or preserve conflicting authoritative histories.

Potential objectives include:

- maintaining two competing canonical states;
- causing different nodes to accept incompatible histories;
- exploiting recovery to preserve both branches;
- presenting conflicting evidence.

Fork behavior should be evaluated according to VRP's canonical-state and authority rules.

---

## 16. Authority Attacker

An authority attacker attempts to perform an operation without valid authority for that exact context.

Possible attacks include:

- capability forgery;
- capability replay;
- cross-session capability reuse;
- cross-generation reuse;
- wrong-operation reuse;
- route-context substitution;
- stale capability use;
- concurrent double consumption.

Authority should be evaluated as a protocol security property rather than as ordinary metadata.

---

## 17. Recovery Attacker

Recovery may expose a high-value attack surface because the system is already operating under abnormal conditions.

A recovery attacker may attempt to:

- introduce stale state;
- replay previously valid state;
- substitute recovery evidence;
- exploit competing recovery attempts;
- exploit restart timing;
- regain obsolete authority;
- force canonical rollback.

Recovery logic must not weaken the normal security model merely to restore service.

---

## 18. Resource Attacker

A resource attacker may send traffic or operations designed to consume:

- memory;
- CPU;
- replay tracking;
- session state;
- history;
- evidence storage;
- sockets;
- threads or goroutines;
- recovery structures.

Correct rejection is not sufficient if rejection itself creates unbounded resource growth.

Resource behavior should therefore be part of adversarial validation.

---

## 19. Concurrency Attacker Model

Some vulnerabilities require no external malicious packet.

Adversarial scheduling may expose unsafe behavior through:

- simultaneous authority use;
- concurrent recovery;
- simultaneous path changes;
- read/write races;
- stale observations;
- non-atomic validation and mutation.

Concurrency should therefore be treated as an adversarial condition even when the scheduler itself is not malicious.

---

## 20. Evidence Attacker

An evidence attacker attempts to alter the technical record rather than the live protocol state.

Possible actions include:

- modifying logs;
- replacing manifests;
- changing verdicts;
- rewriting historical files;
- substituting artifacts;
- deleting failure evidence;
- presenting evidence from a different implementation version.

Evidence integrity mechanisms should make these attacks easier to detect where practical.

---

## 21. Trust Boundary: Session Identity

Session identity must remain distinct from the currently active transport.

A new transport should not automatically create a new authoritative session.

Likewise, possession of an old transport context should not automatically grant access to the current session state.

---

## 22. Trust Boundary: Session Lifetime

A session identifier alone may be insufficient if multiple lifetimes or incarnations are possible.

Where lifetime separation exists, events from a previous lifetime must not automatically become valid in a later lifetime.

Lifetime validation should occur before protected state mutation where required.

---

## 23. Trust Boundary: Epoch and Generation

Epoch or generation state may define monotonic authority progression.

Relevant threats include:

- rollback;
- stale transition;
- replay from earlier generation;
- concurrent conflicting generation;
- forged future generation.

The exact rules depend on the implementation and protocol specification.

---

## 24. Trust Boundary: Authority Capability

A security capability should grant only the authority intentionally represented by that capability.

Where applicable, capability design should consider binding to:

- session;
- owner;
- lifetime;
- generation;
- route;
- path;
- operation;
- issuance identity.

Capabilities should not expose mutable authority state unnecessarily.

---

## 25. Trust Boundary: Path

A path is a delivery mechanism.

It is not automatically an authority mechanism.

Path migration should preserve the distinction between:

`WHERE TRAFFIC CAN FLOW`

and:

`WHO OR WHAT IS AUTHORIZED TO CHANGE STATE`

---

## 26. Trust Boundary: Recovery

Recovery must operate under explicit authority.

The existence of a failure does not create unlimited permission to reconstruct arbitrary state.

Recovery should preserve required:

- identity;
- authority;
- freshness;
- historical integrity;
- canonical-state rules.

---

## 27. Trust Boundary: Evidence

Evidence should be bound to the implementation and scenario that produced it.

Useful bindings may include:

- run identifier;
- commit;
- tree;
- artifact hash;
- scenario;
- timestamp;
- manifest;
- evidence root;
- signature where available.

Evidence without implementation identity may be difficult to interpret later.

---

## 28. Canonical State

Where VRP defines canonical state, only authorized transitions should modify it.

Rejected operations should not produce partial canonical mutation.

This is particularly important when validation and mutation occur across multiple components or synchronization boundaries.

---

## 29. Atomicity

Security-sensitive state changes may require atomic behavior.

A failed operation should not leave behind authority or state mutation that would not exist if the operation had been rejected before mutation.

Threat analysis should therefore consider:

- validation-before-mutation;
- rollback behavior;
- partial failure;
- concurrent observation;
- capability consumption.

---

## 30. TOCTOU

A value may be valid when checked and invalid when used.

Security-sensitive implementations should identify cases where mutable state is:

1. inspected;
2. validated;
3. changed by another operation;
4. consumed using an outdated assumption.

Where necessary, validation and use should share an appropriate synchronization or ownership boundary.

---

## 31. Observer Boundaries

Diagnostic or observer interfaces should not accidentally become authority interfaces.

An observer intended only to inspect state should not automatically receive mutable access to canonical structures.

Read-only capability design and defensive snapshots may be appropriate where required.

---

## 32. Public Boundary

Public APIs and validation interfaces form an important trust boundary.

They should be evaluated for:

- unauthorized state mutation;
- capability leakage;
- information leakage;
- inconsistent validation;
- malformed input;
- boundary fuzzing;
- timing behavior;
- error behavior.

Public access to a boundary must not imply direct access to Protected Core state.

---

## 33. Protected Core Boundary

The Protected Core is intentionally separated from public validation and demonstration surfaces.

This boundary exists for both:

- intellectual-property protection;
- reduction of unnecessary implementation exposure.

Security through obscurity is not treated as a substitute for correct security design.

At the same time, a secure design does not require publication of every proprietary implementation detail.

---

## 34. Fail-Closed Boundary

Where ambiguity could authorize invalid state, the preferred security outcome may be rejection.

Examples may include:

- invalid authority;
- stale generation;
- unrecognized recovery context;
- failed integrity verification;
- conflicting canonical state.

Fail-closed behavior must remain scoped to the relevant invariant and implementation.

---

## 35. Availability Boundary

VRP cannot guarantee communication when all usable physical communication paths are unavailable.

The protocol may preserve valid session state or recovery context during an outage.

That is different from guaranteeing active data transfer without infrastructure.

The distinction between state continuity and physical availability must remain explicit.

---

## 36. Compromised Key Boundary

An attacker possessing legitimate key material may bypass protections that assume the key remains secret.

The consequences depend on key scope.

Relevant questions include:

- Can the key authorize one session or many?
- Is it generation-bound?
- Can it be revoked?
- Can compromise be contained?
- Can future state recover safely?

Key compromise must not be modeled as equivalent to ordinary packet injection.

---

## 37. Compromised Endpoint Boundary

Complete endpoint compromise may expose:

- keys;
- credentials;
- runtime state;
- configuration;
- authorized operations;
- evidence before external sealing.

VRP does not claim universal protection when the trusted computing base itself is fully controlled by an attacker.

Specific deployments may introduce additional hardware or operational trust mechanisms.

---

## 38. Operator Boundary

Operators may possess privileges unavailable to network participants.

Deployment security should define:

- who may configure VRP;
- who may access protected artifacts;
- who may rotate keys;
- who may inspect sensitive evidence;
- who may authorize deployment;
- who may change trust configuration.

Operator compromise is distinct from network attack.

---

## 39. Build and Supply-Chain Boundary

A correct protocol implementation can still be compromised before execution.

Relevant supply-chain concerns may include:

- source modification;
- dependency substitution;
- build-environment compromise;
- artifact replacement;
- unauthorized release modification.

Integrity records can help identify expected artifacts but do not eliminate every supply-chain threat.

---

## 40. Validation Boundary

A test harness can itself contain defects.

Therefore:

`TEST PASS`

does not automatically mean:

`PROPERTY PROVEN`

Validation infrastructure should itself be reviewed, challenged, and where practical independently verified.

---

## 41. Threat-to-Invariant Mapping

Important security scenarios should identify the invariant they attempt to violate.

Example structure:

`ATTACKER CAPABILITY`

-> `TARGET ASSET`

-> `TARGET INVARIANT`

-> `ATTACK ACTION`

-> `EXPECTED DEFENSE`

-> `OBSERVED RESULT`

-> `VERDICT`

This structure makes security validation easier to audit.

---

## 42. Multiple Simultaneous Failures

Real failures may occur together.

Examples include:

- transport loss during recovery;
- replay during path migration;
- restart during authority transfer;
- resource pressure during network instability;
- concurrency pressure during recovery.

Individual scenario success does not automatically prove correctness under combined failures.

Multi-vector scenarios should be evaluated separately where they matter.

---

## 43. Threat Model Evolution

The threat model must evolve when the protocol changes.

Review should be triggered by material changes to:

- wire format;
- cryptography;
- authority model;
- session identity;
- recovery;
- state machine;
- public API;
- evidence architecture;
- deployment model;
- trust assumptions.

A threat model that describes an obsolete architecture provides false confidence.

---

## 44. Out-of-Scope Does Not Mean Safe

Marking a threat out of scope does not mean the threat cannot occur.

It means the corresponding evaluation is not claiming protection against that threat.

This distinction should remain visible in technical and commercial communication.

---

## 45. Residual Threats

Even after successful validation, residual threats may remain.

Examples include:

- undiscovered implementation defects;
- untested race conditions;
- dependency vulnerabilities;
- endpoint compromise;
- key compromise;
- operator compromise;
- supply-chain compromise;
- resource exhaustion;
- future cryptographic weaknesses;
- new attack techniques;
- unsupported deployment environments.

Residual risk must be considered during deployment decisions.

---

## 46. Validation Requirement

Where practical, threat-model claims should lead to executable adversarial scenarios.

A useful progression is:

`THREAT`

`ATTACKER CAPABILITY`

`SECURITY INVARIANT`

`TEST`

`EVIDENCE`

`VERDICT`

Threat modeling without testing is incomplete.

Testing without a threat model may test the wrong thing.

---

## 47. No Universal Attacker Claim

VRP does not claim security against an undefined attacker with unlimited capabilities.

Security claims must identify the relevant attacker model.

Examples of meaningful statements include:

`replay was rejected under the defined session and generation context`

or:

`canonical state remained unchanged after the tested invalid authority operation`

rather than:

`VRP defeats all attackers`

---

## 48. Review Questions

A security reviewer evaluating VRP should be able to ask:

1. What asset are we protecting?
2. What is the required security property?
3. What does the attacker control?
4. What does the attacker not control?
5. What is trusted?
6. Why is it trusted?
7. Where is authority established?
8. What makes state fresh?
9. What happens when transport disappears?
10. What happens when stale state returns?
11. What happens when recovery races?
12. What happens when evidence is modified?
13. What happens when a trusted component is compromised?
14. What evidence supports the answer?

If these questions cannot be answered, the threat model is incomplete.

---

## 49. Final Trust Principles

Do not trust transport because it currently works.

Do not trust an address because it was valid before.

Do not trust state merely because it is authentic.

Do not trust authority outside its intended context.

Do not trust recovery merely because connectivity returned.

Do not trust evidence without knowing what produced it.

Do not treat an out-of-scope threat as an impossible threat.

**SESSION ≠ TRANSPORT.**

**ADDRESS ≠ IDENTITY.**

**CONNECTIVITY ≠ AUTHORITY.**

**AUTHENTIC ≠ CURRENT.**

**RECOVERY ≠ PERMISSION.**

**EVIDENCE ≠ ASSUMPTION.**

---

## Related Documentation

- `docs/CONTROLLED_PILOT_PROGRAM.md`
- `docs/validation/IMPLEMENTATION_STATUS.md`
- `docs/validation/VALIDATION_EVIDENCE_STANDARD.md`
- `docs/validation/INTEROPERABILITY_AND_DEPLOYMENT_READINESS.md`
- `docs/security/SECURITY_CONSIDERATIONS.md`
- `docs/governance/VRP_MATURITY_AND_RELEASE_POLICY.md`

---

## Security Contact

**Proton Mail:**  
`jumpingvpn@proton.me`

For responsible security reports, include enough technical information to reproduce or investigate the issue where possible.

---

**Veil Routing Protocol (VRP)**  
**Threat Model and Trust Boundaries**