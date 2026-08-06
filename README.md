VRP External Validation Kit

Public engineering evaluation for observable VRP behavior, invariant preservation, adversarial conditions, and evidence verification.

VRP — Veil Routing Protocol

Observable behavior. Reproducible evidence. Protected implementation.

---

Repository

https://github.com/Endless33/vrp-validation-kit

Stable Release

https://github.com/Endless33/vrp-validation-kit/releases/tag/v1.0.0

Pilot Application

https://tally.so/r/ZjQLN0

---

Purpose

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

Evaluation Boundary

This repository contains public validation models, adversarial scenarios, evidence verifiers, documentation, and a Docker-based black-box evaluation harness.

It does not contain the production VRP runtime.

The standalone Go programs model and test declared public invariants. They do not execute or disclose the protected runtime.

The Docker Continuity Evidence Lab evaluates a separately supplied authorized black-box subject image through a public adapter contract.

A successful public verdict establishes only that the declared observable conditions were satisfied during the evaluated scenario.

It does not independently prove:

- the internal implementation used;
- formal protocol correctness;
- production readiness;
- resistance to every possible failure;
- host or hardware integrity;
- behavior outside the tested scenario;
- certification by VRP or any third party.

---

Release Boundary

Reference| Scope| Intended Use
"v1.0.0"| Baseline Go validation harness, runtime-behavior scenario, and attack suite| Stable baseline reproduction
"main"| Current validation work, evidence verification, extended documentation, and Docker Continuity Evidence Lab| Current engineering evaluation

The Docker Continuity Evidence Lab and newer evidence-verification components were added after the "v1.0.0" release.

Use the exact commit hash when reporting results from "main".

---

Current Status

The current repository state includes:

- public Go validation commands;
- an external adversarial model suite;
- evidence-bundle verification;
- evidence tamper rejection;
- four Docker continuity scenarios;
- a versioned public invariant contract;
- deterministic Docker evidence verification;
- report export tooling;
- participant and protected-runtime boundaries.

The Docker lab files have passed static repository checks, including:

- Bash syntax validation;
- YAML and JSON parsing;
- contract-reference validation;
- executable-mode validation;
- relative-link validation;
- public-boundary scanning.

A completed Docker runtime verdict is not claimed by this README.

Docker execution with an authorized black-box subject image remains a separate controlled validation step.

---

Requirements

Standalone Validation

- Git;
- Go 1.24 or later.

Docker Continuity Evidence Lab

- Linux Docker host;
- Docker Engine;
- Docker Compose v2;
- Bash;
- "sha256sum";
- Linux bridge-network support;
- an authorized black-box subject image.

The protected subject image is supplied separately through an approved delivery channel.

It is not included in this repository.

Android Termux can be used for repository inspection and static validation, but the Docker lab requires a Docker-capable Linux host.

---

Quick Evaluation

Clone the current repository:

git clone https://github.com/Endless33/vrp-validation-kit.git
cd vrp-validation-kit

Record the evaluated commit:

git rev-parse HEAD

To reproduce the stable baseline instead:

git checkout v1.0.0

---

Validation Harness

Execute:

go run ./cmd/vrp-test

Expected final result:

FINAL_VERDICT=VALIDATION_PASSED

This command evaluates the baseline public validation model.

---

Runtime-Behavior Scenario

Execute:

go run ./cmd/vrp-runtime-scenario

Expected final result:

FINAL_VERDICT=CONTINUITY_PRESERVED

This is a public runtime-behavior scenario.

It is not the protected production runtime.

---

External Adversarial Model Suite

Execute:

go run ./cmd/attack-suite

Expected final result:

FINAL_VERDICT=ATTACK_SUITE_PASSED

The suite attempts to violate declared invariants in the standalone public model.

It is not a penetration test against the protected runtime, a production deployment, or an external network.

Current Scenarios

- Replay Storm
- Duplicate Commit
- Authority Rollback
- Epoch Rollback
- Authority Race
- Transport Migration Storm
- Runtime Recovery
- Canonical History Rewrite

Expected Verdicts

- "REPLAY_WINDOW_ENFORCED"
- "DUPLICATE_COMMIT_REJECTED"
- "AUTHORITY_ROLLBACK_REJECTED"
- "STALE_EPOCH_REJECTED"
- "AUTHORITY_RACE_RESOLVED"
- "TRANSPORT_MIGRATION_PRESERVED"
- "SESSION_RECOVERY_PRESERVED"
- "CANONICAL_HISTORY_REWRITE_REJECTED"

---

Evidence Verification

Evidence verification is available on the current "main" branch.

Execute:

go run ./cmd/evidence-verify \
  --file evidence/sample/core-evidence.json

Expected final result:

FINAL_VERDICT=EVIDENCE_VERIFIED

The verifier checks the public evidence structure and recomputes the declared evidence hash.

---

Tamper Rejection

Execute:

go run ./cmd/evidence-verify \
  --file evidence/sample/tampered-evidence.json

Expected final result:

FINAL_VERDICT=EVIDENCE_VERIFY_FAILED

A non-zero process exit is expected for the tampered sample.

Tampered evidence must not be converted into a successful result.

---

Docker Continuity Evidence Lab

The Docker Continuity Evidence Lab is located at:

docker/continuity-lab/

It provides a controlled black-box environment with:

- two isolated logical data paths;
- a controlled origin;
- a harness-controlled fault engine;
- independent witness-event recording;
- subject-only evidence output;
- a versioned invariant contract;
- deterministic verification;
- report export.

Docker creates the controlled environment.

Docker does not implement VRP and does not decide whether continuity was preserved.

Available Scenarios

docker/continuity-lab/configs/wifi-to-mobile.yaml
docker/continuity-lab/configs/blackout-recovery.yaml
docker/continuity-lab/configs/stale-authority.yaml
docker/continuity-lab/configs/replay-attempt.yaml

The scenarios evaluate:

- primary-to-alternate path transition;
- bounded total-path blackout and recovery;
- stale-authority rejection;
- replay rejection.

The logical names "wifi" and "mobile" are controlled evaluation labels.

They do not emulate complete Wi-Fi radio, cellular handover, modem, carrier, or mobile-core behavior.

Black-Box Subject Boundary

The subject must be supplied as an authorized container image.

The default public adapter entrypoint is:

/vrp-lab-adapter

The adapter supports:

/vrp-lab-adapter run
/vrp-lab-adapter health
/vrp-lab-adapter stimulus --kind <kind> --event-id <event-id>

The adapter must export only public evidence.

It must not export:

- protected runtime source code;
- private keys;
- bearer tokens;
- protected packets;
- internal memory addresses;
- proprietary state;
- private decision parameters;
- internal stack traces.

Running a Scenario

Change to the lab directory:

cd docker/continuity-lab

Set the authorized subject image:

export VRP_LAB_SUBJECT_IMAGE='registry.example/authorized-subject@sha256:<digest>'

Set the subject-output ownership identity:

export VRP_LAB_SUBJECT_UID="$(id -u)"
export VRP_LAB_SUBJECT_GID="$(id -g)"

Run the first scenario:

./scripts/run-scenario.sh configs/wifi-to-mobile.yaml

The runner prints the generated run identifier and exact output directory.

Verifying Docker Evidence

After the scenario completes:

./scripts/verify-evidence.sh out/<run-id>

Verification checks include:

- required artifact presence;
- schema compatibility;
- run-identifier consistency;
- JSON and JSONL validity;
- monotonic event sequencing;
- unique public event identifiers;
- scenario-to-witness consistency;
- subject-to-witness consistency;
- public invariant evaluation;
- artifact hashes;
- fail-closed handling of incomplete evidence.

Exporting a Report

After verification:

./scripts/export-report.sh out/<run-id>

The exported package contains:

- scenario snapshot;
- invariant-contract snapshot;
- witness events;
- subject evidence;
- environment metadata;
- verification result;
- artifact hashes;
- human-readable report.

Export does not add protected runtime material.

Docker Verdicts

The Docker lab uses three verdict classes:

- "PASS" — all required public observations were present and consistent;
- "FAIL" — one or more observations contradicted the public contract;
- "INCOMPLETE" — the evidence was insufficient for a valid decision.

Missing evidence is never inferred.

A subject-generated success statement cannot override contradictory witness evidence.

Run Output

Each run receives an isolated directory:

docker/continuity-lab/out/<run-id>/

Generated run output must remain untracked unless a reviewed and explicitly approved evidence package is selected for publication.

Do not commit private registry information, protected runtime material, credentials, participant-confidential data, or unreviewed evidence.

Formal Evaluation

Formal evaluation should use immutable digest-qualified references for:

- the subject image;
- the origin image;
- the fault-engine image;
- the relay image;
- the controller image;
- parser images.

Retain image-delivery and authorization records outside the public repository.

See the complete lab documentation:

- "Docker Continuity Lab README" (docker/continuity-lab/README.md)
- "Docker Evidence Lab Architecture" (docs/evaluation/VRP_DOCKER_EVIDENCE_LAB.md)
- "Acceptance Criteria" (docs/evaluation/ACCEPTANCE_CRITERIA.md)
- "Participant Boundary" (docs/evaluation/PARTICIPANT_BOUNDARY.md)
- "Shadow Validation Sprint" (docs/evaluation/SHADOW_VALIDATION_SPRINT.md)

---

Validation Coverage

Current public validation coverage includes:

- replay containment;
- duplicate-commit rejection;
- authority rollback rejection;
- epoch rollback rejection;
- authority-race resolution;
- runtime-recovery preservation;
- transport-migration preservation;
- canonical-history protection;
- evidence-bundle verification;
- evidence tamper detection;
- scenario-bound witness evidence;
- fail-closed incomplete-evidence handling;
- black-box Docker evaluation contracts.

Coverage describes what the public tools are designed to evaluate.

It must not be interpreted as proof of properties that were not executed and recorded.

---

Tested Environments

The standalone Go validation commands have been reproduced on:

- Windows 11;
- Oracle Linux;
- Android Termux.

The same declared final verdicts were observed for those standalone commands across the listed environments.

This statement does not claim that the Docker Continuity Evidence Lab has been executed on Android Termux.

Docker results must identify their own host, Docker version, Compose version, image identities, scenario snapshot, contract digest, and commit hash.

---

External Review Workflow

Recommended baseline workflow:

1. Clone the repository.
2. Record the commit hash or check out "v1.0.0".
3. Read this README.
4. Read the validation limits and security boundary.
5. Execute the public validation harness.
6. Execute the runtime-behavior scenario.
7. Execute the adversarial model suite.
8. Execute evidence verification when using "main".
9. Execute tamper rejection when using "main".
10. Review the emitted verdicts.
11. Review the source and documentation.
12. Modify one assumption at a time.
13. Preserve the diff.
14. Report the exact observed result.

For Docker evaluation:

1. Use a Docker-capable Linux host.
2. Record the host and Docker environment.
3. Use an authorized subject-image digest.
4. Run one declared scenario.
5. preserve the complete run directory;
6. verify the evidence;
7. export the report;
8. retain all hashes and immutable identities;
9. report any divergence without rewriting the original artifacts.

---

Reproducibility Rules

When reporting a result, include:

- repository commit hash or release tag;
- exact command;
- complete final verdict;
- operating system and architecture;
- Go version when applicable;
- Docker and Compose versions when applicable;
- scenario identifier;
- subject-image digest when applicable;
- relevant environment configuration;
- local source diff;
- expected behavior;
- actual behavior.

Do not combine artifacts from different runs.

Do not reuse run identifiers.

Do not modify evidence and present it as original output.

Do not omit a failing exit status.

---

Reporting Issues

Use GitHub Issues for reproducible public findings:

https://github.com/Endless33/vrp-validation-kit/issues

If you modify the repository, include the diff.

If an unmodified command fails, provide:

- exact command;
- complete output;
- environment;
- commit hash or release tag;
- failure case attempted;
- expected verdict;
- actual verdict.

Before publishing evidence, remove credentials, private registry references, participant-confidential data, and unrelated host information.

Independent criticism is more valuable than agreement.

---

What Is Included

- public validation harness;
- public runtime-behavior scenario;
- external adversarial model suite;
- evidence verifier;
- tampered evidence sample;
- Docker continuity harness;
- four controlled Docker scenarios;
- public invariant contract;
- witness and subject evidence contracts;
- deterministic verification scripts;
- report export tooling;
- validation and failure-model documentation;
- participant-boundary documentation;
- pilot documentation;
- evaluation artifacts.

---

What Is Not Included

This repository does not contain:

- production VRP runtime;
- protected runtime source code;
- proprietary authority logic;
- internal decision mathematics;
- private state representation;
- production cryptographic material;
- customer-specific deployments;
- participant credentials;
- authorized subject images;
- private registry credentials;
- protected implementation mechanisms.

The repository explains how declared behavior can be evaluated.

It does not disclose how the protected runtime implements that behavior.

See:

- "Validation Limits" (docs/VALIDATION_LIMITS.md)
- "Known Limitations" (docs/KNOWN_LIMITATIONS.md)
- "Security Model" (docs/SECURITY_MODEL.md)
- "What Is Not Included" (docs/WHAT_IS_NOT_INCLUDED.md)

---

Documentation

Recommended entry points:

- "Public Pilot Deployment Guide" (docs/PUBLIC_PILOT_DEPLOYMENT_GUIDE.md)
- "External Validation Guide" (docs/EXTERNAL_VALIDATION_GUIDE.md)
- "Validation Model" (docs/VALIDATION_MODEL.md)
- "Evidence Specification" (docs/EVIDENCE_SPECIFICATION.md)
- "Failure Model" (docs/FAILURE_MODEL.md)
- "Failure-to-Invariant Mapping" (docs/FAILURE_INVARIANT_MAPPING.md)
- "Reproducibility Guide" (docs/REPRODUCIBILITY_GUIDE.md)
- "Architecture Decisions" (docs/ARCHITECTURE_DECISIONS.md)
- "Project Principles" (docs/PROJECT_PRINCIPLES.md)
- "Project Lineage" (docs/PROJECT_LINEAGE.md)

---

Pilot

The public validation kit is an evaluation boundary, not a transfer of the protected runtime.

Pilot participation requires separate review, authorization, and agreement.

Application:

https://tally.so/r/ZjQLN0

Public pilot documentation:

- "Pilot Program" (docs/pilot/PILOT_PROGRAM.md)
- "Pilot Boundary Overview" (docs/pilot/PILOT_BOUNDARY_OVERVIEW.md)
- "Integration Path" (docs/pilot/INTEGRATION_PATH.md)

---

Challenge the Model

This repository is not intended for passive observation.

Run it.

Inspect it.

Challenge it.

If you believe a validation path is incorrect, provide:

- environment;
- exact command;
- result observed;
- failure case attempted;
- expected behavior;
- actual behavior;
- repository commit;
- source diff, if modified.

Evidence-backed criticism is more valuable than agreement.

---

License

Use of this repository is governed by:

"EVALUATION_LICENSE.md" (EVALUATION_LICENSE.md)

Review the license before reuse, redistribution, modification, or commercial evaluation.

---

Contact

Vitalijus Riabovas
Creator of the Veil Routing Protocol

Email:

jumpingvpn@proton.me
