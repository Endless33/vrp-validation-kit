# VRP Public Evaluation — Security and Trust Model

## Purpose

External engineers must be able to understand what the VRP evaluation
software can and cannot do before executing it.

Trust must not depend on the identity of the author.

It should be reduced through inspection, isolation, reproducibility,
and cryptographic verification.

## Default Security Position

The public evaluation tooling should operate with the minimum authority
required for each operation.

Default evaluation behavior should not require:

- root access
- persistent system modification
- external credentials
- access to personal files
- cloud credentials
- SSH keys
- browser data
- unrelated network access

## Network Behavior

Evaluation tooling should operate offline whenever the selected scenario
does not require external connectivity.

Any scenario requiring network access must document:

- why access is required
- destination requirements
- protocol requirements
- expected traffic
- whether the scenario can be reproduced locally instead

No hidden telemetry is permitted.

## Privilege Boundary

Ordinary operations such as:

    vrp-evaluate doctor
    vrp-evaluate verify

should not require elevated privileges.

Network fault injection may require capabilities unavailable to an
unprivileged process.

Where required, privileged operations must be explicit and documented.

The evaluator must never silently escalate privileges.

## Filesystem Boundary

Evaluation artifacts should be written beneath an explicitly declared
run directory.

Example:

    ./out/<RUN_ID>/

The evaluator should not modify unrelated user files.

## Binary Verification

Published binaries should be accompanied by SHA-256 checksums.

Expected workflow:

    sha256sum -c SHA256SUMS

Only after successful verification should execution begin.

## Build Transparency

Where public source code is available for the evaluation harness and
verifier, evaluators should be able to build those components themselves.

Protected VRP runtime internals are outside this transparency boundary.

This separation is intentional.

## Evidence Independence

A runtime-generated PASS verdict is not sufficient evidence by itself.

The independent verification path must evaluate the generated evidence
and determine whether the recorded result satisfies the declared
validation contract.

Conceptually:

    EXECUTION VERDICT
            │
            ▼
        EVIDENCE
            │
            ▼
    INDEPENDENT VERIFIER
            │
        ┌───┴───┐
        ▼       ▼
      ACCEPT   REJECT

## Failure Semantics

Verification must fail closed.

Missing evidence must not become PASS.

Malformed evidence must not become PASS.

Hash mismatch must not become PASS.

Unsupported evidence versions must not silently become PASS.

Contradictory evidence must not become PASS.

A verifier failure must remain distinguishable from a successful
verification result.

## Private Runtime Boundary

Public evaluation does not grant access to:

- protected VRP source code
- proprietary runtime mechanisms
- private protocol implementation details
- internal signing material
- production credentials
- private infrastructure

Observable behavior and evidence are the evaluation interface.

## Evaluator Control

External evaluators should retain control over:

- the machine running the evaluation
- the network environment
- failure injection
- artifact preservation
- independent log collection
- evidence verification

This allows the evaluator to challenge VRP rather than merely observe
a demonstration controlled by its creator.

## Principle

Trust should decrease as reproducibility increases.

The objective of the VRP Public Evaluation Capsule is therefore not:

    TRUST THE AUTHOR

It is:

    VERIFY THE BINARY
          ↓
    CONTROL THE ENVIRONMENT
          ↓
    EXECUTE THE TEST
          ↓
    PRESERVE THE EVIDENCE
          ↓
    VERIFY INDEPENDENTLY