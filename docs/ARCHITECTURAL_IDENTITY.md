# What Makes VRP Different

## Purpose

This document records the architectural identity and historical origin of VRP.

It exists to explain what VRP is, what problems it was created to solve, and how it differs from conventional networking systems.

---

## Origin

VRP was conceived by Vitalijus Riabovas in 2025 as an independent architectural research project.

The initial objective was not to build another VPN.

The objective was to explore continuity-first networking as a new systems primitive.

---

## Core Architectural Principles

VRP is built around several architectural principles:

- session identity independent of transport;
- continuity before connectivity;
- deterministic recovery;
- authority lineage;
- black-box validation;
- reproducible engineering evidence;
- protected runtime implementation.

These principles have guided the project since its earliest prototypes.

---

## Public and Protected Components

The public repositories describe architecture, interfaces, validation methodology, and engineering evidence.

Protected runtime implementation remains private.

---

## Independent Evaluation

Engineers are encouraged to evaluate VRP through:

- reproducible validation;
- observable runtime behavior;
- engineering evidence;
- documented architectural guarantees.

Engineering claims should be validated through testing rather than marketing.

---

## About Similar Ideas

Networking research evolves continuously, and different teams may independently investigate similar problems.

The existence of similar terminology or isolated concepts should not be interpreted as equivalence.

VRP should be evaluated as a complete architecture, including its continuity model, validation methodology, runtime boundaries, and engineering evidence.

---

## Long-Term Commitment

VRP is intended as a long-term engineering project.

The architecture will continue to evolve while preserving its core design principles.

Engineering first.

Evidence before claims.