# VRP Docker Continuity Evidence Lab

## Purpose

The VRP Docker Continuity Evidence Lab is a public black-box validation harness for observing continuity, recovery, stale-authority rejection, replay rejection, and evidence behavior under controlled network conditions.

The lab separates:

1. the harness-controlled fault environment;
2. the black-box subject under evaluation;
3. independently recorded witness events;
4. deterministic evidence verification;
5. exported evaluation reports.

The repository does not contain or reproduce the protected VRP runtime.

It does not expose:

- VRP source code;
- protected runtime algorithms;
- internal authority calculations;
- private state representations;
- cryptographic key material;
- recovery decision logic;
- proprietary packet-processing mechanisms;
- production credentials or deployment secrets.

An authorized runtime is supplied separately as a black-box adapter image.

## What This Lab Establishes

The lab can establish whether a supplied subject produced evidence consistent with the public invariant contract during a controlled scenario.

A successful result means that the required externally observable conditions were satisfied for that run.

A successful result does not independently prove:

- the internal implementation used to produce the result;
- production readiness;
- formal protocol correctness;
- resistance to every adversarial condition;
- hardware or host integrity;
- software provenance beyond the recorded image identity;
- behavior outside the tested scenario;
- certification by VRP or any third party.

Results use three possible verdicts:

- `PASS` — all required public observations were present and consistent;
- `FAIL` — one or more required observations contradicted the contract;
- `INCOMPLETE` — the run or its evidence was insufficient for a valid decision.

## Lab Topology

The Compose topology provides two logically separate data paths connected to one controlled origin:

- `wifi-plane`;
- `mobile-plane`.

The path names represent logical network paths. They do not emulate the full IEEE 802.11, cellular-radio, carrier, modem, or mobile-core stacks.

Both paths pass through a harness-controlled fault engine. The subject cannot access the fault-engine control plane.

The topology contains:

- `origin` — deterministic test destination;
- `fault-engine` — applies harness-requested connectivity faults;
- `wifi-gateway` — exposes the primary logical path;
- `mobile-gateway` — exposes the alternate logical path;
- `controller` — sends fault-control requests;
- `subject` — authorized black-box runtime adapter.

No service publishes a port to the host.

No service receives:

- the Docker socket;
- privileged mode;
- host networking;
- host PID access;
- access to protected runtime source code.

All lab networks are internal Docker bridge networks.

## Trust Boundary

The harness controls:

- scenario definitions;
- fault timing;
- proxy state;
- witness-event recording;
- the public invariant contract;
- deterministic verification;
- report export.

The black-box subject receives only:

- a run identifier;
- a bounded run duration;
- the primary endpoint;
- the alternate endpoint;
- a private evidence-output directory;
- the public adapter-contract version.

The following files are not mounted into the subject:

- scenario configurations;
- the expected invariant contract;
- witness logs;
- verification results;
- exported reports.

This prevents the subject from directly reading the complete scenario schedule or modifying harness-generated evidence.

The Docker host and Docker daemon remain part of the trusted computing base. A compromised host or daemon invalidates the evidentiary value of the run.

## Required Components

The host must provide:

- Docker Engine with Linux bridge-network support;
- Docker Compose v2;
- Bash;
- `sha256sum`;
- an authorized black-box subject image.

The subject image must be obtained through an approved delivery channel. This repository does not provide a protected runtime image.

For formal evaluation runs, all image references should use immutable digest-qualified identifiers:

```text
registry.example/authorized-subject@sha256:<digest>
```

Convenience tags may be used during local harness development, but they are not sufficient for reproducible evidence.

## Black-Box Adapter Contract

The default adapter entrypoint is:

```text
/vrp-lab-adapter
```

It may be overridden with:

```bash
export VRP_LAB_SUBJECT_ENTRYPOINT=/approved/path/to/adapter
```

The adapter must support the following public commands.

### Run

```text
/vrp-lab-adapter run
```

The process must remain in the foreground for the bounded evaluation workload and terminate with a non-zero exit status if it cannot produce complete subject evidence.

### Health

```text
/vrp-lab-adapter health
```

The command must return exit status `0` only when the adapter is ready to receive public test stimuli.

### Stimulus

```text
/vrp-lab-adapter stimulus --kind <kind> --event-id <public-event-id>
```

Supported public stimulus kinds are:

- `stale-authority`;
- `replay`.

A successful command exit means only that the stimulus was delivered to the evaluation boundary. It does not mean that the stimulus was accepted by the runtime.

The resulting public verdict must be recorded separately in subject evidence.

The adapter interface must not expose protected tokens, packet contents, key material, internal state, or proprietary decision traces.

## Adapter Environment

The Compose file supplies these variables:

| Variable | Meaning |
|---|---|
| `VRP_LAB_CONTRACT_VERSION` | Public adapter-contract version |
| `VRP_LAB_RUN_ID` | Unique identifier for the evaluation run |
| `VRP_LAB_RUN_DURATION_SECONDS` | Maximum planned workload duration |
| `VRP_LAB_PRIMARY_ENDPOINT` | Primary logical path endpoint |
| `VRP_LAB_ALTERNATE_ENDPOINT` | Alternate logical path endpoint |
| `VRP_LAB_EVIDENCE_DIRECTORY` | Writable subject-only evidence directory |
| `VRP_LAB_EVIDENCE_FORMAT` | Required public evidence format |

The adapter must treat endpoint names and path names as public test identifiers only.

## Required Subject Evidence

The subject must atomically produce:

```text
subject-evidence.json
subject-events.jsonl
```

Temporary files must not be treated as final evidence.

### `subject-evidence.json`

This file contains the final public observation summary for one run.

It must include:

- evidence schema version;
- run identifier;
- adapter identity;
- start and completion timestamps;
- opaque continuity reference;
- observed path-transition count;
- accepted-mutation count;
- duplicate-rejection count;
- stale-authority-rejection count;
- final public verdict;
- completion state.

### `subject-events.jsonl`

This file contains ordered public observations.

Each line must be one complete JSON object containing:

- schema version;
- run identifier;
- monotonically increasing event sequence;
- public event identifier;
- UTC timestamp;
- event kind;
- logical path identifier when applicable;
- externally observable verdict when applicable.

Evidence must not contain:

- private keys;
- secrets;
- bearer tokens;
- raw protected packets;
- internal memory addresses;
- internal source paths;
- stack dumps;
- proprietary runtime state;
- protected decision parameters.

## Output Isolation

Each run receives a dedicated output directory:

```text
out/<run-id>/
```

The expected layout is:

```text
out/<run-id>/
├── input/
│   └── scenario.yaml
├── subject/
│   ├── subject-evidence.json
│   └── subject-events.jsonl
├── witness/
│   ├── events.jsonl
│   └── environment.json
├── manifest.json
├── verification.json
└── report/
```

The subject can write only to:

```text
out/<run-id>/subject/
```

It cannot modify witness events, the verification result, or the exported report.

## Available Scenarios

### Wi-Fi to Mobile

```text
configs/wifi-to-mobile.yaml
```

Disables the primary logical path while the alternate path remains reachable.

The public evaluation checks whether the continuity reference remains stable and whether workload progress resumes without an unauthorized logical-session replacement.

### Blackout Recovery

```text
configs/blackout-recovery.yaml
```

Disables both logical paths for a bounded interval and then restores connectivity.

The public evaluation checks recovery behavior, continuity-reference stability, and the absence of duplicate accepted mutations after recovery.

### Stale Authority

```text
configs/stale-authority.yaml
```

Delivers an opaque stale-authority test stimulus through the public adapter boundary.

The harness does not construct, decode, or inspect protected authority material.

The public evaluation checks for a rejection verdict and verifies that no additional accepted mutation was attributed to the rejected stimulus.

### Replay Attempt

```text
configs/replay-attempt.yaml
```

Requests replay of an opaque adapter-generated test artifact through the public adapter boundary.

The harness does not inspect protected payload contents.

The public evaluation checks for duplicate rejection and verifies that the replay did not create an additional accepted mutation.

## Running a Scenario

Change to the lab directory:

```bash
cd docker/continuity-lab
```

Set the authorized subject image:

```bash
export VRP_LAB_SUBJECT_IMAGE='registry.example/authorized-subject@sha256:<digest>'
```

Use the current host identity for the subject evidence directory:

```bash
export VRP_LAB_SUBJECT_UID="$(id -u)"
export VRP_LAB_SUBJECT_GID="$(id -g)"
```

Run one scenario:

```bash
./scripts/run-scenario.sh configs/wifi-to-mobile.yaml
```

The runner prints the exact run directory and final execution state.

A scenario failure must not be silently converted into a successful result.

## Verifying Evidence

Verify a completed run:

```bash
./scripts/verify-evidence.sh out/<run-id>
```

Verification checks include:

- required artifact presence;
- schema-version compatibility;
- run-identifier consistency;
- JSON and JSONL structural validity;
- monotonic subject-event sequencing;
- unique public event identifiers;
- scenario-to-witness consistency;
- subject-to-witness consistency;
- public invariant-contract evaluation;
- recorded artifact hashes;
- fail-closed handling of missing or ambiguous evidence.

Verification does not infer missing observations.

If a required observation cannot be established, the result is `INCOMPLETE` or `FAIL`, according to the public acceptance contract.

## Exporting a Report

Export a verified run:

```bash
./scripts/export-report.sh out/<run-id>
```

The exporter produces a review package containing:

- the scenario snapshot;
- witness events;
- subject evidence;
- environment metadata;
- verification result;
- invariant-contract identity;
- artifact hashes;
- a human-readable summary.

Export does not add protected runtime material.

## Scenario Integrity

The runner snapshots the selected scenario into the run directory before execution.

The snapshot hash is recorded in the run manifest.

Changing a repository scenario after a run does not change the scenario snapshot associated with that run.

The expected invariant contract is also identified by its SHA-256 digest.

A verifier must reject evidence when:

- the run identifier is inconsistent;
- the scenario snapshot is missing;
- a required file hash does not match;
- event sequencing is ambiguous;
- required observations are absent;
- the subject reports success while witness evidence contradicts it;
- the run was not completed cleanly.

## Image Identity

The manifest records, where available:

- configured image reference;
- resolved local image identifier;
- repository digest;
- Docker Engine version;
- Docker Compose version;
- host architecture;
- run start and completion time.

An image tag alone is not considered an immutable identity.

For controlled evaluation, use digest-qualified images and retain the corresponding delivery and authorization records outside this public repository.

## Evidence Interpretation

The lab distinguishes three evidence layers:

1. **Witness evidence** records actions performed by the harness.
2. **Subject evidence** records public observations reported by the adapter.
3. **Verification evidence** evaluates both sources against the public invariant contract.

No single layer is sufficient by itself.

A subject-generated success statement cannot override contradictory witness evidence.

A witness event cannot establish an internal runtime property that has no public observation.

The verifier evaluates only the declared public contract.

## Reproducibility Rules

For comparable runs:

- use the same scenario snapshot;
- use the same invariant-contract digest;
- use the same subject-image digest;
- use the same harness-image digests;
- record the Docker and host environment;
- do not reuse a run identifier;
- do not merge evidence from different runs;
- preserve the original JSONL event order;
- retain the unmodified manifest and verification result.

Timing on a shared host may vary. Timing thresholds therefore represent bounded acceptance windows, not cycle-accurate guarantees.

## Security Rules

Do not place any of the following in this directory:

- protected runtime source code;
- production configuration;
- private registry credentials;
- signing keys;
- production tokens;
- customer data;
- participant-confidential material;
- internal design documents;
- unredacted packet captures.

Use the container registry's normal authentication mechanism for authorized private images.

Do not write registry credentials into Compose files, shell scripts, scenario files, evidence, or reports.

## Cleanup

The scenario runner removes lab containers and isolated networks when execution completes or fails.

Generated evidence remains in the run directory until explicitly removed by the operator.

Before deleting any run, preserve every artifact required by the applicable evaluation or retention policy.

## Public Boundary

This lab exists to make externally observable claims testable without publishing the mechanism that implements them.

It defines:

- how controlled stimuli are introduced;
- what evidence must be exported;
- how evidence is compared;
- which public invariants determine the verdict;
- where the participant and protected-runtime boundaries remain.

It intentionally does not define how the protected runtime satisfies those invariants.
