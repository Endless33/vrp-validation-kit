# Attack Catalog

## Purpose

This document describes representative attack scenarios used during public validation.

The objective is not to claim perfect security.

The objective is to demonstrate how the system behaves when observable failures or malicious conditions are introduced.

Every listed scenario should be reproducible using the Validation Kit where applicable.

---

# ATTACK-001

## Name

Replay Attack

### Objective

Attempt to inject previously accepted protocol data.

### Expected Result

Replay is rejected.

Previously accepted state is preserved.

Session continuity remains unaffected.

Evidence is generated.

---

# ATTACK-002

## Name

Duplicate Packet Injection

### Objective

Deliver duplicate protocol frames.

### Expected Result

Duplicate traffic is ignored or safely handled.

Application state remains deterministic.

---

# ATTACK-003

## Name

Packet Reordering

### Objective

Deliver protocol frames in an unexpected order.

### Expected Result

Ordering is restored or invalid ordering is rejected.

Observable state remains deterministic.

---

# ATTACK-004

## Name

Transport Migration

### Objective

Replace the active transport during an active session.

### Expected Result

Session continuity is preserved.

No application restart is required.

Evidence records the migration.

---

# ATTACK-005

## Name

Network Blackout

### Objective

Remove network connectivity for a limited period.

### Expected Result

Recovery begins after connectivity returns.

Observable continuity is preserved when recovery conditions are satisfied.

---

# ATTACK-006

## Name

Path Failure

### Objective

Force the currently active network path to fail.

### Expected Result

A valid replacement path may be selected according to runtime policy.

Migration is recorded in the validation evidence.

---

# ATTACK-007

## Name

Evidence Modification

### Objective

Modify a generated evidence bundle.

### Expected Result

Evidence verification fails.

Integrity violation is detected.

Modified evidence is rejected.

---

# ATTACK-008

## Name

Manifest Tampering

### Objective

Modify manifest metadata after generation.

### Expected Result

Manifest verification fails.

Evidence chain integrity is broken.

Validation reports the failure.

---

# ATTACK-009

## Name

Signature Verification

### Objective

Validate evidence using published verification procedures.

### Expected Result

Original evidence verifies successfully.

Modified evidence fails verification.

---

# ATTACK-010

## Name

Independent Reproduction

### Objective

Execute validation on independent hardware or operating systems.

### Expected Result

Equivalent observable behavior.

Equivalent validation verdict.

Equivalent evidence chain.

---

# Design Principle

The Validation Kit focuses on observable engineering behavior.

It is not intended to expose protected runtime implementation.

Independent evaluators should be able to reproduce the validation process and compare results with published evidence.

Successful validation should depend on reproducibility, not on privileged access to protected source code.