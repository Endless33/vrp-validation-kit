VRP External Validation Kit

Public engineering evaluation for observable VRP behavior, invariant preservation, adversarial conditions, transport-path authority, and evidence verification.

VRP — Veil Routing Protocol

Observable behavior. Reproducible evidence. Protected implementation.

---

Repository

https://github.com/Endless33/vrp-validation-kit

Current Signed Release

https://github.com/Endless33/vrp-validation-kit/releases/tag/v1.1.0

Baseline Release

https://github.com/Endless33/vrp-validation-kit/releases/tag/v1.0.0

Pilot Application

https://tally.so/r/ZjQLN0

---

Purpose

The VRP External Validation Kit provides public tools and documentation for evaluating declared VRP behavior without publishing the protected runtime implementation.

The repository focuses on externally observable properties and declared public contracts including:

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

Core Architecture Principle

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

Public Transport-Path Invariant

The current public validation work establishes the following transport-path invariant for the validated scenarios:

REJECTED_PACKET
    => NO_CANONICAL_COMMIT
    => NO_PERSISTENT_PATH_MUTATION
    => NO_TRANSPORT_CHANGE_INCREMENT

In compact form:

RECEIVE != ADMIT

OBSERVATION != AUTHORITY

CANDIDATE_PATH != ACTIVE_PATH

REJECTION != PARTIAL COMMIT

A rejected packet must not gain persistent path influence merely because the operating system observed it from a new UDP source endpoint.

At the same time:

LEGITIMATE_ADMISSION
    => AUTHORIZED_PATH_CHANGE_MAY_OCCUR

The objective is not to prevent transport replacement.

The objective is to prevent unauthorized transport replacement.

---

Evaluation Boundary

This repository contains public validation models, adversarial contract models, evidence verifiers, documentation, and a Docker-based black-box evaluation harness.

It does not contain the production VRP runtime.

The standalone Go programs expose and exercise declared public validation contracts.

They do not execute or disclose the protected production runtime.

The Docker Continuity Evidence Lab evaluates a separately supplied authorized black-box subject image through a public adapter contract.

A successful public verdict establishes only that the declared observable conditions were satisfied within the evaluated boundary.

It does not independently prove:

- the internal implementation used;
- formal protocol correctness;
- production readiness;
- resistance to every possible failure;
- host or hardware integrity;
- behavior outside the tested scenario;
- certification by VRP or any third party.

---

Protected Core Disclosure Boundary

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

Public material does not disclose:

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

Release Boundary

Reference| Scope| Intended Use
"v1.0.0"| Baseline public Go validation harness and early evaluation surface| Historical baseline reproduction
"v1.1.0"| Signed public validation/evidence release| Integrity-anchored public evaluation
"main"| Current validation work, evaluation capsule, evidence verification, Docker Continuity Evidence Lab, transport-path validation, release-closeout records, and extended documentation| Current engineering evaluation

The Docker Continuity Evidence Lab, evidence-verification components, evaluation capsule, transport-path authority documentation, and later reproducibility work extend the original "v1.0.0" baseline.

When reporting results from "main", always include the exact evaluated commit hash.

Where a validation document provides an immutable checkpoint, include both the declared commit and tree identity.

Do not assume that results from one commit automatically apply to another.

---

Current Main Checkpoint

A clean public checkout used for standalone reproduction on 2026-10-26 resolved to:

HEAD:
0ca57a74f665decc068a9c9d7756674261217301

TREE:
3c8afc7e757b6bd49be442c4e1d0f0e8120f990a

Evaluators should record their own commit and tree before execution:

git rev-parse HEAD
git rev-parse HEAD^{tree}

The identities above describe the reproduced checkpoint only.

They are not a substitute for recording the evaluator's actual checkout.

---

Current Status

The current repository state includes:

- public Go validation-contract executables;
- public evaluation capsule;
- public evaluation orchestrator;
- external adversarial contract model;
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
- pilot documentation;
- transport-path admission documentation;
- rejected-endpoint adversarial validation;
- real UDP path-authority validation;
- execution-authority vs transport-authority boundary documentation;
- immutable validation checkpoint records.

The Docker lab files have undergone repository-level validation including:

- Bash syntax validation;
- YAML validation;
- JSON validation;
- contract-reference validation;
- executable-bit validation;
- relative-link validation;
- public-boundary scanning.

Controlled Docker Continuity Evidence Lab work includes scenarios for:

- Wi-Fi → Mobile migration;
- Blackout Recovery;
- Replay Attempt;
- Stale Authority;
- 200 ms Latency Impairment.

Docker scenario results must be distinguished from standalone public-contract execution.

A host that does not execute the Docker lab must report Docker as unavailable or skipped.

SKIPPED != PASS

Each successful validation applies only to:

- the evaluated repository state;
- the executed scenario or public contract;
- the supplied authorized black-box subject where applicable;
- the declared invariant contract;
- the recorded execution environment.

It does not establish:

- universal production readiness;
- formal protocol verification;
- correctness outside the executed scenario;
- certification by any third party.

---

Public Executable Surface

At the reproduced "main" checkpoint, the public Go command surface is:

cmd/attack-suite
cmd/evidence-verify
cmd/vrp-evaluate
cmd/vrp-runtime-scenario
cmd/vrp-test

The repository also provides the top-level public evaluation orchestrator:

scripts/public-evaluate.sh

Evaluators should prefer the orchestrator for a complete standalone public evaluation because it records environment information, executes the available public stages, hashes generated artifacts, and distinguishes unavailable capabilities from successful ones.

---

Canonical Public Evaluation Entry Point

For the current "main" evaluation surface, the recommended entry point is:

./scripts/public-evaluate.sh

The evaluator currently coordinates stages including:

- evaluation-capsule build;
- environment doctor;
- sample evidence verification;
- Go package build/test command;
- Go vet;
- validation contract model;
- adversarial attack contract model;
- runtime scenario contract model;
- Docker capability detection;
- Docker Continuity Evidence Lab execution when the required capability and authorized subject are available;
- artifact hashing;
- machine-readable final result.

Unavailable optional capabilities must not be converted into PASS.

The evaluator explicitly reports:

SKIPPED_IS_NOT_PASS

---

Important Interpretation of "go test ./..."

The command:

go test ./...

is useful as a Go package compilation/test-discovery check.

At the reproduced checkpoint:

0ca57a74f665decc068a9c9d7756674261217301

the public command packages contain no "*_test.go" files.

Therefore:

go test ./...

must not by itself be described as proof that the public validation contracts, adversarial model, runtime scenario model, or Docker scenarios were executed.

Those surfaces are executed through their corresponding commands or through:

./scripts/public-evaluate.sh

A successful "go test ./..." result at this checkpoint means that the discovered Go packages completed successfully under the Go test command.

It does not mean that a hidden or nonexistent unit-test suite was executed.

---

Standalone Reproduction — Android / Termux

The current public evaluation surface has been independently re-executed from a clean repository clone on Android/ARM64 using Termux.

Recorded environment:

platform=android/arm64
go=go1.27.0
git_head=0ca57a74f665decc068a9c9d7756674261217301
git_tree=3c8afc7e757b6bd49be442c4e1d0f0e8120f990a

The public evaluator reported:

BUILD=PASS
DOCTOR=PASS
SAMPLE_EVIDENCE_VERIFY=PASS
GO_TEST=PASS
GO_VET=PASS
VALIDATION_MODEL=PASS
ATTACK_MODEL=PASS
RUNTIME_SCENARIO_MODEL=PASS

Machine-readable summary:

PASSED=8
FAILED=0
SKIPPED=1
FINAL_RC=0
FINAL_VERDICT=PUBLIC_EVALUATION_PASSED

The skipped capability was:

DOCKER_CONTINUITY_LAB=SKIPPED

Reason:

docker_runtime_not_available_on_this_host

The evaluator explicitly reported:

SKIPPED_IS_NOT_PASS

The tracked worktree remained clean after evaluation.

This result establishes reproducibility of the executed standalone public evaluation stages on that recorded Android/ARM64 environment.

It does not establish a Docker Continuity Evidence Lab PASS.

It does not represent execution of the protected production runtime.

---

Sample Evidence Verification

The reproduced standalone evaluation independently verified the bundled public sample evidence.

For the recorded run:

expected_hash=
68652f20d5a9a3fabbf3815005944bc4f6c721ced682f51a4c0650aec7051259

computed_hash=
68652f20d5a9a3fabbf3815005944bc4f6c721ced682f51a4c0650aec7051259

Result:

accepted=true
VERDICT=EVIDENCE_BUNDLE_VERIFIED
FINAL_VERDICT=EVIDENCE_VERIFIED

This establishes that the public verifier accepted that bundled evidence according to its declared verification contract.

It does not independently establish the correctness of behavior outside that evidence bundle.

---

Transport-Path Admission Validation

Recent public engineering work extends the validation surface to the transport-path authority boundary.

The central question is:

«Can rejected traffic arriving from a new network endpoint persistently replace the active transport path?»

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

Adversarial Path Validation

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

Real Kernel UDP Validation

The transport-path invariant has also been exercised using real kernel UDP sockets and distinct source endpoints at the documented qualified transport-path checkpoint.

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

Transport Continuity vs Execution Authority

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

The public documentation intentionally does not claim that duplicate mutation always permits transport reattachment.

It also does not claim that duplicate mutation always forbids transport reattachment.

That authority boundary requires independent evidence.

The validated baseline remains:

rejected traffic
    => no persistent path mutation

while:

legitimate admitted migration
    => path replacement preserved

---

Public Validation Documents

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

Qualified Transport-Path Checkpoint

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

Release and Pilot Status

The current public validation boundary includes release-closeout and pilot-oriented evaluation material.

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
- Validation Checkpoint "4cfc77ab".

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

The public evaluation boundary does not expose:

- protected runtime source code;
- authority implementation;
- internal runtime state;
- decision algorithms;
- cryptographic secrets;
- private keys;
- bearer material;
- protected packets;
- production credentials.

The public repository evaluates externally observable behavior and declared public contracts only.

---

Requirements

Standalone Public Evaluation

- Git
- Go 1.24+
- Bash for "scripts/public-evaluate.sh"

Docker Continuity Evidence Lab

- Linux
- Docker Engine
- Docker Compose v2
- Bash
- sha256sum
- Linux bridge networking
- authorized subject image

The protected subject image is supplied separately.

It is not included in this repository.

Android Termux can inspect the repository and execute the standalone public evaluation surface.

The Docker Continuity Evidence Lab requires a Docker-capable Linux host and an authorized subject image.

---

Quick Evaluation

Clone the repository:

git clone https://github.com/Endless33/vrp-validation-kit.git
cd vrp-validation-kit

Record the evaluated source identity:

git rev-parse HEAD
git rev-parse HEAD^{tree}

Check the worktree:

git status --short

For the current "main" public evaluation surface, run:

./scripts/public-evaluate.sh

The evaluator records the environment, executes the available public stages, generates evaluation artifacts, and reports unavailable optional capabilities separately.

A result containing:

STATUS=SKIPPED
note=SKIPPED_IS_NOT_PASS

must not be represented as a successful execution of that skipped capability.

---

Manual Standalone Commands

The individual public contract executables may also be run directly.

Validation Contract

go run ./cmd/vrp-test

Expected terminal verdict at the current checkpoint:

FINAL_VERDICT=VALIDATION_CONTRACT_AVAILABLE

Runtime Scenario Contract

go run ./cmd/vrp-runtime-scenario

Expected terminal verdict at the current checkpoint:

FINAL_VERDICT=CONTINUITY_CONTRACT_AVAILABLE

Adversarial Attack Contract

go run ./cmd/attack-suite

Expected terminal verdict at the current checkpoint:

FINAL_VERDICT=ATTACK_SUITE_PASSED

Environment Doctor

go run ./cmd/vrp-evaluate doctor

Sample Evidence Verification

go run ./cmd/vrp-evaluate verify-sample

Expected successful evidence verdict:

FINAL_VERDICT=EVIDENCE_VERIFIED

Full Public Evaluation Capsule

go run ./cmd/vrp-evaluate run

or use the repository-level orchestrator:

./scripts/public-evaluate.sh

The repository-level orchestrator is preferred when recording a complete reproducibility result.

---

Docker Continuity Evidence Lab

The Docker Continuity Evidence Lab evaluates an authorized black-box subject through an evidence-only public interface.

The lab controls only:

- network topology;
- logical path availability;
- public stimuli;
- witness observations;
- public evidence;
- invariant verification.

The lab never requires disclosure of:

- runtime memory;
- authority implementation;
- protocol internals;
- recovery algorithms;
- protected source code.

Docker availability alone is insufficient.

A valid Docker black-box evaluation also requires an authorized subject image compatible with the public adapter contract.

---

Public Docker Scenarios

The repository currently includes five public Docker scenarios.

Scenario| Purpose
"wifi-to-mobile"| Logical path migration
"blackout-recovery"| Recovery after complete connectivity loss
"replay-attempt"| Replay rejection
"stale-authority"| Authority freshness validation
"loss50-latency200"| Latency impairment using Toxiproxy

---

Running the Docker Lab

The Docker lab requires a separately supplied authorized subject image.

Select the authorized image:

export VRP_LAB_SUBJECT_IMAGE=<AUTHORIZED_SUBJECT_IMAGE>

Do not substitute an arbitrary image and interpret the resulting execution as VRP validation.

Run a published scenario, for example:

./docker/continuity-lab/scripts/run-scenario.sh \
docker/continuity-lab/configs/wifi-to-mobile.yaml

Another published scenario:

./docker/continuity-lab/scripts/run-scenario.sh \
docker/continuity-lab/configs/loss50-latency200.yaml

After execution, identify the generated run directory and verify its evidence:

./docker/continuity-lab/scripts/verify-evidence.sh \
docker/continuity-lab/out/<RUN_ID>

Only the verifier output from the actual run should be used when reporting the scenario verdict.

Do not assume a PASS before execution.

---

Manual Cable Pull Evaluation

The Wi-Fi → Mobile scenario can be used as part of an authorized continuity evaluation where the environment and subject are configured for the intended network transition.

Start the scenario using the authorized subject:

export VRP_LAB_SUBJECT_IMAGE=<AUTHORIZED_SUBJECT_IMAGE>

./docker/continuity-lab/scripts/run-scenario.sh \
docker/continuity-lab/configs/wifi-to-mobile.yaml

Where the evaluation procedure explicitly requires a physical or host-level transport interruption, the evaluator may perform the documented network transition.

Examples may include:

- disconnecting the designated primary network interface;
- disabling the designated active adapter;
- physically disconnecting the designated Ethernet path.

The exact procedure must match the evaluated topology.

After the run, verify the generated evidence:

./docker/continuity-lab/scripts/verify-evidence.sh \
docker/continuity-lab/out/<RUN_ID>

A scenario must not be reported as PASS merely because the harness started successfully.

The final claim must be based on the generated evidence and verifier result.

---

Latency Impairment Scenario

Scenario:

docker/continuity-lab/configs/loss50-latency200.yaml

Purpose:

Inject deterministic impairment through the public Docker proxy layer while evaluating externally observable continuity behavior.

The published scenario includes:

- 200 ms latency impairment;
- logical-path evaluation;
- deterministic scenario configuration;
- public witness evidence.

The protected runtime remains opaque.

Run:

./docker/continuity-lab/scripts/run-scenario.sh \
docker/continuity-lab/configs/loss50-latency200.yaml

Then verify the generated run:

./docker/continuity-lab/scripts/verify-evidence.sh \
docker/continuity-lab/out/<RUN_ID>

---

Observable Events

Docker scenarios may record public witness events including:

infrastructure.ready
subject.ready
network.toxic.added
network.toxic.removed
subject.completed
run.completed

The public evidence boundary is designed not to expose protected runtime implementation information.

---

Evidence Produced

A completed Docker evaluation may generate public artifacts including:

manifest.json

verification.json

subject/
    subject-events.jsonl
    subject-evidence.json

witness/
    events.jsonl
    environment.json

The verifier evaluates declared public evidence properties including applicable:

- artifact hashes;
- schema compatibility;
- invariant contract;
- witness ordering;
- continuity-reference stability;
- duplicate rejection;
- public evidence completeness.

Exact generated artifacts depend on the executed scenario and repository checkpoint.

---

Evidence Interpretation

A successful verification may report:

VERDICT=PASS

The meaning of that result is bounded by:

- the exact repository state;
- the executed scenario;
- the supplied subject;
- the declared invariant contract;
- the captured evidence;
- the verifier version;
- the execution environment.

The result does not disclose or prove the protected implementation.

---

Design Philosophy

The public validation boundary is intentionally limited.

The repository demonstrates observable behavior and declared public contracts, not protected implementation details.

Every engineering claim is expected to remain bounded by reproducible evidence.

Protected implementation details remain outside the evaluation boundary.

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

Evidence-First Engineering

VRP public validation follows several rules:

verdict alone is not enough

postcondition matters

rejected input must not leave unauthorized persistent state

positive controls must preserve legitimate behavior

race-sensitive invariants require race validation

public claims must identify their evaluated source state

skipped capability is not a passed capability

model execution is not protected-runtime execution

This means a test should not merely demonstrate:

REJECTED

when the security claim actually requires:

REJECTED
    +
STATE PRESERVED

Likewise, a security hardening should not be accepted if it achieves rejection by destroying legitimate continuity.

Both negative and positive behavior matter.

---

Public Evaluation Model

The Docker Continuity Evidence Lab is designed around a deterministic public evaluation pipeline:

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

The verifier evaluates only the declared public evidence boundary.

Protected runtime internals are not required for black-box evaluation.

---

Public Boundary

The evaluation boundary intentionally excludes:

- protected protocol implementation;
- authority algorithms;
- private session-management logic;
- protected routing decisions;
- protected state;
- cryptographic secrets;
- runtime memory.

Only declared public contracts and externally observable evidence are evaluated.

---

What PASS Means

A successful PASS means that the executed evaluation satisfied the declared public conditions evaluated by that stage, scenario, or verifier.

PASS does not mean:

- formal verification;
- production certification;
- security certification;
- disclosure of implementation;
- proof of every possible failure mode;
- proof of behavior outside the evaluated boundary;
- third-party endorsement.

A standalone public-contract PASS must not be represented as a Docker black-box PASS.

A Docker scenario PASS must not be generalized to scenarios that were not executed.

---

What SKIPPED Means

SKIPPED means that an evaluation capability was not executed.

Examples include:

- Docker unavailable on the host;
- required host capability unavailable;
- authorized subject unavailable;
- scenario not applicable to the current environment.

The rule is explicit:

SKIPPED != PASS

The public evaluator is designed to preserve this distinction.

---

What FAIL Means

A FAIL verdict indicates that one or more required conditions for the executed evaluation were violated.

Examples may include:

- missing required evidence;
- duplicate acceptance;
- unexpected continuity-reference replacement;
- invalid event ordering;
- required witness events not observed;
- scenario-specific invariant violations;
- unauthorized persistent state mutation where immutability is required.

A reproducible FAIL is useful engineering evidence.

It should be investigated rather than hidden.

---

What INCOMPLETE Means

INCOMPLETE indicates that the evaluation could not reach a valid conclusion.

Examples include:

- infrastructure failure;
- incomplete evidence;
- interrupted execution;
- unsupported scenario;
- verifier interruption.

INCOMPLETE is intentionally different from FAIL.

---

Deterministic Verification

The evidence verifier is designed for deterministic evaluation.

Running the verifier repeatedly against identical evidence should produce identical declared verification results.

Example:

./docker/continuity-lab/scripts/verify-evidence.sh \
docker/continuity-lab/out/<RUN_ID>

Where applicable, repeated verification should preserve:

- verdict;
- invariant results;
- evidence hashes.

Any reproducibility discrepancy should be reported with the exact repository state and evidence bundle.

---

Reproducibility

The public evaluation model is designed for independent verification.

An evaluator should be able to:

1. Clone the repository.
2. Record the exact evaluated commit and tree.
3. Record the execution environment.
4. Execute the public evaluator or a published scenario.
5. Collect generated evidence.
6. Run the applicable verifier.
7. Record the final verdict.
8. Report unavailable capabilities as unavailable or skipped.
9. Compare results without requiring protected implementation disclosure.

For checkpoint-specific claims, evaluators should use the commit and tree recorded in the corresponding validation document.

---

Recommended Independent Evaluation Procedure

For a standalone evaluation:

git clone https://github.com/Endless33/vrp-validation-kit.git
cd vrp-validation-kit

git rev-parse HEAD
git rev-parse HEAD^{tree}
git status --short

./scripts/public-evaluate.sh

Record:

- repository HEAD;
- repository TREE;
- operating system;
- architecture;
- Go version;
- evaluator output;
- generated run ID;
- PASSED count;
- FAILED count;
- SKIPPED count;
- final verdict;
- final return code.

For Docker evaluation, additionally record:

- Docker Engine version;
- Docker Compose version;
- authorized subject identity/version;
- scenario configuration;
- generated evidence directory;
- verifier output.

---

Security Model

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

The evaluation framework is designed not to cross this boundary.

---

Authority Model — Public View

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

Intended Audience

The repository is intended for:

- protocol engineers;
- systems engineers;
- distributed-systems researchers;
- infrastructure architects;
- security engineers;
- red teams;
- technical evaluators;
- pilot engineering teams.

It is not intended to teach or expose protected implementation details.

---

Repository Goals

This repository exists to support:

- reproducible evaluation;
- deterministic evidence verification;
- black-box validation;
- evidence-first engineering;
- public invariant contracts;
- adversarial evaluation;
- transport-independent continuity research;
- controlled path replacement;
- explicit security boundaries.

The repository is not a reference implementation of the protected runtime.

---

Reporting Issues

Bug reports and reproducible counterexamples are welcome.

Please include:

- evaluated commit hash;
- evaluated tree hash where relevant;
- scenario or command;
- operating system;
- architecture;
- Go version;
- Docker version where applicable;
- verifier output;
- "verification.json" where applicable;
- "manifest.json" where applicable;
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

Contributing

Contributions improving the public evaluation framework are welcome.

Examples include:

- additional public scenarios;
- verifier improvements;
- documentation corrections;
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

Documentation commands should be verified against the current executable repository surface before publication.

---

Contact

Pilot and technical evaluation:

jumpingvpn@proton.me

Repository:

https://github.com/Endless33/vrp-validation-kit

---

License

Unless stated otherwise, repository contents are provided under the license included with the project.

The public evaluation framework does not transfer rights to the protected runtime implementation.

Protected runtime implementation remains private.

Refer to the repository "LICENSE" file for the applicable terms.

---

Final Notes

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

The reproducibility model adds another:

SKIPPED != PASS

and:

PUBLIC CONTRACT MODEL != PROTECTED RUNTIME EXECUTION

Evidence is public.

Behavior is reproducible within the evaluated boundary.

Claims are bounded by validation.

Implementation remains protected.

SESSION != TRANSPORT

CONTINUITY FIRST.

EVIDENCE OVER CLAIMS.