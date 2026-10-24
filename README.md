# VRP External Validation Kit

Public engineering evaluation for observable VRP behavior, invariant preservation, adversarial conditions, transport-path authority, and evidence verification.

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

The VRP External Validation Kit provides public tools and documentation for evaluating declared VRP behavior without publishing the protected runtime implementation.

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
- evidence tamper detection;
- transport-path admission;
- rejected-endpoint state immutability;
- legitimate transport replacement;
- separation of network observation from path authority.

The objective is not agreement.

The objective is reproducible evaluation.

---

# Core Architecture Principle

VRP is built around a simple distinction:

    SESSION != TRANSPORT

A logical session is not defined solely by the network path currently carrying its traffic.

Transport may fail.

Transport may disappear.

Transport may be replaced.

The logical session may survive.

That continuity model introduces a second requirement:

    TRANSPORT OBSERVATION != TRANSPORT AUTHORITY

A network endpoint may be observed without automatically becoming authoritative.

The network can tell the runtime where a packet came from.

The network does not get to decide which endpoint becomes the persistent active path.

---

# Public Transport-Path Invariant

The current public validation work establishes the following transport-path invariant for the validated scenarios:

    REJECTED_PACKET
        => NO_CANONICAL_COMMIT
        => NO_PERSISTENT_PATH_MUTATION
        => NO_TRANSPORT_CHANGE_INCREMENT

In compact form:

    RECEIVE != ADMIT

    OBSERVATION != AUTHORITY

    CANDIDATE_PATH != ACTIVE_PATH

    REJECTION != PARTIAL_COMMIT

A rejected packet must not gain persistent path influence merely because the operating system observed it from a new UDP source endpoint.

At the same time:

    LEGITIMATE_ADMISSION
        => AUTHORIZED_PATH_CHANGE_MAY_OCCUR

The objective is not to prevent transport replacement.

The objective is to prevent unauthorized transport replacement.

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

# Protected Core Disclosure Boundary

Public validation is intentionally separated from protected implementation.

Public material may describe:

- declared invariants;
- observable behavior;
- adversarial scenarios;
- evidence formats;
- validation methodology;
- PASS / FAIL / INCOMPLETE semantics;
- public architectural boundaries;
- reproducible validation outcomes.

Public material does **not** disclose:

- protected runtime source code;
- internal authority algorithms;
- private session-management logic;
- protected recovery algorithms;
- cryptographic secrets;
- private keys;
- bearer material;
- production credentials;
- protected runtime memory;
- proprietary implementation details.

The purpose of public evidence is to make claims testable without making the protected implementation public.

---

# Release Boundary

| Reference | Scope | Intended Use |
|------------|-------|--------------|
| `v1.0.0` | Baseline Go validation harness, runtime-behavior scenario, and attack suite | Stable baseline reproduction |
| `main` | Current validation work, evidence verification, Docker Continuity Evidence Lab, transport-path validation, release-closeout records, and extended documentation | Current engineering evaluation |

The Docker Continuity Evidence Lab, evidence-verification components, and later transport-path authority documentation were introduced after the `v1.0.0` release.

When reporting results from `main`, always include the exact evaluated commit hash.

Where a validation document provides an immutable checkpoint, include both the declared commit and tree identity.

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
- Pilot documentation;
- transport-path admission documentation;
- rejected-endpoint adversarial validation;
- real UDP path-authority validation;
- execution-authority vs transport-authority boundary documentation;
- immutable validation checkpoint records.

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

# Transport-Path Admission Validation

Recent public engineering work extends the validation surface to the transport-path authority boundary.

The central question is:

> Can rejected traffic arriving from a new network endpoint persistently replace the active transport path?

For the validated scenarios, the answer is:

    NO

The validation distinguishes:

    observed endpoint

from:

    authorized endpoint

and:

    candidate path

from:

    persistent active path

The required ordering is:

    RECEIVE
        ↓
    OBSERVE
        ↓
    DECODE
        ↓
    ADMIT
        ↓
    AUTHORIZE
        ↓
    ADOPT

The unsafe ordering is:

    RECEIVE
        ↓
    OBSERVE
        ↓
    MUTATE PERSISTENT PATH
        ↓
    VALIDATE
        ↓
    REJECT

A correct rejection verdict is insufficient if rejected input has already modified persistent state.

The validation therefore checks post-rejection state, not only returned verdicts.

---

# Adversarial Path Validation

The transport-path boundary has been exercised against independent rejection classes including:

    wrong session identity

    stale epoch

    replayed packet

For each tested rejection class, the required postcondition is:

    packet rejected

    canonical mutation not committed

    active path unchanged

    transport change count unchanged

A legitimate admitted replacement path is used as a positive control.

The expected positive result is:

    legitimate candidate observed
        ↓
    packet admitted
        ↓
    path replacement authorized
        ↓
    active path replaced
        ↓
    transport change recorded

This demonstrates that the security boundary does not simply disable migration.

It distinguishes:

    unauthorized path influence

from:

    legitimate path replacement

---

# Real Kernel UDP Validation

The transport-path invariant has also been exercised using real kernel UDP sockets and distinct source endpoints.

The validation topology includes:

1. a legitimate initial transport endpoint;
2. a rejected endpoint using a different UDP source;
3. a legitimate replacement endpoint using another distinct source.

The validated sequence is:

    LEGITIMATE_PATH_ESTABLISHED

    REJECTED_ENDPOINT_OBSERVED_NOT_ADOPTED

    LEGITIMATE_PATH_REPLACEMENT_PRESERVED

    REAL_UDP_PRE_ADMISSION_PATH_IMMUTABILITY=PRESERVED

Conceptually:

    active = legitimate A

        ↓

    rejected B arrives

        ↓

    active = legitimate A

        ↓

    legitimate C arrives

        ↓

    active = legitimate C

The rejected source endpoint is real transport metadata supplied by the operating system.

It is observable.

It does not automatically become authoritative.

---

# Transport Continuity vs Execution Authority

VRP intentionally distinguishes two architectural questions:

    MAY THIS OPERATION EXECUTE?

and:

    MAY THIS TRANSPORT CARRY THE SESSION?

These correspond conceptually to:

    canonical execution authority

and:

    transport continuity authority

They are related but must not be permanently treated as identical without an explicit protocol contract.

For example:

    canonical mutation already committed
        ↓
    duplicate execution suppressed

answers whether canonical state should execute again.

It does not automatically answer every future transport-reattachment question.

This distinction is relevant to scenarios such as:

- NAT rebinding;
- transport recovery;
- legitimate endpoint replacement;
- path migration;
- reattachment without duplicate canonical execution.

The public documentation intentionally does **not** claim that duplicate mutation always permits transport reattachment.

It also does **not** claim that duplicate mutation always forbids transport reattachment.

That authority boundary requires independent evidence.

The validated baseline remains:

    rejected traffic
        => no persistent path mutation

while:

    legitimate admitted migration
        => path replacement preserved

---

# Public Validation Documents

The transport-path authority work is documented in:

    docs/transport-path-admission-invariant.md

    docs/rejected-endpoint-adversarial-validation.md

    docs/real-udp-path-authority-validation.md

    docs/canonical-ingress-before-path-adoption.md

    docs/transport-continuity-vs-execution-authority.md

    docs/validation-checkpoint-4cfc77ab.md

Together these documents describe:

- the public transport-path invariant;
- the adversarial threat model;
- unsafe vs hardened ordering;
- rejected-endpoint state immutability;
- positive migration controls;
- real UDP validation;
- execution-authority vs transport-authority separation;
- checkpoint identity and qualification scope.

They intentionally describe public guarantees rather than protected implementation mechanics.

---

# Qualified Transport-Path Checkpoint

The documented transport-path validation is anchored to:

    Commit:
    4cfc77abf81a700b379ead63f0fa14814cdbb419

    Tree:
    9c3d95074bcf6d727ea170f7d85910f968dd4e9e

The source checkpoint was verified with matching local and remote commit identity:

    LOCAL_REMOTE_IDENTITY=PASS

The qualification included:

    targeted invariant validation

    repeated target execution

    race-detector target execution

    canonical wire regression validation

    full repository validation

    full repository race validation

    real UDP end-to-end validation

Qualified result:

    REJECTED_PATH_MUTATION=PREVENTED

    WRONG_SESSION_PATH_INFLUENCE=REJECTED

    STALE_EPOCH_PATH_INFLUENCE=REJECTED

    REPLAY_PATH_INFLUENCE=REJECTED

    LEGITIMATE_PATH_REPLACEMENT=PRESERVED

    REAL_KERNEL_UDP=VALIDATED

    REPEATABILITY=PASS

    RACE_QUALIFICATION=PASS

    CANONICAL_WIRE_CONTROL=PASS

    FULL_REPOSITORY_VALIDATION=PASS

The checkpoint establishes only the claims documented for the validated scenarios.

It does not establish universal protocol correctness.

---

# Release and Pilot Status

The current public validation boundary has completed release closeout.

Current release documentation includes:

- Release Closeout;
- Black-Box Boundary Audit;
- Validation Results;
- Validation Fix History;
- Pilot Readiness;
- Transport Path Admission Invariant;
- Rejected Endpoint Adversarial Validation;
- Real UDP Path Authority Validation;
- Canonical Ingress Before Path Adoption;
- Transport Continuity vs Execution Authority;
- Validation Checkpoint `4cfc77ab`.

The public evaluation boundary exposes:

- declared scenarios;
- externally controlled fault injection;
- logical path observations;
- opaque continuity references;
- witness evidence;
- public subject evidence;
- verification reports;
- artifact hashes;
- declared architecture invariants;
- reproducible validation outcomes.

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
git rev-parse HEAD^{tree}
```

To reproduce the stable release instead:

```bash
git checkout v1.0.0
```

Continue with one of:

- Standalone Validation Harness;
- Runtime Behavior Scenario;
- Attack Suite;
- Docker Continuity Evidence Lab;
- Public validation documents.

---

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

```text
FINAL_VERDICT=PASS
```

---

## Manual Cable Pull Test

Run the Wi-Fi to Mobile continuity scenario:

```bash
export VRP_LAB_SUBJECT_IMAGE=vrp-subject-local:test

./docker/continuity-lab/scripts/run-scenario.sh \
docker/continuity-lab/configs/wifi-to-mobile.yaml
```

When the scenario reaches the migration phase:

- disconnect the primary network interface;
- or disable the active adapter;
- or physically unplug the Ethernet cable.

The evaluation harness will observe the externally visible continuity behavior.

After the run completes:

```bash
./docker/continuity-lab/scripts/verify-evidence.sh \
docker/continuity-lab/out/<RUN_ID>
```

Expected result:

```text
VERDICT=PASS
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

The repository currently includes five public Docker scenarios.

| Scenario | Purpose |
|-----------|---------|
| `wifi-to-mobile` | Logical path migration |
| `blackout-recovery` | Recovery after complete connectivity loss |
| `replay-attempt` | Replay rejection |
| `stale-authority` | Authority freshness validation |
| `loss50-latency200` | Latency impairment using Toxiproxy |

---

# Latency Impairment Scenario

Scenario:

    docker/continuity-lab/configs/loss50-latency200.yaml

Purpose:

Inject deterministic latency through the public Docker proxy layer while evaluating externally observable continuity behavior.

The scenario injects:

- 200 ms downstream latency;
- Wi-Fi logical path;
- deterministic timing;
- public witness evidence.

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

```text
RUN_STATE=COMPLETE
VERIFICATION_REQUIRED=true
```

Verify evidence:

```bash
./docker/continuity-lab/scripts/verify-evidence.sh \
docker/continuity-lab/out/<RUN_ID>
```

Expected verification:

```text
VERDICT=PASS
```

---

# Observable Events

The latency scenario records public witness events including:

    infrastructure.ready
    subject.ready
    network.toxic.added
    network.toxic.removed
    subject.completed
    run.completed

No protected runtime information is exposed.

---

# Evidence Produced

Each successful run generates:

    manifest.json

    verification.json

    subject/
        subject-events.jsonl
        subject-evidence.json

    witness/
        events.jsonl
        environment.json

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

    VERDICT=PASS

    PASS:
    ✓ Artifact hashes
    ✓ Evidence complete
    ✓ Event ordering
    ✓ Continuity reference stable
    ✓ No duplicate acceptance
    ✓ Scenario supported

The verification result applies only to the executed scenario and the evaluated black-box subject.

It does not disclose or prove the protected implementation.

---

# Design Philosophy

The public validation boundary is intentionally limited.

The repository demonstrates **observable behavior**, not implementation details.

Every engineering claim is expected to be reproducible through public evidence.

Protected implementation details remain outside the evaluation boundary.

This separation is a deliberate architectural property rather than a limitation.

The engineering discipline can be summarized as:

    CLAIM
      ↓
    DECLARED INVARIANT
      ↓
    ADVERSARIAL SCENARIO
      ↓
    OBSERVABLE EVIDENCE
      ↓
    DETERMINISTIC VERIFICATION
      ↓
    PASS / FAIL / INCOMPLETE

No claim should exceed its evidence.

---

# Evidence-First Engineering

VRP public validation follows several rules:

    verdict alone is not enough

    postcondition matters

    rejected input must not leave unauthorized persistent state

    positive controls must preserve legitimate behavior

    race-sensitive invariants require race validation

    public claims must identify their evaluated source state

This means a test should not merely demonstrate:

    REJECTED

when the security claim actually requires:

    REJECTED
        +
    STATE PRESERVED

Likewise, a security hardening should not be accepted if it achieves rejection by destroying legitimate continuity.

Both negative and positive behavior matter.

---

# Public Evaluation Model

The Docker Continuity Evidence Lab is intentionally deterministic.

Every execution follows the same evaluation pipeline:

    Scenario
          |
          v
    Infrastructure
          |
          v
    Authorized Subject
          |
          v
    Public Witness
          |
          v
    Evidence Collection
          |
          v
    Verification
          |
          v
    PASS / FAIL / INCOMPLETE

No manual interpretation is required for the declared verifier contract.

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

A successful PASS means that the executed black-box subject satisfied every declared public invariant evaluated by that scenario and verifier.

PASS does **not** mean:

- formal verification;
- production certification;
- security certification;
- disclosure of implementation;
- proof of every possible failure mode;
- proof of behavior outside the evaluated boundary.

PASS means only that the observable evidence matches the declared public contract for that evaluation.

---

# What FAIL Means

A FAIL verdict indicates that one or more required public invariants were violated.

Examples include:

- missing required evidence;
- duplicate acceptance;
- unexpected continuity-reference replacement;
- invalid event ordering;
- required witness events not observed;
- scenario-specific invariant violations;
- unauthorized persistent state mutation where immutability is required.

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
2. Record the exact evaluated commit.
3. Build the evaluation environment.
4. Execute a published scenario.
5. Collect evidence.
6. Run the verifier.
7. Compare results.

No internal engineering knowledge is required.

For checkpoint-specific claims, evaluators should use the commit and tree recorded in the corresponding validation document.

---

# Security Model

The public evaluation environment follows a strict separation principle.

Public:

- Docker topology;
- witness events;
- evidence format;
- invariant contracts;
- verification logic;
- declared security properties;
- validation methodology;
- checkpoint identities.

Protected:

- runtime implementation;
- protocol algorithms;
- authority mechanisms;
- continuity engine;
- recovery implementation;
- private cryptographic material.

The evaluation framework never crosses this boundary.

---

# Authority Model — Public View

The public architecture intentionally avoids collapsing distinct concepts into a single authority decision.

At a high level:

    SESSION IDENTITY
          |
          v
    SESSION AUTHORITY
       /        \
      v          v
    EXECUTION   TRANSPORT
    AUTHORITY   AUTHORITY

This is a conceptual public boundary, not disclosure of protected implementation.

The distinction exists to make questions independently testable:

    Should canonical state change?

and:

    Should the transport path change?

A result in one authority domain must not silently become proof of a result in another unless the protocol contract explicitly defines that relationship.

---

# Intended Audience

The repository is intended for:

- protocol engineers;
- systems engineers;
- distributed systems researchers;
- infrastructure architects;
- security engineers;
- red teams;
- technical evaluators;
- pilot engineering teams.

It is not intended to teach or expose protected implementation details.

---

# Repository Goals

This repository exists to demonstrate:

- reproducible evaluation;
- deterministic verification;
- black-box validation;
- evidence-first engineering;
- public invariant contracts;
- adversarial validation;
- transport-independent continuity;
- controlled path replacement;
- explicit security boundaries.

The repository is **not** a reference implementation of the protected runtime.

---

# Reporting Issues

Bug reports and reproducible counterexamples are welcome.

Please include:

- evaluated commit hash;
- scenario name;
- operating system;
- Docker version where applicable;
- verifier output;
- `verification.json`;
- `manifest.json`;
- relevant witness events;
- minimal reproduction steps.

For transport-path claims, clearly identify:

- the expected invariant;
- the observed endpoint behavior;
- the persistent-state result;
- whether the candidate was admitted or rejected.

Do not include:

- production credentials;
- protected runtime artifacts;
- proprietary source code;
- cryptographic secrets.

A reproducible counterexample is more useful than an unsupported assertion.

---

# Contributing

Contributions improving the public evaluation framework are welcome.

Examples include:

- additional public scenarios;
- verifier improvements;
- documentation;
- reproducibility improvements;
- Docker infrastructure;
- evidence tooling;
- adversarial test cases;
- independent validation methodology.

Contributions must not introduce:

- proprietary runtime code;
- protected algorithms;
- confidential implementation details;
- production credentials.

---

# Contact

Pilot:

jumpingvpn@proton.me

Repository:

https://github.com/Endless33/vrp-validation-kit

---

# License

Unless stated otherwise, repository contents are provided under the license included with the project.

The evaluation framework is public.

Protected runtime implementation remains private.

---

# Final Notes

The purpose of this repository is simple:

    evaluate observable behavior

    reproduce published results

    verify evidence independently

    preserve implementation confidentiality

The public validation model is built around several boundaries:

    SESSION != TRANSPORT

    RECEIVE != ADMIT

    OBSERVATION != AUTHORITY

    CANDIDATE_PATH != ACTIVE_PATH

    REJECTION != PARTIAL COMMIT

    EXECUTION AUTHORITY != TRANSPORT AUTHORITY

The validated transport-path work adds a concrete consequence:

    rejected traffic may be observed

but:

    rejected traffic must not become persistent path authority

while:

    legitimate authorized transport replacement remains possible

Evidence is public.

Behavior is reproducible.

Claims are bounded by validation.

Implementation remains protected.