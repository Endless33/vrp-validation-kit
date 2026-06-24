License

This repository is distributed under the VRP Validation Kit Evaluation License.

See:

EVALUATION_LICENSE.md

---

# VRP Pilot Documentation

This section contains documentation intended for organizations evaluating VRP in pilot environments.

Documents:

- PILOT_BOUNDARY_OVERVIEW.md
- INTEGRATION_PATH.md
- PILOT_PROGRAM.md

These documents describe:

- evaluation boundaries
- integration flow
- pilot structure
- evidence expectations
- validation objectives

---

VRP Validation Kit

Quick Start

1. Download a release asset
2. Extract the archive
3. Run a validation binary
4. Inspect the verdicts

The goal is not to expose implementation details.

The goal is to provide reproducible validation artifacts that engineers can execute independently and inspect directly.

---

Purpose

Most networking demonstrations focus on connectivity.

VRP focuses on execution correctness.

Transport may fail.

Execution correctness must remain deterministic.

This validation kit allows engineers to observe that behavior through reproducible runtime evidence.

---

Who This Is For

This validation kit is intended for:

- Distributed systems engineers
- Protocol designers
- Reliability engineers
- Network engineers
- Site Reliability Engineers (SREs)
- Infrastructure engineers
- Platform engineers
- Researchers interested in execution correctness under transport instability

The kit is designed for engineers who want observable runtime behavior rather than conceptual descriptions.

---

Tested Invariants

The validation kit currently validates:

- Duplicate commit rejection
- Replay window enforcement
- Stale authority rejection
- Authority rollback rejection
- Stale epoch rejection
- Authority migration correctness
- Commit replay rejection
- Session recovery preservation
- Session identity preservation across transport migration
- Canonical execution history consistency

---

No Dependencies

Prebuilt binaries require:

- No Go installation
- No external libraries
- No runtime configuration
- No environment setup
- No network connectivity

Download.

Run.

Inspect the verdicts.

---

Build

Linux:

go build -o vrp-test ./cmd/vrp-test

Windows:

go build -o vrp-test.exe ./cmd/vrp-test

Cross-compile Linux binary from Windows:

$env:GOOS="linux"
$env:GOARCH="amd64"

go build -o vrp-test ./cmd/vrp-test

---

Validation Harness

Linux:

./vrp-test-linux-amd64

Windows:

.\vrp-test-windows-amd64.exe

Expected verdict:

FINAL_VERDICT=VALIDATION_PASSED

---

Integrated Runtime Scenario

Linux:

go run ./cmd/vrp-runtime-scenario

Windows:

go run ./cmd/vrp-runtime-scenario

Expected verdict:

FINAL_VERDICT=CONTINUITY_PRESERVED

---

Closed Core Runner

The validation kit also includes a closed-core runner preview distributed as prebuilt binaries.

The runner exposes executable validation scenarios without exposing private implementation details.

Linux:

chmod +x vrp-core-runner-linux-amd64

./vrp-core-runner-linux-amd64 --list

Windows:

.\vrp-core-runner-windows-amd64.exe --list

Available scenarios:

replay-storm
authority-rollback
runtime-recovery
transport-migration
integrated-chaos

---

Replay Window Scenario

Linux:

./vrp-core-runner-linux-amd64 --scenario replay-storm --packets 10000

Windows:

.\vrp-core-runner-windows-amd64.exe --scenario replay-storm --packets 10000

Expected behavior:

packets=10000
sequence=100

accepted=1
rejected=9999

VERDICT=REPLAY_WINDOW_ENFORCED

This scenario validates replay admission behavior by repeatedly submitting the same sequence identifier through a replay window.

---

Authority Rollback Scenario

Linux:

./vrp-core-runner-linux-amd64 --scenario authority-rollback --epoch 5

Windows:

.\vrp-core-runner-windows-amd64.exe --scenario authority-rollback --epoch 5

Expected behavior:

current_epoch=10
candidate_epoch=5

rollback_accepted=false

VERDICT=AUTHORITY_ROLLBACK_REJECTED

This scenario validates epoch monotonicity and authority rollback containment.

---

Session Recovery Scenario

Linux:

./vrp-core-runner-linux-amd64 --scenario runtime-recovery

Windows:

.\vrp-core-runner-windows-amd64.exe --scenario runtime-recovery

Expected behavior:

session_preserved=true
authority_preserved=true
epoch_preserved=true
history_preserved=true
recovered=true

VERDICT=SESSION_RECOVERY_PRESERVED

This scenario validates snapshot creation, runtime failure simulation, and recovery consistency.

---

Transport Migration Scenario

Linux:

./vrp-core-runner-linux-amd64 --scenario transport-migration --hops 50

Windows:

.\vrp-core-runner-windows-amd64.exe --scenario transport-migration --hops 50

Expected behavior:

hops=50

session_before=session-alpha
session_after=session-alpha

session_preserved=true
authority_preserved=true
epoch_preserved=true
history_preserved=true

VERDICT=TRANSPORT_MIGRATION_PRESERVED

This scenario validates repeated transport migration events while preserving session identity, authority state, epoch continuity, and canonical execution history.

The scenario simulates multiple transport transitions and verifies that execution state remains stable across migration boundaries.

---

Expected Runtime

Validation execution typically completes in less than 10 seconds on modern hardware.

No external services are required.

All validation scenarios execute locally and deterministically.

---

Runtime Model

mutation
    ↓
validation
    ↓
replay window
    ↓
authority check
    ↓
epoch check
    ↓
commit admission
    ↓
canonical history

The validation kit demonstrates that execution correctness is enforced at admission boundaries before mutations become part of canonical history.

---

Failure Model Matrix

Failure Condition| Expected Behavior| Validation Status
Replay Packet| Rejected| Verified
Duplicate Mutation| Rejected| Verified
Commit Replay| Rejected| Verified
Stale Authority| Rejected| Verified
Authority Rollback| Rejected| Verified
Stale Epoch| Rejected| Verified
Transport Migration| Session Preserved| Verified
Authority Migration| Monotonic Transition| Verified
Runtime Recovery| Session Preserved| Verified
Canonical History Validation| History Preserved| Verified

The objective is not to prevent failures from occurring.

The objective is to ensure that failures do not corrupt canonical execution state.

Each validated failure condition is expected to produce deterministic and reproducible behavior.

---

Validation Philosophy

The purpose of the validation kit is not to prove that networks never fail.

The purpose is to demonstrate that execution correctness remains bounded and deterministic when failures occur.

Validation evidence should be:

- Observable
- Reproducible
- Deterministic
- Independently verifiable

---

What This Kit Demonstrates

This kit demonstrates:

- Deterministic commit admission
- Replay containment
- Replay window enforcement
- Monotonic authority transitions
- Authority rollback rejection
- Monotonic epoch progression
- Duplicate mutation containment
- Commit replay protection
- Session continuity across transport changes
- Transport migration preservation
- Snapshot-based recovery
- Canonical execution history preservation

---

What This Kit Does Not Demonstrate

This kit does not prove:

- Production readiness
- Formal verification
- Cryptographic security
- Performance characteristics
- Regulatory compliance
- Resistance to all adversarial conditions

Those require separate validation processes.

---

Validation Evidence

The validation kit has been successfully executed across independent environments.

Verified environments:

- Windows 11
- Linux (Termux)
- Oracle Cloud Linux

Observed results:

FINAL_VERDICT=VALIDATION_PASSED
FINAL_VERDICT=CONTINUITY_PRESERVED

VERDICT=REPLAY_WINDOW_ENFORCED
VERDICT=AUTHORITY_ROLLBACK_REJECTED
VERDICT=SESSION_RECOVERY_PRESERVED
VERDICT=TRANSPORT_MIGRATION_PRESERVED

This demonstrates that the repository can be cloned, built, executed, and validated without modification while producing deterministic results.

---

External Evaluation

The repository also contains:

- Failure models
- Failure → invariant mappings
- External validation guides
- Pilot evaluation templates
- Pilot success criteria
- Evidence indexes

The objective is to make validation behavior observable and independently reviewable by external engineers.

---

Status

Current validation status:

VALIDATION_PASSED
CONTINUITY_PRESERVED
REPLAY_WINDOW_ENFORCED
AUTHORITY_ROLLBACK_REJECTED
SESSION_RECOVERY_PRESERVED
TRANSPORT_MIGRATION_PRESERVED

The protocol architecture and validation suite continue to evolve through staged testing, executable validation scenarios, and external engineering review.