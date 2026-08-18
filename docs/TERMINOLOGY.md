# Terminology

## Purpose

This document defines the terminology used throughout the VRP Validation Kit documentation.

Consistent terminology improves engineering communication and reduces ambiguity during independent evaluation.

---

# Architecture

The overall engineering design of the system.

Architecture describes observable system behavior and component relationships rather than implementation details.

---

# Runtime

The executing software responsible for processing protocol behavior during operation.

The runtime is evaluated through observable behavior.

Its protected implementation is outside the public validation boundary.

---

# Protected Runtime

The proprietary implementation evaluated through the Private Pilot Program.

Protected Runtime is not included in the public Validation Kit.

---

# Validation

The engineering process of independently executing documented procedures and evaluating observable results.

Validation should be reproducible.

---

# Validation Kit

The public engineering toolkit used to reproduce published validation procedures.

It provides an observable validation environment.

---

# Evidence

Artifacts generated during validation.

Examples include:

- reports

- manifests

- hashes

- signatures

- validation summaries

Evidence supports independent engineering review.

---

# Evidence Bundle

A structured collection of validation artifacts generated during a validation run.

Bundles are intended for long-term engineering review.

---

# Manifest

A machine-readable description of evidence contents.

The manifest allows integrity verification of generated artifacts.

---

# Continuity

The ability of a session to preserve observable operation despite transport changes or recoverable failures.

Continuity is evaluated through externally observable behavior.

---

# Transport

A communication path capable of carrying protocol traffic.

Multiple transport technologies may exist without changing observable session identity.

---

# Migration

The controlled transition of runtime communication from one transport to another while preserving observable continuity.

---

# Recovery

The process of restoring valid runtime operation following a recoverable failure.

Recovery behavior should remain deterministic.

---

# Determinism

The property that equivalent inputs produce equivalent observable engineering outcomes.

Deterministic behavior improves reproducibility.

---

# Pilot

A controlled engineering evaluation of the protected runtime.

The Pilot is intended for technical assessment rather than implementation disclosure.

---

# Observable Behavior

Behavior that can be measured, validated, reproduced, and independently reviewed without access to protected implementation.

---

# Engineering Evidence

Observable artifacts generated through validation procedures that support technical conclusions.

---

# Engineering Principle

Engineering discussions should use consistent terminology.

Consistent terminology improves reproducibility, technical communication, and independent evaluation.

---

# Final Statement

Definitions establish a common engineering language.

A common engineering language improves validation quality and reduces misunderstanding.