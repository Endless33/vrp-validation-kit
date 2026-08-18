# VRP Public Evaluation Capsule

## Purpose

The VRP Public Evaluation Capsule provides a single public entry point for evaluating observable VRP continuity properties without exposing the protected VRP runtime implementation.

The capsule follows one principle:

Claims should be evaluated through reproducible behavior and evidence, not through access to protected protocol internals.

The public evaluator does not contain the private VRP runtime.

It exercises the public validation models, evidence verifier, adversarial tests, and integrated continuity scenario available in this repository.

## Current Capsule Version

vrp-evaluate 0.2.0

## Build

Build the evaluator:

    go build -trimpath -o bin/vrp-evaluate ./cmd/vrp-evaluate

Check the version:

    ./bin/vrp-evaluate version

Inspect the environment:

    ./bin/vrp-evaluate doctor

Verify public sample evidence:

    ./bin/vrp-evaluate verify-sample

Run the unified evaluation:

    ./bin/vrp-evaluate run

## Unified Evaluation

The run command provides a single entry point for the public evaluation capsule.

Current stages:

1. Environment doctor
2. Independent sample evidence verification
3. Standalone invariant validation model
4. External adversarial attack model
5. Integrated runtime continuity scenario
6. Docker capability detection
7. tc / netem capability detection

The evaluator produces a machine-readable summary containing:

    CAPSULE_VERSION=
    RUN_ID=
    PASSED=
    FAILED=
    SKIPPED=
    FINAL_RC=
    FINAL_VERDICT=

## PASS, FAIL, and SKIPPED

The capsule deliberately distinguishes between PASS, FAIL, and SKIPPED.

PASS means a capability was available and its evaluation completed successfully.

FAIL means a required evaluation executed and failed.

A failed evaluation produces:

    FINAL_RC=1
    FINAL_VERDICT=PUBLIC_EVALUATION_FAILED

SKIPPED means a host-dependent capability was unavailable and therefore was not evaluated.

For example, a restricted Android / Termux environment may not provide Docker or tc / netem.

Those capabilities are reported as:

    STATUS=SKIPPED
    note=SKIPPED_IS_NOT_PASS

A skipped capability must never be interpreted as successfully tested.

When all executable public stages pass but optional host capabilities are unavailable, the evaluator reports:

    FINAL_RC=0
    FINAL_VERDICT=PUBLIC_EVALUATION_PASSED_WITH_SKIPPED_CAPABILITIES
    interpretation=skipped_capabilities_are_not_claimed_as_passed

This distinction is intentional.

## Observable Invariants

The public validation models exercise observable properties including:

- duplicate mutation rejection;
- stale authority rejection;
- stale epoch rejection;
- transport migration with stable logical session identity;
- authority migration;
- replay-window enforcement;
- authority rollback rejection;
- commit replay rejection;
- session recovery;
- canonical history consistency.

These tests describe externally evaluable behavior.

They do not disclose the protected runtime mechanism used by VRP.

## Adversarial Evaluation

The public attack model attempts to violate observable invariants through scenarios including:

- replay storm;
- duplicate commit;
- authority rollback;
- epoch rollback;
- authority race;
- transport migration storm;
- runtime recovery;
- canonical history rewrite.

A successful attack-suite result means the public model rejected the tested invariant violations.

It does not constitute a claim that every possible attack against every future VRP deployment has been tested.

## Integrated Continuity Scenario

The integrated runtime scenario evaluates:

    session establishment
            |
    canonical mutation
            |
    transport migration
            |
    authority transfer
            |
    replay attempt
            |
    runtime recovery
            |
    canonical history verification

The expected observable property is continuity of logical session identity and canonical state across those transitions.

## Independent Evidence Verification

The capsule includes a public evidence sample:

    evidence/sample/core-evidence.json

Run:

    ./bin/vrp-evaluate verify-sample

Successful verification produces:

    VERDICT=EVIDENCE_BUNDLE_VERIFIED
    CAPSULE_VERIFICATION=PASS
    FINAL_VERDICT=EVIDENCE_VERIFIED
    FINAL_RC=0

The evaluator also calculates the SHA-256 digest of the evidence artifact.

## Host Capability Model

The evaluator is intentionally host-aware.

A minimal host can execute platform-independent public validation models.

A host with Docker can additionally execute container-based evaluation infrastructure.

A suitable Linux host with tc / netem can support network-fault evaluation unavailable on restricted environments.

Evaluation results must therefore always be interpreted together with the reported platform and capability status.

For example:

    platform=android/arm64
    STAGE=docker-capability STATUS=SKIPPED
    STAGE=netem-capability STATUS=SKIPPED

This means the platform-independent evaluation executed while those host-specific capabilities were not tested.

It does not mean Docker or netem evaluation passed.

## Docker Continuity Lab

The repository contains an additional Docker continuity laboratory:

    docker/continuity-lab/

It provides scenario infrastructure for environments where Docker is available.

The public capsule detects Docker availability but does not fabricate a Docker result when Docker cannot be executed.

A Docker result should only be claimed after execution on a Docker-capable host.

## Security Boundary

The Public Evaluation Capsule is intentionally separated from the protected VRP implementation.

The public repository may expose:

- validation models;
- scenario definitions;
- evidence schemas;
- evidence samples;
- verification tools;
- observable invariants;
- machine-readable verdicts.

It does not need to expose:

- private runtime source code;
- proprietary transition mechanisms;
- protected authority internals;
- private key material;
- production secrets;
- confidential deployment logic.

The evaluation boundary is behavioral.

## Reproducibility

A public evaluation should record at minimum:

    capsule version
    run ID
    Git commit
    platform
    Go runtime
    stage results
    final return code
    final verdict

Where artifacts are exported, cryptographic hashes should be recorded with them.

This allows an evaluator to identify the repository state and environment that produced a result.

## Interpretation

A successful public evaluation demonstrates that the public evaluation artifacts produced the expected observable behavior for the scenarios that actually executed.

It must not be interpreted as proof of capabilities that were skipped.

It must not be interpreted as disclosure or independent inspection of the protected VRP runtime.

The intended evaluation chain is:

    claim
      |
      v
    scenario
      |
      v
    observable behavior
      |
      v
    evidence
      |
      v
    verification
      |
      v
    verdict

The behavior is what should be tested.

## Public Evaluation Boundary

VRP follows a black-box evaluation model:

    Protected Runtime
           |
           | observable outputs
           v
    Public Evidence Boundary
           |
           | independent verification
           v
    Evaluation Capsule
           |
           v
    Machine-Readable Verdict

The purpose of this boundary is to make evaluation reproducible without making protected implementation details public.

## Evaluation Scope

Use of this public repository does not imply transfer of ownership of VRP, its protected runtime, private implementation mechanisms, or associated intellectual property.

Public artifacts exist for evaluation, verification, interoperability research, and technical review within the scope defined by this repository and its applicable license.
