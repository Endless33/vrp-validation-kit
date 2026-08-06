# VRP Evaluation Participant Boundary

## 1. Purpose

This document defines the technical, operational, security, evidence, and intellectual-property boundary for participation in the VRP Docker evaluation and 14-day Shadow Validation Sprint.

The participant receives a controlled ability to evaluate externally observable behavior.

The participant does not receive unrestricted access to the protected VRP runtime or its implementation.

## 2. Boundary Principle

The evaluation boundary is:

```text
inspect the public contract
→ execute the authorised black-box subject
→ introduce declared public stimuli
→ observe public evidence
→ verify the result
```

The boundary is not:

```text
receive the protected runtime
→ extract its implementation
→ reconstruct its internal mechanisms
```

The participant may evaluate what the runtime demonstrates.

The participant may not acquire how the protected runtime implements that behavior.

## 3. Defined Components

### Public Harness

The public harness includes:

- Docker Compose topology;
- scenario configurations;
- runner scripts;
- evidence verifier;
- report exporter;
- invariant contract;
- public evaluation documentation.

### Protected Subject

The protected subject includes:

- the authorised black-box adapter image;
- protected runtime binaries;
- embedded runtime components;
- private runtime configuration;
- protected mechanisms contained in the supplied image.

### Participant Environment

The participant environment includes:

- Docker host;
- Docker daemon;
- local or cloud infrastructure;
- storage;
- participant-controlled network;
- participant personnel;
- participant security controls.

### Evidence Boundary

The evidence boundary includes only the public artifacts generated under:

```text
out/<run-id>/
```

### Evaluation Operator

The evaluation operator is the authorised person executing the declared scenarios and preserving evidence.

## 4. Participant Access

The participant may access:

- the public repository;
- public scenario definitions;
- public invariant definitions;
- public verification logic;
- public orchestration;
- public evidence schemas;
- generated public evidence;
- exported allowlisted reports;
- approved subject-image metadata;
- the authorised adapter commands.

The participant does not receive access to:

- protected runtime source code;
- private repositories;
- build systems for the protected runtime;
- source maps;
- debug symbols;
- private test fixtures;
- signing keys;
- key-derivation internals;
- internal authority calculations;
- private recovery algorithms;
- internal replay-window structures;
- proprietary state representations;
- protected packet-processing logic.

## 5. Permitted Evaluation Actions

The participant may:

- clone and inspect the public validation repository;
- review public Docker configuration;
- review public shell scripts;
- review public scenario files;
- review the public invariant contract;
- obtain an authorised subject image through the approved delivery channel;
- inspect non-sensitive container metadata required to verify image identity;
- execute the declared adapter commands;
- run the four mandatory scenarios;
- repeat scenarios under the accepted cohort rules;
- verify captured evidence;
- export allowlisted evidence reports;
- calculate independent artifact hashes;
- review `PASS`, `FAIL`, and `INCOMPLETE` results;
- create separate participant analysis notes;
- report reproducible defects through the approved communication channel.

Permitted actions must remain inside the declared non-production evaluation scope.

## 6. Authorised Adapter Commands

The default authorised interface is:

```text
/vrp-lab-adapter run
/vrp-lab-adapter health
/vrp-lab-adapter stimulus --kind stale-authority --event-id <event-id>
/vrp-lab-adapter stimulus --kind replay --event-id <event-id>
```

The participant may use a different adapter entrypoint only when it has been approved for that subject image.

The participant must not use `docker compose exec`, entrypoint replacement, or direct container execution to invoke undeclared commands inside the protected subject.

## 7. Prohibited Runtime Actions

Unless separately authorised in writing, the participant must not:

- export the protected image with `docker save`;
- copy protected binaries from the image or container;
- mount or extract protected image layers;
- unpack the protected container filesystem;
- replace the approved entrypoint;
- start an interactive shell inside the protected subject;
- attach a debugger;
- attach a disassembler or decompiler;
- attach `ptrace`;
- capture process memory;
- generate a core dump;
- inspect protected process memory through `/proc`;
- attach an unapproved profiler;
- trace protected system calls for implementation reconstruction;
- extract embedded constants or resources;
- bypass runtime integrity controls;
- modify the supplied image;
- create or distribute a derivative protected image;
- mirror the protected image to an unapproved registry;
- transfer the image to another organisation;
- execute the image outside the approved environment;
- attempt to recover private logic through side-channel analysis;
- attempt to reconstruct proprietary runtime mechanisms.

Public harness inspection does not grant permission to inspect protected image internals.

## 8. Technical Reality of Image Custody

A participant-controlled Docker host necessarily gives the host administrator substantial technical control.

Container isolation alone cannot make extraction physically impossible for a malicious host administrator.

The protected-image boundary therefore depends on:

- controlled image delivery;
- least-privilege registry access;
- contractual restrictions;
- authorised personnel;
- host-access controls;
- image-digest tracking;
- time-bounded access;
- post-evaluation removal;
- incident response;
- audit evidence where required.

The Docker lab reduces accidental exposure.

It does not replace participant trust, contractual protection, or controlled delivery.

## 9. Image Delivery Boundary

The subject image must be:

- delivered through an approved registry or transfer mechanism;
- identified by an immutable digest;
- accessible only to authorised participant personnel;
- pulled only to the approved evaluation host;
- used only during the approved evaluation window;
- removed according to the agreed offboarding procedure.

Registry credentials must:

- use least privilege;
- be time bounded where possible;
- be stored through the registry or platform authentication mechanism;
- never be written into the public repository;
- never be written into Compose files;
- never be written into scenario files;
- never be included in evidence;
- never be included in reports.

## 10. Host Boundary

The participant must provide a host that:

- supports Docker Engine and Docker Compose v2;
- is under participant administrative control;
- is isolated from unrelated untrusted workloads;
- has sufficient storage for evidence;
- has a stable system clock;
- can preserve run artifacts;
- can resolve and pull approved images;
- does not inject undeclared monitoring into the protected subject;
- does not automatically upload container contents to third parties.

The participant must identify:

- host ownership;
- host administrators;
- cloud provider, if applicable;
- operating-system family;
- architecture;
- Docker Engine version;
- Docker Compose version;
- security tooling that can inspect container memory or filesystems.

Unapproved endpoint, observability, backup, or security agents that inspect the protected subject must be disabled or explicitly reviewed before image delivery.

## 11. Docker Boundary

The public Compose topology does not grant containers:

- privileged mode;
- host networking;
- Docker socket access;
- host PID namespace access;
- host port publication;
- protected source-code mounts.

The participant must not modify the canonical topology to add:

- `/var/run/docker.sock`;
- host filesystem mounts;
- privileged capabilities;
- host networking;
- debugging devices;
- tracing interfaces;
- unrestricted outbound networks;
- undeclared shared volumes.

A modified topology creates a non-canonical cohort and may invalidate the evaluation.

## 12. Control-Plane Boundary

The harness control plane is reserved for:

- scenario execution;
- fault-engine configuration;
- witness recording.

The subject is not attached to the control plane.

The participant must not:

- give the subject access to the fault-engine API;
- mount scenario schedules into the subject;
- mount expected invariants into the subject;
- allow the subject to modify witness evidence;
- manually change path state without recording a witness event;
- change fault timing during a canonical run;
- inject unrecorded stimuli.

A run with an unrecorded control-plane modification is `INCOMPLETE` or `FAIL`, depending on the available evidence.

## 13. Data Boundary

The no-cost Shadow Validation Sprint permits:

- synthetic data;
- generated test operations;
- redacted non-sensitive samples;
- participant-approved test identifiers;
- opaque public correlation references.

The Sprint does not permit:

- unrestricted production traffic;
- customer payloads;
- personal data;
- payment data;
- health data;
- authentication secrets;
- production bearer tokens;
- private signing keys;
- production certificates;
- production database credentials;
- regulated data without separate approval.

The participant is responsible for classifying all evaluation inputs before execution.

## 14. Network Boundary

The Docker lab uses internal logical networks:

- `control-plane`;
- `relay-plane`;
- `origin-plane`;
- `wifi-plane`;
- `mobile-plane`.

No lab service publishes a host port.

The participant must not connect the protected subject directly to:

- production control planes;
- unrestricted public networks;
- production databases;
- production credential services;
- customer-facing endpoints;
- internal administrative networks.

Any additional network attachment requires separate written approval and creates a new evaluation boundary.

## 15. Evidence Boundary

The subject may write only:

```text
out/<run-id>/subject/
```

The participant-controlled harness writes:

```text
out/<run-id>/input/
out/<run-id>/witness/
out/<run-id>/manifest.json
```

The verifier writes:

```text
out/<run-id>/verification.json
```

The exporter writes:

```text
out/<run-id>/report/
```

The participant must not edit original evidence artifacts.

Participant comments must be stored as separate review notes.

## 16. Evidence That Must Not Be Exported

Subject evidence must not contain:

- source code;
- source paths;
- stack traces;
- process memory;
- raw protected packets;
- raw protected payloads;
- protected authority artifacts;
- protected replay artifacts;
- cryptographic keys;
- credentials;
- internal runtime state;
- proprietary decision traces;
- container logs;
- runtime binaries.

If prohibited material appears:

1. stop the run;
2. isolate the affected evidence;
3. do not export or publish it;
4. record the incident;
5. notify the authorised review contact;
6. determine whether the Sprint can continue.

## 17. Public Repository Boundary

The public repository may contain:

- public harness code;
- public contracts;
- public documentation;
- synthetic configurations;
- redacted example evidence.

The public repository must not contain:

- generated participant evidence;
- `out/` run directories;
- private image references;
- registry credentials;
- participant-confidential findings;
- protected runtime artifacts;
- protected logs;
- participant infrastructure identifiers.

Generated evaluation directories must not be committed to the public repository.

Before every public commit, the participant or maintainer should review:

```bash
git status --short
git diff --check
git diff --cached --name-only
```

An automated repository scanner must not be treated as a confidentiality boundary.

Anything committed to the public repository must be assumed to become permanently observable.

## 18. Evidence Integrity

The participant must preserve:

- original run identifiers;
- original scenario snapshots;
- original contract snapshots;
- original event ordering;
- original artifact hashes;
- original verification results;
- failed and incomplete runs;
- export-package digests.

The participant must not:

- merge artifacts from separate runs;
- remove failed events;
- reorder event streams;
- edit subject counters;
- replace witness events;
- regenerate a manifest after modifying evidence;
- describe an incomplete run as passed;
- omit a comparable failed run from the final cohort review.

Evidence tampering invalidates the affected cohort.

## 19. Participant Observation Rights

The participant may independently inspect:

- scenario timing;
- fault-engine requests;
- witness events;
- public subject events;
- manifest hashes;
- verifier output;
- archive checksums;
- Docker metadata recorded by the harness.

The participant may create its own observer outside the protected subject when:

- the observer does not inspect protected memory or image layers;
- the observer does not change scenario timing;
- the observer does not modify traffic;
- the observer does not receive protected material;
- its presence is recorded in environment notes.

## 20. Security Testing Boundary

### Permitted Without Additional Approval

The participant may:

- statically review the public repository;
- lint public YAML, JSON, Markdown, and shell files;
- review Compose security properties;
- validate public schemas;
- verify hashes independently;
- test the verifier with synthetic public evidence in a separate environment;
- test malformed public evidence against copied public tooling;
- scan public dependencies for known vulnerabilities.

### Requires Separate Approval

The participant must obtain approval before:

- fuzzing the protected adapter;
- applying resource-exhaustion attacks;
- performing timing or side-channel analysis;
- injecting undeclared packets;
- running an image vulnerability scanner against protected layers;
- attaching an eBPF observer to the protected process;
- enabling system-call tracing;
- changing container security options;
- extending the Sprint beyond declared scenarios.

### Prohibited

The participant must not:

- use security testing to extract protected logic;
- exfiltrate runtime artifacts;
- attack shared VRP infrastructure;
- attack registry infrastructure;
- bypass image-access controls;
- use the supplied image to test unrelated targets;
- publish unverified vulnerability claims containing protected material.

## 21. Personnel Boundary

Access to the protected subject must be limited to named personnel with a legitimate evaluation role.

Permitted roles may include:

- evaluation operator;
- security reviewer;
- infrastructure administrator;
- evidence reviewer;
- authorised decision maker.

The participant must not provide access to:

- unrelated teams;
- external contractors without approval;
- public testing groups;
- unauthorised researchers;
- other organisations;
- public CI runners;
- shared demonstration environments.

Personnel changes during the Sprint must be recorded.

## 22. Automation and CI Boundary

The public harness may be tested in participant CI.

The protected subject must not be placed in public or unapproved CI.

A CI environment using the protected subject must provide:

- private runners;
- controlled logs;
- protected registry credentials;
- restricted artifact retention;
- no public cache;
- no public image-layer export;
- approved administrators;
- approved cleanup behavior.

CI logs must not capture protected adapter output beyond the declared public evidence boundary.

## 23. Publication Boundary

The participant may publicly reference:

- the public repository;
- public documentation;
- public scenario names;
- the public invariant model;
- a mutually approved bounded result statement.

The participant must not publish without approval:

- the protected image reference;
- protected image metadata beyond approved digest references;
- participant-confidential evidence;
- internal findings;
- unredacted screenshots;
- protected runtime output;
- private communications;
- participant-specific commercial terms.

A result must not be described as universal certification.

## 24. Intellectual-Property Boundary

Participation does not transfer:

- ownership of VRP;
- ownership of the protected runtime;
- protocol authorship;
- source-code rights;
- rights to derivative protected implementations;
- rights to distribute the subject image;
- rights to reproduce internal mechanisms;
- patent rights;
- trademark rights.

The participant receives only the evaluation rights explicitly granted for the agreed period and environment.

Public validation logic does not place protected implementation logic into the public domain.

## 25. Incident Conditions

A boundary incident includes:

- protected material in public evidence;
- unauthorised image transfer;
- unauthorised personnel access;
- image-layer extraction;
- debugger or memory-capture attachment;
- registry credential exposure;
- evidence tampering;
- Docker host compromise;
- production data introduction;
- public disclosure outside the approved scope.

An incident must be recorded with:

- incident identifier;
- discovery time;
- affected host;
- affected image digest;
- affected run identifiers;
- personnel involved;
- evidence preserved;
- containment action;
- continuation decision.

## 26. Stop Conditions

Evaluation must stop immediately when:

- the protected-image boundary cannot be maintained;
- the host is suspected of compromise;
- production traffic depends on the subject;
- prohibited data is introduced;
- evidence integrity is lost;
- unauthorised extraction is detected;
- registry credentials are exposed;
- the participant cannot identify who accessed the image;
- an approved evaluation term expires.

Stopping the evaluation does not authorize deletion of incident evidence.

## 27. Offboarding

At the end of the Sprint, the participant must complete the applicable offboarding steps:

- stop all protected subject containers;
- remove run-specific Docker networks;
- remove temporary credentials;
- revoke registry access;
- remove the protected image according to the agreement;
- remove unauthorised copies or caches;
- preserve permitted evidence packages;
- isolate incident evidence, if any;
- confirm that production systems do not depend on the evaluation;
- record final access-removal time.

The public repository may remain installed.

Protected subject access does not continue automatically.

## 28. Retention Boundary

Retention rules must distinguish:

### Public Materials

The participant may retain public repository content under its applicable licence.

### Public Evidence

The participant may retain exported evidence according to the evaluation agreement and data policy.

### Protected Subject

The participant may retain the protected subject only for the authorised period.

### Credentials

Temporary credentials must be removed or revoked after the authorised period.

### Incident Evidence

Incident evidence must be preserved and handled under the applicable security process.

## 29. Subscription Boundary

Technical acceptance does not activate production rights.

A paid subscription requires a separate agreement covering:

- authorised environments;
- runtime delivery;
- production use;
- support;
- updates;
- security obligations;
- commercial terms;
- termination;
- evidence retention;
- service levels, if applicable.

If the participant does not enter a subscription, the no-cost evaluation ends without a subscription obligation.

## 30. Boundary Matrix

| Resource or action | Participant status |
|---|---|
| Read public repository | Permitted |
| Modify public harness locally | Permitted, but creates a non-canonical cohort unless reviewed |
| Run canonical scenarios | Permitted |
| Review public verifier | Permitted |
| Inspect public evidence | Permitted |
| Calculate independent hashes | Permitted |
| Inspect basic image metadata | Permitted |
| Execute declared adapter commands | Permitted |
| Use synthetic or redacted data | Permitted |
| Use protected subject in approved private CI | Approval required |
| Add a new network attachment | Approval required |
| Fuzz protected adapter | Approval required |
| Scan protected image layers | Approval required |
| Attach debugger or memory capture | Prohibited |
| Extract or export image layers | Prohibited |
| Copy protected binaries | Prohibited |
| Transfer image to another party | Prohibited |
| Commit generated evidence publicly | Prohibited |
| Introduce production secrets | Prohibited |
| Use subject as production authority | Prohibited |
| Modify or hide failed evidence | Prohibited |
| Publish protected findings without approval | Prohibited |

## 31. Relationship to Other Documents

This boundary should be read with:

- [VRP Docker Evidence Lab](./VRP_DOCKER_EVIDENCE_LAB.md)
- [Shadow Validation Sprint](./SHADOW_VALIDATION_SPRINT.md)
- [Acceptance Criteria](./ACCEPTANCE_CRITERIA.md)
- [Docker Continuity Lab README](../../docker/continuity-lab/README.md)
- [Public Invariant Contract](../../docker/continuity-lab/expected/invariant-contract.json)

Participant-specific agreements may impose stricter controls.

If an executed agreement conflicts with this public document, the executed agreement governs the participant-specific evaluation.

## 32. Final Boundary Invariant

The participant boundary is preserved only when all of the following remain true:

```text
public harness remains inspectable
protected runtime remains black-box
subject cannot control witness evidence
participant cannot redefine acceptance after execution
generated evidence contains no protected material
runtime access remains time-bounded
production rights require a separate agreement
```

The evaluation exposes behavior.

It does not transfer the mechanism.