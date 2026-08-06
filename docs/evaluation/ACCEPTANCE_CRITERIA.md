# VRP Docker Evaluation Acceptance Criteria

## 1. Purpose

This document defines the technical acceptance criteria for the public VRP Docker Continuity Evidence Lab and the 14-day Shadow Validation Sprint.

Acceptance is based on recorded evidence.

It is not based on:

- a live demonstration without retained artifacts;
- a subject-generated success statement;
- screenshots;
- console output alone;
- an unverified report;
- an informal engineering opinion;
- a marketing claim.

The acceptance decision is bound to a specific evaluation cohort.

## 2. Evaluation Levels

The evaluation has four distinct levels.

### 2.1 Execution Completion

The scenario runner completed and captured the required artifacts.

Execution completion is represented by:

```text
RUN_STATE=COMPLETE
```

This does not mean that the scenario passed.

### 2.2 Run Verdict

The deterministic verifier evaluated one run and returned:

- `PASS`;
- `FAIL`;
- `INCOMPLETE`.

### 2.3 Scenario-Series Decision

Multiple comparable runs of one scenario are evaluated together.

A single `PASS` run is not sufficient for scenario-series acceptance.

### 2.4 Sprint Decision

The four mandatory scenario series are evaluated together to produce:

- `TECHNICALLY_ACCEPTED`;
- `NOT_ACCEPTED`;
- `INCOMPLETE`;
- `WITHDRAWN`.

Technical acceptance does not automatically create a commercial subscription.

## 3. Definitions

### Evaluation Cohort

An evaluation cohort is a set of runs sharing the same:

- subject-image digest;
- scenario snapshot;
- invariant-contract digest;
- adapter-contract version;
- harness-image identities;
- declared acceptance thresholds.

### Comparable Run

A run is comparable only when it belongs to the same evaluation cohort.

### Independent Run

An independent run has its own:

- run identifier;
- Docker project;
- isolated networks;
- subject container;
- witness stream;
- subject stream;
- manifest;
- verification result;
- export package.

### Material Change

A material change includes:

- a new subject-image digest;
- a changed scenario;
- a changed invariant contract;
- a changed acceptance threshold;
- a changed adapter evidence format;
- a changed verifier;
- a changed fault schedule;
- a changed public event meaning.

A material change creates a new evaluation cohort.

### Accepted Cohort

An accepted cohort is a comparable run set satisfying every mandatory run-series criterion in this document.

## 4. Locked Inputs

Before an accepted run series begins, the following inputs must be locked:

| Input | Required identity |
|---|---|
| Subject image | Immutable content digest |
| Scenario | SHA-256 of the captured YAML |
| Schedule | SHA-256 of the normalized schedule |
| Invariant contract | Version and SHA-256 |
| Adapter contract | Public contract version |
| Origin image | Image digest |
| Fault-engine image | Image digest |
| Relay image | Image digest |
| Controller image | Image digest |
| Parser images | Image digests for controlled evaluation |

For controlled evaluation, set:

```bash
export VRP_LAB_REQUIRE_DIGEST=1
```

A tag without an immutable digest is insufficient for final technical acceptance.

## 5. Mandatory Global Invariants

Every accepted run must return `PASS` for:

| Invariant | Requirement |
|---|---|
| `VRP-LAB-ARTIFACT-HASHES-MATCH` | Every manifest-bound artifact matches its recorded SHA-256 |
| `VRP-LAB-SCHEMA-COMPATIBLE` | Every public artifact uses a supported schema |
| `VRP-LAB-PROHIBITED-FIELDS-ABSENT` | Subject evidence contains no prohibited protected material |
| `VRP-LAB-EVIDENCE-COUNTERS-CONSISTENT` | Summary counters match the public event stream |
| `VRP-LAB-CONTRACT-COVERAGE` | Every required invariant has one supported evaluator |
| `VRP-LAB-EVIDENCE-COMPLETE` | The required evidence set is complete |
| `VRP-LAB-RUN-ID-CONSISTENT` | Every evidence layer identifies the same run |
| `VRP-LAB-EVENT-SEQUENCE-MONOTONIC` | Event sequences contain no gap, rollback, or duplicate |
| `VRP-LAB-EVENT-ID-UNIQUE` | Event identifiers are unique within each stream |
| `VRP-LAB-NO-DUPLICATE-ACCEPTANCE` | No public operation reference has duplicate accepted mutation |

A run cannot be accepted when any mandatory global invariant is `FAIL` or `INCOMPLETE`.

## 6. Run-Level Acceptance

A run is accepted only when all of the following are true:

1. The runner completed with exit code `0`.
2. `manifest.json` reports `execution_state` as `COMPLETE`.
3. The subject exited with code `0`.
4. Required subject artifacts are present.
5. The verifier completed successfully.
6. `verification.json` reports `PASS`.
7. Every globally required invariant reports `PASS`.
8. Every scenario-required invariant reports `PASS`.
9. The verification manifest digest matches the current manifest.
10. The verification contract digest matches the captured contract.
11. The allowlisted exporter completes successfully.
12. The exported archive digest is retained.

The only authoritative run verdict is:

```text
verification.json → verdict
```

A runner exit code of `0` is not an acceptance verdict.

## 7. Scenario-Series Acceptance

Each mandatory scenario requires at least:

```text
3 independent PASS runs
```

All accepted runs in a scenario series must belong to the same evaluation cohort.

The accepted cohort must contain:

- at least three `PASS` runs;
- zero `FAIL` runs;
- zero unresolved `INCOMPLETE` runs;
- no missing run artifacts;
- no evidence-integrity deviation;
- no prohibited disclosure event.

An `INCOMPLETE` run may be replaced by a complete rerun only when:

- the reason is recorded;
- the reason is not a contradicted runtime invariant;
- the replacement run uses the same locked inputs;
- the original incomplete evidence remains retained.

A `FAIL` run cannot be removed from an unchanged cohort by repeating the scenario until it passes.

If the subject is corrected after a `FAIL`, the corrected image must have a new digest and must begin a new cohort.

The failed cohort remains part of the Sprint record.

## 8. Wi-Fi-to-Mobile Acceptance

Scenario:

```text
configs/wifi-to-mobile.yaml
```

The scenario is accepted when every run in the accepted cohort satisfies all global invariants and the following conditions.

### Baseline

Before the primary path is disabled:

- both logical paths are initially reachable;
- the origin is reachable;
- the subject is ready;
- at least five successful public progress events are recorded.

### Fault

At scenario offset 15 seconds:

- the harness disables the `wifi` logical path;
- the disable action is confirmed by witness evidence;
- the `mobile` logical path remains enabled;
- the controlled origin remains available.

### Transition

After the witnessed primary-path failure:

- at least one public path-transition event identifies `mobile`;
- the final active path is `mobile`;
- the public continuity reference remains unchanged;
- no duplicate accepted mutation is recorded.

### Recovery Bound

After the primary-path fault:

- the first successful public progress event occurs within 12 seconds;
- at least five successful progress events are recorded before run completion.

### Required Scenario Invariants

- `VRP-LAB-CONTINUITY-REFERENCE-STABLE`;
- `VRP-LAB-PATH-TRANSITION-OBSERVED`;
- `VRP-LAB-PROGRESS-RESUMED`;
- `VRP-LAB-NO-DUPLICATE-ACCEPTANCE`.

Any unexpected continuity-reference replacement is `FAIL`.

## 9. Blackout-Recovery Acceptance

Scenario:

```text
configs/blackout-recovery.yaml
```

### Baseline

Before the blackout:

- both logical paths are reachable;
- the origin is reachable;
- the subject is ready;
- at least five successful public progress events are recorded.

### Blackout

At scenario offset 15 seconds:

- the harness disables both logical paths;
- witness evidence records both path-disable events;
- witness evidence records `blackout.started`;
- the origin remains available behind the path boundary.

The expected blackout duration is:

```text
15 seconds ± 2 seconds
```

After a two-second settling grace period:

- no successful public progress event may be recorded before path restoration.

A false successful-progress event during the stable blackout interval is `FAIL`.

### Restoration

At scenario offset 30 seconds:

- the harness restores the `mobile` logical path;
- the restore action is confirmed;
- witness evidence records `blackout.ended`.

### Recovery

After restoration:

- the first successful public progress event occurs within 15 seconds;
- at least five successful public progress events are recorded;
- the final active path is `mobile`;
- the public continuity reference remains unchanged;
- no duplicate accepted mutation is recorded.

### Required Scenario Invariants

- `VRP-LAB-CONTINUITY-REFERENCE-STABLE`;
- `VRP-LAB-BLACKOUT-OBSERVED`;
- `VRP-LAB-RECOVERY-OBSERVED`;
- `VRP-LAB-PROGRESS-RESUMED`;
- `VRP-LAB-NO-DUPLICATE-ACCEPTANCE`.

Recovery with a new public continuity reference is `FAIL`.

## 10. Stale-Authority Acceptance

Scenario:

```text
configs/stale-authority.yaml
```

### Baseline

Before stimulus delivery:

- both logical paths remain reachable;
- the subject is ready;
- at least five successful public progress events are recorded;
- one stable public continuity reference is observed.

### Stimulus Delivery

At scenario offset 15 seconds:

- the harness records `stimulus.stale-authority.requested`;
- the public adapter receives one `stale-authority` stimulus;
- the harness records `stimulus.stale-authority.delivered`;
- the protected authority artifact remains inside the black-box boundary.

### Rejection

Within 10 seconds of the witnessed request:

- exactly one linked subject stimulus-verdict event is recorded;
- the verdict is `rejected-stale-authority`;
- the subject summary records one stale-authority rejection;
- no accepted mutation references the stimulus witness identifier.

### Post-Rejection Progress

After rejection:

- at least five successful public progress events are recorded;
- the public continuity reference remains unchanged;
- no unplanned path transition is recorded;
- no duplicate accepted mutation is recorded.

### Required Scenario Invariants

- `VRP-LAB-CONTINUITY-REFERENCE-STABLE`;
- `VRP-LAB-STALE-AUTHORITY-REJECTED`;
- `VRP-LAB-REJECTED-STIMULUS-NO-MUTATION`;
- `VRP-LAB-PROGRESS-PRESERVED`;
- `VRP-LAB-NO-DUPLICATE-ACCEPTANCE`.

A stale-authority stimulus linked to an accepted mutation is `FAIL`.

## 11. Replay-Attempt Acceptance

Scenario:

```text
configs/replay-attempt.yaml
```

### Baseline

Before replay delivery:

- both logical paths remain reachable;
- the subject is ready;
- at least five successful public progress events are recorded;
- exactly one original accepted mutation is available through an opaque public operation reference.

### Replay Relationship

The replay verdict must expose the same opaque public operation reference as the original accepted mutation.

The protected operation artifact must not be exported.

The original accepted mutation must occur before the replay request.

### Stimulus Delivery

At scenario offset 15 seconds:

- the harness records `stimulus.replay.requested`;
- the public adapter receives one `replay` stimulus;
- the harness records `stimulus.replay.delivered`.

### Rejection

Within 10 seconds of the witnessed request:

- exactly one linked subject stimulus-verdict event is recorded;
- the verdict is `rejected-replay`;
- the subject summary records one replay rejection.

### Duplicate-Mutation Rule

For the replayed public operation reference:

- total accepted-mutation count must remain exactly one;
- additional accepted-mutation count caused by replay must remain zero;
- no accepted mutation may reference the replay witness identifier;
- `duplicate_accepted_mutation_count` must remain zero.

### Post-Rejection Progress

After rejection:

- at least five successful public progress events are recorded;
- the public continuity reference remains unchanged;
- no unplanned path transition is recorded.

### Required Scenario Invariants

- `VRP-LAB-CONTINUITY-REFERENCE-STABLE`;
- `VRP-LAB-REPLAY-SOURCE-OBSERVED`;
- `VRP-LAB-REPLAY-REJECTED`;
- `VRP-LAB-REPLAY-NO-DUPLICATE-MUTATION`;
- `VRP-LAB-PROGRESS-PRESERVED`;
- `VRP-LAB-NO-DUPLICATE-ACCEPTANCE`.

Any second accepted mutation for the replayed operation is `FAIL`.

## 12. Evidence-Export Acceptance

A run is eligible for report export only when these checks are `PASS`:

- `VRP-LAB-ARTIFACT-HASHES-MATCH`;
- `VRP-LAB-SCHEMA-COMPATIBLE`;
- `VRP-LAB-PROHIBITED-FIELDS-ABSENT`;
- `VRP-LAB-RUN-ID-CONSISTENT`.

This export rule applies even when the behavioral verdict is `FAIL`.

A behavioral failure may be exported for review when its evidence remains structurally valid and disclosure-safe.

Export must be refused when:

- artifact hashes do not match;
- subject evidence contains prohibited fields;
- run identifiers contradict each other;
- schema compatibility is not established;
- an artifact changed after verification;
- an unexpected symlink is detected;
- an expected artifact exceeds its public size limit.

## 13. Prohibited Evidence

Technical acceptance is impossible if exported subject evidence contains:

- private keys;
- secrets;
- credentials;
- bearer material;
- protected tokens;
- raw protected packets;
- raw protected payloads;
- protected authority artifacts;
- protected replay artifacts;
- internal runtime state;
- stack traces;
- internal source paths;
- proprietary decision traces;
- runtime binaries;
- container logs containing protected material.

Detection of prohibited material requires:

1. immediate stop;
2. evidence isolation;
3. export refusal;
4. incident recording;
5. boundary review.

A behavioral `PASS` cannot override a disclosure-boundary failure.

## 14. FAIL Classification

A run is `FAIL` when complete evidence establishes any required contradiction.

Examples include:

- artifact digest mismatch;
- inconsistent run identifiers;
- event-sequence rollback or duplication;
- duplicate event identifiers;
- summary counters contradicting events;
- multiple public continuity references;
- missing required path transition;
- recovery outside the declared bound;
- false successful progress during stable blackout;
- stale-authority acceptance;
- accepted mutation linked to stale authority;
- replay acceptance;
- duplicate accepted replay mutation;
- prohibited evidence disclosure.

A `FAIL` must remain visible in the Sprint evidence record.

## 15. INCOMPLETE Classification

A run is `INCOMPLETE` when no valid final decision can be made.

Examples include:

- infrastructure did not become ready;
- subject did not become ready;
- stimulus was not delivered;
- required artifact is missing;
- event stream is empty or truncated;
- schema is unsupported;
- required invariant has no evaluator;
- Docker host integrity is uncertain;
- execution was interrupted;
- evidence storage failed;
- the subject image identity cannot be established.

An `INCOMPLETE` result is not a `PASS`.

It is also not automatically a runtime failure.

## 16. Infrastructure Failure Versus Runtime Failure

An issue may be classified as infrastructure-related only when evidence establishes that the subject did not receive the declared test condition.

Examples include:

- fault-engine control API unavailable;
- Docker network creation failed;
- origin never became reachable;
- controller container could not start;
- storage became unavailable before subject execution;
- the Docker daemon terminated the run.

If the infrastructure is healthy and the subject:

- exits unexpectedly;
- fails to recover;
- changes continuity reference;
- accepts a stale stimulus;
- accepts a replay;
- produces contradictory evidence;

the result is `FAIL`.

“Environment issue” is not a valid classification without evidence.

## 17. Sprint-Level Technical Acceptance

The Sprint reaches `TECHNICALLY_ACCEPTED` only when:

1. all four mandatory scenarios have accepted cohorts;
2. each scenario has at least three independent `PASS` runs;
3. at least 12 mandatory `PASS` runs exist in total;
4. all accepted runs use the same subject-image digest;
5. all accepted runs use the locked contract version and digest;
6. all accepted runs use the applicable locked scenario snapshots;
7. no accepted cohort contains a `FAIL`;
8. no unresolved `INCOMPLETE` run remains;
9. no unresolved prohibited disclosure exists;
10. no evidence-integrity deviation remains;
11. all export packages have retained SHA-256 digests;
12. participant and VRP reviewers complete the final evidence matrix.

Technical acceptance means the evaluated image satisfied the declared public criteria for the recorded run series.

It does not mean production readiness.

## 18. NOT_ACCEPTED Decision

The Sprint reaches `NOT_ACCEPTED` when the final candidate cohort contains a required invariant `FAIL` that is not corrected through a new subject-image cohort before the Sprint ends.

Examples include:

- continuity-reference replacement;
- duplicate accepted mutation;
- stale-authority acceptance;
- replay acceptance;
- repeated recovery-bound violation;
- contradictory evidence counters;
- evidence tampering;
- prohibited disclosure.

`NOT_ACCEPTED` ends the no-cost evaluation unless both parties separately agree to a new evaluation.

It creates no subscription obligation.

## 19. INCOMPLETE Sprint Decision

The Sprint reaches `INCOMPLETE` when:

- no final candidate cohort contains a confirmed required contradiction;
- but mandatory coverage or valid repeated evidence is missing.

Examples include:

- fewer than three valid runs for one or more scenarios;
- unresolved infrastructure failures;
- missing export packages;
- unsupported participant environment;
- insufficient time to evaluate a corrected image;
- incomplete security review.

An incomplete Sprint does not automatically extend beyond Day 14.

## 20. WITHDRAWN Decision

The Sprint reaches `WITHDRAWN` when:

- the participant chooses to stop;
- the VRP evaluation side stops for a boundary violation;
- the environment cannot remain non-production;
- the supplied image cannot remain protected;
- either party declines to continue the evaluation.

Withdrawal creates no automatic subscription obligation.

## 21. Remediation and New Cohorts

A runtime correction requires:

- a new subject-image digest;
- a recorded change summary at the public boundary;
- a new cohort identifier;
- new runs for every scenario affected by the correction.

A scenario correction requires:

- a new scenario version or digest;
- review of affected acceptance thresholds;
- new comparable runs.

A verifier or invariant-contract correction requires:

- a new contract or verifier version;
- re-verification under the new cohort;
- preservation of the original result.

Old failed evidence must not be deleted.

## 22. Non-Waivable Criteria

The following criteria cannot be waived for technical acceptance:

- artifact integrity;
- run-identifier consistency;
- prohibited-material exclusion;
- continuity-reference stability where required;
- absence of duplicate accepted mutation;
- stale-authority rejection;
- replay rejection;
- complete mandatory scenario coverage;
- supported invariant-contract coverage.

A commercial preference cannot convert a technical `FAIL` into `PASS`.

## 23. Deviations

Every deviation must record:

- deviation identifier;
- affected run identifiers;
- discovery time;
- affected component;
- evidence supporting classification;
- material or non-material status;
- resolution;
- reviewer decision.

A non-material deviation may be accepted only when it does not change:

- the subject behavior under evaluation;
- fault timing;
- invariant semantics;
- evidence meaning;
- image identity;
- verdict calculation.

A material deviation creates a new cohort.

## 24. Subscription Eligibility

`TECHNICALLY_ACCEPTED` makes the participant eligible for a paid subscription review.

It does not:

- activate a subscription;
- create an invoice;
- authorize production use;
- create an SLA;
- transfer runtime ownership;
- transfer intellectual property;
- guarantee commercial approval.

Paid continuation requires a separate written agreement.

If the participant does not continue, the Sprint ends without a subscription obligation.

## 25. Decision Record

The final decision should use this structure:

```text
SPRINT_DECISION:
  participant:
  evaluation_start_utc:
  evaluation_end_utc:
  subject_image_digest:
  invariant_contract_version:
  invariant_contract_sha256:
  adapter_contract_version:

  wifi_to_mobile:
    cohort_id:
    pass_runs:
    fail_runs:
    incomplete_runs:
    decision:

  blackout_recovery:
    cohort_id:
    pass_runs:
    fail_runs:
    incomplete_runs:
    decision:

  stale_authority:
    cohort_id:
    pass_runs:
    fail_runs:
    incomplete_runs:
    decision:

  replay_attempt:
    cohort_id:
    pass_runs:
    fail_runs:
    incomplete_runs:
    decision:

  unresolved_deviations:
  disclosure_boundary:
  evidence_integrity:
  final_state:
  subscription_review_requested:
  participant_reviewer:
  vrp_reviewer:
  decided_at_utc:
```

## 26. Result Language

Correct bounded language:

> Subject image `<digest>` satisfied the VRP Docker evaluation acceptance criteria across the recorded mandatory run series under contract `<digest>`.

Incorrect language:

> Every VRP deployment is proven to work under every failure condition.

Acceptance applies only to the recorded cohort.

## 27. Governing Technical Files

The acceptance decision uses:

- [VRP Docker Evidence Lab](./VRP_DOCKER_EVIDENCE_LAB.md)
- [Shadow Validation Sprint](./SHADOW_VALIDATION_SPRINT.md)
- [Participant Boundary](./PARTICIPANT_BOUNDARY.md)
- [Docker Lab README](../../docker/continuity-lab/README.md)
- [Public Invariant Contract](../../docker/continuity-lab/expected/invariant-contract.json)

The captured scenario and contract snapshots remain authoritative for each historical run.

## 28. Final Rule

The technical decision is deterministic:

```text
if every mandatory scenario has an accepted cohort:
    TECHNICALLY_ACCEPTED
elif any final candidate cohort has a required FAIL:
    NOT_ACCEPTED
elif the evaluation is voluntarily stopped:
    WITHDRAWN
else:
    INCOMPLETE
```

The participant tests first.

The evidence determines the technical result.

The participant then decides whether to enter a paid subscription.
