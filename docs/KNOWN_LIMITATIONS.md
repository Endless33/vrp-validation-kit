# Known Limitations

## Purpose

This document describes the current scope and limitations of the VRP Validation Kit.

Understanding the limits of a validation environment is an important part of engineering evaluation.

No validation framework should claim capabilities that it does not provide.

---

# Scope

The Validation Kit validates observable runtime behavior.

It does not expose protected runtime implementation.

The Validation Kit is intended to demonstrate reproducible engineering properties rather than disclose proprietary technology.

---

# Current Limitations

## Source Code Review

The Validation Kit is not a source code review.

It does not provide access to protected runtime implementation.

Organizations requiring implementation review should discuss that separately under an appropriate legal and commercial framework.

---

## Penetration Testing

The Validation Kit is not a penetration testing framework.

It does not attempt to simulate every possible attack against every possible deployment.

Its objective is validation of observable protocol behavior.

---

## Operating System Security

The Validation Kit does not verify:

- operating system integrity
- firmware integrity
- BIOS security
- hardware trust
- hypervisor security

Those components remain outside the validation boundary.

---

## Third-Party Software

The Validation Kit assumes that supported operating systems and publicly documented dependencies behave according to their published specifications.

Validation of third-party software is outside the project scope.

---

## Deployment Environment

Production deployments may differ from laboratory environments.

Latency,

packet loss,

routing,

firewalls,

network topology,

and hardware characteristics

may influence observed performance.

Validation results should therefore be interpreted together with deployment conditions.

---

## Performance Benchmarks

The Validation Kit is not intended to produce universal performance rankings.

Its primary objective is correctness,

continuity,

recovery,

integrity,

and reproducibility.

Performance measurements may vary depending on hardware and environment.

---

## Commercial Evaluation

The Validation Kit is not a replacement for a Private Pilot.

Some engineering properties can only be evaluated within the protected runtime environment.

The Pilot exists for that purpose.

---

## Future Evolution

The Validation Kit will continue to evolve.

Additional validation scenarios,

reports,

evidence formats,

and engineering documentation

may be introduced over time.

Whenever practical,

new validation capabilities should remain backward compatible with previously published validation procedures.

---

# Engineering Philosophy

Engineering confidence should be based on evidence.

Evidence should be reproducible.

Validation should remain transparent about its capabilities and its limitations.

Clearly documenting limitations strengthens engineering credibility.

---

# Final Statement

No engineering validation is complete without understanding its scope.

Knowing what a validation process does not evaluate is just as important as understanding what it does evaluate.

The VRP Validation Kit intentionally documents both.