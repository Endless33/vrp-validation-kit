# VRP External Validation Kit

Public engineering evaluation for observable VRP behavior, invariant preservation, adversarial conditions, and evidence verification.

**VRP — Veil Routing Protocol**

**Observable behavior. Reproducible evidence. Protected implementation.**

---

## Repository

https://github.com/Endless33/vrp-validation-kit

## Stable Release

https://github.com/Endless33/vrp-validation-kit/releases/tag/v1.0.0

## Pilot Application

https://tally.so/r/ZjQLN0

---

# Purpose

The VRP External Validation Kit provides public tools for evaluating declared VRP behavior without publishing the protected runtime implementation.

The repository focuses on externally observable properties:

- continuity-reference preservation;
- transport-independent logical-session behavior;
- replay containment;
- duplicate-commit rejection;
- stale-authority rejection;
- epoch rollback rejection;
- deterministic authority resolution;
- recovery preservation;
- canonical-history protection;
- evidence integrity;
- evidence tamper detection.

The objective is not agreement.

The objective is reproducible evaluation.

---

# Evaluation Boundary

This repository contains public validation models, adversarial scenarios, evidence verifiers, documentation, and a Docker-based black-box evaluation harness.

It does **not** contain the production VRP runtime.

The standalone Go programs model and test declared public invariants.

They do **not** execute or disclose the protected runtime.

The Docker Continuity Evidence Lab evaluates a separately supplied authorized black-box subject image through a public adapter contract.

A successful public verdict establishes only that the declared observable conditions were satisfied during the evaluated scenario.

It does **not** independently prove:

- the internal implementation used;
- formal protocol correctness;
- production readiness;
- resistance to every possible failure;
- host or hardware integrity;
- behavior outside the tested scenario;
- certification by VRP or any third party.

---

# Release Boundary

| Reference | Scope | Intended Use |
|------------|-------|--------------|
| `v1.0.0` | Baseline Go validation harness, runtime-behavior scenario, and attack suite | Stable baseline reproduction |
| `main` | Current validation work, evidence verification, Docker Continuity Evidence Lab, release-closeout records and extended documentation | Current engineering evaluation |

The Docker Continuity Evidence Lab and evidence-verification components were introduced after the `v1.0.0` release.

When reporting results from `main`, always include the exact evaluated commit hash.

---

# Current Status

The current repository state includes:

- public Go validation commands;
- external adversarial model suite;
- evidence-bundle verification;
- evidence tamper rejection;
- Docker Continuity Evidence Lab;
- five public Docker scenarios;
- versioned public invariant contract;
- deterministic evidence verification;
- report export tooling;
- participant and protected-runtime boundaries;
- validation records;
- black-box boundary audit;
- Pilot documentation.

The Docker lab files have passed repository validation including:

- Bash syntax validation;
- YAML validation;
- JSON validation;
- contract-reference validation;
- executable-bit validation;
- relative-link validation;
- public-boundary scanning.

The Docker Continuity Evidence Lab has completed controlled black-box validation runs including:

- Wi-Fi → Mobile migration;
- Blackout Recovery;
- Replay Attempt;
- Stale Authority;
- 200 ms Latency Impairment.

Executed scenarios produce deterministic public evidence and are verified through the public verifier.

Each successful validation applies only to:

- the evaluated repository state;
- the executed scenario;
- the supplied authorized black-box subject;
- the declared invariant contract;
- the recorded execution environment.

It does **not** establish:

- universal production readiness;
- formal protocol verification;
- correctness outside the executed scenario;
- certification by any third party.

---

# Release and Pilot Status

The current public validation boundary has completed release closeout.

Current release documentation:

- Release Closeout
- Black-Box Boundary Audit
- Validation Results
- Validation Fix History
- Pilot Readiness

The public evaluation boundary exposes:

- declared scenarios;
- externally controlled fault injection;
- logical path observations;
- opaque continuity references;
- witness evidence;
- public subject evidence;
- verification reports;
- artifact hashes.

The public evaluation boundary does **not** expose:

- protected runtime source code;
- authority implementation;
- internal runtime state;
- decision algorithms;
- cryptographic secrets;
- private keys;
- bearer material;
- protected packets;
- production credentials.

The public repository evaluates externally observable behavior only.

---

# Requirements

## Standalone Validation

- Git
- Go 1.24+

## Docker Continuity Evidence Lab

- Linux
- Docker Engine
- Docker Compose v2
- Bash
- sha256sum
- Linux bridge networking
- Authorized subject image

The protected subject image is supplied separately.

It is **not** included in this repository.

Android Termux can inspect the repository and execute standalone validation, but the Docker Continuity Evidence Lab requires a Docker-capable Linux host.

---

# Quick Evaluation

Clone the repository:

```bash
git clone https://github.com/Endless33/vrp-validation-kit.git

cd vrp-validation-kit
```

Record the evaluated commit:

```bash
git rev-parse HEAD
```

To reproduce the stable release instead:

```bash
git checkout v1.0.0
```

Continue with one of:

- Standalone Validation Harness
- Runtime Behavior Scenario
- Attack Suite
- Docker Continuity Evidence Lab

- ---

# Standalone Validation

The standalone validation commands execute the public validation model directly.

No protected runtime is required.

Run the complete validation suite:

```bash
go test ./...
```

Run the runtime behavior scenario:

```bash
go run ./cmd/runtime-behavior
```

Run the attack suite:

```bash
go run ./cmd/attack-suite
```

Expected result:

```
FINAL_VERDICT=PASS
```

---

# Docker Continuity Evidence Lab

The Docker Continuity Evidence Lab evaluates an **authorized black-box subject** through an evidence-only public interface.

The lab controls only:

- network topology;
- logical path availability;
- public stimuli;
- witness observations;
- public evidence;
- invariant verification.

The lab never accesses:

- runtime memory;
- authority implementation;
- protocol internals;
- recovery algorithms;
- source code.

---

# Public Scenarios

The repository currently includes five public scenarios.

| Scenario | Purpose |
|-----------|---------|
| wifi-to-mobile | Logical path migration |
| blackout-recovery | Recovery after complete connectivity loss |
| replay-attempt | Replay rejection |
| stale-authority | Authority freshness validation |
| loss50-latency200 | Latency impairment using Toxiproxy |

---

# Latency Impairment Scenario

Scenario:

```
docker/continuity-lab/configs/loss50-latency200.yaml
```

Purpose:

Inject deterministic latency through the public Docker proxy layer while evaluating externally observable continuity behavior.

The scenario injects:

- 200 ms downstream latency
- Wi-Fi logical path
- deterministic timing
- public witness evidence

The protected runtime remains completely opaque.

---

# Running the Docker Lab

Select an authorized subject image.

Example:

```bash
export VRP_LAB_SUBJECT_IMAGE=vrp-subject-local:test
```

Run the scenario:

```bash
./docker/continuity-lab/scripts/run-scenario.sh \
docker/continuity-lab/configs/loss50-latency200.yaml
```

Expected output:

```
RUN_STATE=COMPLETE
VERIFICATION_REQUIRED=true
```

Verify evidence:

```bash
./docker/continuity-lab/scripts/verify-evidence.sh \
docker/continuity-lab/out/<RUN_ID>
```

Expected verification:

```
VERDICT=PASS
```

---

# Observable Events

The latency scenario records public witness events including:

```
infrastructure.ready
subject.ready
network.toxic.added
network.toxic.removed
subject.completed
run.completed
```

No protected runtime information is exposed.

---

# Evidence Produced

Each successful run generates:

```
manifest.json

verification.json

subject/
    subject-events.jsonl
    subject-evidence.json

witness/
    events.jsonl
    environment.json
```

The verifier validates:

- artifact hashes;
- schema compatibility;
- invariant contract;
- witness ordering;
- continuity-reference stability;
- duplicate rejection;
- public evidence completeness.

---

# Example Result

Typical successful verification:

```
VERDICT=PASS

PASS:
✓ Artifact hashes

✓ Evidence complete

✓ Event ordering

✓ Continuity reference stable

✓ No duplicate acceptance

✓ Scenario supported
```

The verification result applies only to the executed scenario and the evaluated black-box subject.

It does not disclose or prove the protected implementation.

---

# Design Philosophy

The public validation boundary is intentionally limited.

The repository demonstrates **observable behavior**, not implementation details.

Every engineering claim is expected to be reproducible through public evidence.

Protected implementation details remain outside the evaluation boundary.

This separation is a deliberate architectural property rather than a limitation.

---

# Reporting Issues

Bug reports are welcome.

Please include:

- evaluated commit hash;
- scenario name;
- operating system;
- Docker version;
- verifier output;
- verification.json;
- manifest.json;
- witness events.

Do not include:

- production credentials;
- protected runtime artifacts;
- proprietary source code.

---

# Contact

Pilot:

jumpingvpn@proton.me

Repository:

https://github.com/Endless33/vrp-validation-kit

---

# Public Evaluation Model

The Docker Continuity Evidence Lab is intentionally deterministic.

Every execution follows the same evaluation pipeline:

```
Scenario
      │
      ▼
Infrastructure
      │
      ▼
Authorized Subject
      │
      ▼
Public Witness
      │
      ▼
Evidence Collection
      │
      ▼
Verification
      │
      ▼
PASS / FAIL / INCOMPLETE
```

No manual interpretation is required.

The verifier evaluates only observable evidence.

---

# Public Boundary

The evaluation boundary intentionally excludes:

- protocol implementation;
- authority algorithms;
- session management logic;
- routing decisions;
- protected state;
- cryptographic material;
- runtime memory.

Only externally observable behavior is evaluated.

---

# What PASS Means

A successful PASS means that the executed black-box subject satisfied every declared public invariant for the executed scenario.

PASS does **not** mean:

- formal verification;
- production certification;
- security certification;
- disclosure of implementation;
- proof of every possible failure mode.

PASS means only that the observable evidence matches the declared public contract.

---

# What FAIL Means

A FAIL verdict indicates that one or more required public invariants were violated.

Examples include:

- missing required evidence;
- duplicate acceptance;
- unexpected continuity reference replacement;
- invalid event ordering;
- required witness events not observed;
- scenario-specific invariant violations.

---

# What INCOMPLETE Means

INCOMPLETE indicates that the evaluation could not reach a valid conclusion.

Examples include:

- infrastructure failure;
- incomplete evidence;
- interrupted execution;
- unsupported scenario;
- verifier interruption.

INCOMPLETE is intentionally different from FAIL.

---

# Deterministic Verification

The verifier performs deterministic validation.

Running the verifier repeatedly against identical evidence should produce identical results.

Example:

```bash
./docker/continuity-lab/scripts/verify-evidence.sh \
docker/continuity-lab/out/<RUN_ID>
```

Repeated execution should generate the same:

- verdict;
- invariant results;
- evidence hashes.

---

# Reproducibility

The public evaluation model is designed for independent verification.

Any evaluator should be able to:

1. Clone the repository.
2. Build the evaluation environment.
3. Execute a published scenario.
4. Collect evidence.
5. Run the verifier.
6. Compare results.

No internal engineering knowledge is required.

---

# Security Model

The public evaluation environment follows a strict separation principle.

Public:

- Docker topology;
- witness events;
- evidence format;
- invariant contracts;
- verification logic.

Protected:

- runtime implementation;
- protocol algorithms;
- authority mechanisms;
- continuity engine;
- recovery implementation.

The evaluation framework never crosses this boundary.

---

# Intended Audience

The repository is intended for:

- protocol engineers;
- systems engineers;
- distributed systems researchers;
- infrastructure architects;
- security engineers;
- technical evaluators.

It is not intended to teach or expose protected implementation details.

---

# Repository Goals

This repository exists to demonstrate:

- reproducible evaluation;
- deterministic verification;
- black-box validation;
- evidence-first engineering;
- public invariant contracts.

The repository is **not** a reference implementation of the protected runtime.

---

# License

Unless stated otherwise, repository contents are provided under the license included with the project.

The evaluation framework is public.

Protected runtime implementation remains private.

---

# Contributing

Contributions improving the public evaluation framework are welcome.

Examples include:

- additional public scenarios;
- verifier improvements;
- documentation;
- reproducibility improvements;
- Docker infrastructure;
- evidence tooling.

Contributions must not introduce:

- proprietary runtime code;
- protected algorithms;
- confidential implementation details;
- production credentials.

---

# Final Notes

The purpose of this repository is simple:

- evaluate observable behavior;
- reproduce published results;
- verify evidence independently;
- preserve implementation confidentiality.

Evidence is public.

Behavior is reproducible.

Implementation remains protected.
