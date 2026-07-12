# Validation Limits

## Purpose

The VRP Validation Kit is designed to validate observable runtime behavior.

It is intentionally separated from the protected VRP Runtime implementation.

This separation is deliberate.

The objective is to allow independent engineering evaluation without exposing protected implementation details.

---

# What This Validation Can Verify

The Validation Kit is intended to verify observable engineering properties, including but not limited to:

- runtime continuity
- session continuity
- transport migration behavior
- deterministic recovery
- replay protection
- evidence integrity
- signed evidence verification
- validation reproducibility
- failure handling
- recovery sequencing
- protocol invariants exposed through the public validation interface

Each published validation result should be reproducible by an independent evaluator following the documented validation procedure.

---

# What This Validation Does Not Verify

The Validation Kit is not intended to expose or disclose:

- protected runtime algorithms
- proprietary implementation details
- internal scheduling logic
- private optimization strategies
- commercial intellectual property
- confidential deployment configurations

Successful validation should never require access to protected implementation.

---

# Trust Boundary

The Validation Kit operates outside the protected runtime boundary.

Validation is performed against observable behavior.

The protected runtime remains isolated.

This separation is intentional.

---

# Engineering Philosophy

Engineering claims should be supported by reproducible evidence.

Observable behavior is more valuable than unverifiable implementation claims.

Validation focuses on:

- reproducibility
- determinism
- evidence
- observable system behavior

rather than unrestricted source disclosure.

---

# Independent Verification

Every organization is encouraged to:

- execute the Validation Kit independently
- review generated evidence
- reproduce published validation procedures
- compare independent results with published reports

Independent verification is considered a fundamental part of the evaluation process.

---

# Pilot Evaluation

Organizations requiring evaluation of the protected runtime itself should participate in the Private Pilot Program.

The Validation Kit is not a replacement for the Pilot.

The Validation Kit is the public engineering validation layer.

The Pilot is the protected runtime evaluation layer.

---

# Design Principle

Do not ask anyone to trust engineering claims.

Provide sufficient evidence so those claims can be independently evaluated.

That principle guides the design of the VRP Validation Kit.