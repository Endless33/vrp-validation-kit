# Security Model

## Purpose

This document defines the security assumptions, trust boundaries, and threat model used by the VRP Validation Kit.

The Validation Kit evaluates observable runtime behavior.

It is not intended to expose protected runtime implementation.

---

# Security Objectives

The validation process is designed to demonstrate:

- deterministic runtime behavior
- observable continuity
- evidence integrity
- reproducible validation
- fail-closed behavior
- integrity verification
- resistance to common protocol manipulation attempts

---

# Protected Assets

The following assets remain outside the public validation boundary:

- protected runtime implementation
- internal decision logic
- scheduling algorithms
- optimization strategies
- commercial intellectual property
- deployment-specific configuration
- private runtime policies

These assets are intentionally excluded from public validation.

---

# Public Assets

The following artifacts are intended for independent evaluation:

- Validation Kit
- validation reports
- evidence bundles
- manifests
- signatures
- hashes
- validation procedures
- runtime verdicts

---

# Trust Boundary

The Validation Kit never requires direct access to the protected runtime.

Evaluation is based entirely on externally observable behavior.

Protected implementation remains isolated.

---

# Threat Model

The validation process assumes an evaluator may attempt to:

- replay validation inputs
- modify evidence
- alter manifests
- change hashes
- reorder packets
- inject duplicate traffic
- interrupt connectivity
- restart validation
- validate on independent hardware
- validate on different operating systems

The Validation Kit is intended to detect observable integrity violations where applicable.

---

# Out of Scope

The Validation Kit is not intended to:

- reveal proprietary algorithms
- expose protected runtime logic
- disclose implementation details
- replace a security audit
- replace penetration testing
- replace a complete source code review

---

# Engineering Assumptions

Validation is based on the following assumptions:

- validation software is executed without local malware interference
- operating system integrity is outside the Validation Kit scope
- hardware trust is outside the Validation Kit scope
- third-party libraries are trusted according to their published releases

---

# Security Philosophy

Engineering confidence should be based on observable evidence.

Independent verification should be reproducible.

Protected implementation should remain protected.

These goals are compatible.

The Validation Kit exists to validate behavior without requiring disclosure of protected implementation.

---

# Relationship to the Private Pilot

The Validation Kit provides public engineering validation.

The Private Pilot provides protected runtime evaluation under controlled conditions.

The two layers complement each other.

Neither replaces the other.

---

# Final Principle

Trust should never be requested.

Evidence should be provided.

Validation should be reproducible.

Engineering decisions should be based on independently verifiable results.