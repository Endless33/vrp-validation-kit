Evidence Index

Purpose

This document provides a single entry point to validation evidence associated with the VRP validation effort.

The objective is to make validation artifacts discoverable, reproducible, and independently reviewable.

---

Validation Philosophy

Validation evidence is preferred over conceptual claims.

Evidence should be:

- Observable
- Reproducible
- Deterministic
- Independently verifiable

---

Public Validation Artifacts

Validation Harness

Repository artifact:

VRP Validation Kit

Expected verdict:

FINAL_VERDICT=VALIDATION_PASSED

---

Integrated Runtime Scenario

Repository artifact:

vrp-runtime-scenario

Expected verdict:

FINAL_VERDICT=CONTINUITY_PRESERVED

---

Closed Core Runner Evidence

Replay Window Scenario

Release:

v0.6.0
Real Replay Window Scenario

Expected verdict:

VERDICT=REPLAY_WINDOW_ENFORCED

Observed behavior:

accepted=1
rejected=9999

---

Authority Rollback Scenario

Release:

v0.7.0
Real Authority Rollback Scenario

Expected verdict:

VERDICT=AUTHORITY_ROLLBACK_REJECTED

Observed behavior:

current_epoch=10
candidate_epoch=5
rollback_accepted=false

---

Session Recovery Scenario

Release:

v0.8.0
Real Session Recovery Scenario

Expected verdict:

VERDICT=SESSION_RECOVERY_PRESERVED

Observed behavior:

session_preserved=true
authority_preserved=true
epoch_preserved=true
history_preserved=true

---

Architecture-Level Validation

Examples of previously validated areas include:

- Replay protection
- Authority validation
- Epoch validation
- Session continuity
- Runtime recovery
- Canonical history preservation

---

Validation Documents

See also:

docs/ARCHITECTURE_OVERVIEW.md
docs/FAILURE_MODEL.md
docs/FAILURE_INVARIANT_MAPPING.md
docs/FAILURE_INJECTION_MODEL.md
docs/VALIDATION_ROADMAP.md

---

Pilot Evaluation Documents

See also:

docs/PILOT_PROGRAM.md
docs/PILOT_OFFERING.md
docs/PILOT_ONBOARDING_FLOW.md
docs/PILOT_FAQ.md
docs/PILOT_SUCCESS_CRITERIA.md
docs/PILOT_EVALUATION_REPORT_TEMPLATE.md

---

Objective

The objective of the evidence index is not to provide conclusions.

The objective is to provide traceable paths from validation scenario to observable runtime behavior.