# VRP 14-Day Shadow Validation Sprint

## 1. Purpose

The VRP Shadow Validation Sprint is a bounded, no-cost, non-production technical evaluation.

Its purpose is to let a qualified participant test externally observable VRP continuity behavior before making a subscription decision.

The model is:

```text
test
→ collect evidence
→ verify acceptance criteria
→ make a commercial decision
```

The participant is not required to purchase a subscription before testing.

If the agreed technical acceptance criteria are satisfied, the participant may choose to continue under a separate paid subscription agreement.

If the criteria are not satisfied, or the participant decides not to continue, the Sprint ends without a subscription obligation.

## 2. Sprint Duration

The Sprint lasts 14 consecutive calendar days.

The evaluation clock starts only after the Sprint start gate has been completed.

The start gate requires:

- an identified participant organisation;
- authorised technical contacts;
- an approved evaluation environment;
- an agreed subject-image identity;
- an agreed invariant-contract version;
- locked acceptance criteria;
- confirmation of the non-production boundary;
- written confirmation of the Sprint start time.

Participant delays do not automatically extend the Sprint.

Any extension must be approved separately in writing.

## 3. Cost Boundary

The VRP Shadow Validation Sprint is provided at no subscription charge for the 14-day evaluation period.

The participant remains responsible for its own:

- personnel time;
- Docker host;
- cloud or local infrastructure;
- network costs;
- internal security review;
- legal review;
- evidence retention;
- operational support outside the declared Sprint scope.

The no-cost Sprint does not include:

- production usage rights;
- a production service-level agreement;
- unlimited engineering support;
- custom runtime development;
- protected source-code access;
- transfer of intellectual property;
- indefinite access to the evaluation image;
- automatic access to future runtime releases.

Any paid continuation requires a separate written agreement.

## 4. Shadow Boundary

“Shadow” means that the evaluation does not become the authoritative production path.

The Sprint must not:

- control production traffic;
- authorize production mutations;
- become a production dependency;
- replace an existing production recovery mechanism;
- receive unrestricted customer data;
- receive production secrets;
- receive production signing keys;
- create an undeclared operational dependency.

Permitted inputs are:

- synthetic traffic;
- test traffic;
- redacted traffic;
- participant-approved non-sensitive mirrors;
- controlled test events.

A participant requiring production traffic must complete a separate security, legal, operational, and commercial review.

## 5. Evaluation Architecture

The Sprint uses the public VRP Docker Continuity Evidence Lab:

```text
docker/continuity-lab/
```

The public harness provides:

- isolated logical paths;
- controlled fault injection;
- witness-event recording;
- subject-evidence capture;
- deterministic invariant verification;
- allowlisted report export.

The protected runtime is supplied separately as an authorised black-box adapter image.

The Sprint does not provide protected runtime source code.

## 6. Mandatory Scenarios

The Sprint contains four mandatory public scenarios.

| Scenario | Evaluation purpose |
|---|---|
| `wifi-to-mobile` | Observe continuity across primary-path loss while an alternate path remains available |
| `blackout-recovery` | Observe recovery after a bounded loss of all declared paths |
| `stale-authority` | Observe stale-authority rejection without a linked accepted mutation |
| `replay-attempt` | Observe replay rejection without duplicate accepted mutation |

Additional scenarios may be added only when:

- their scope is agreed before execution;
- their evidence boundary is defined;
- their acceptance criteria are versioned;
- they do not require disclosure of protected mechanisms;
- they can be completed within the remaining Sprint window.

## 7. Required Run Series

Each mandatory scenario should complete at least three independent evidence runs.

Each run must use:

- a unique run identifier;
- the same locked scenario snapshot;
- the same invariant-contract digest;
- the same subject-image digest;
- the same declared harness-image identities;
- a recorded execution environment.

A run is independent only when it has its own:

- containers;
- isolated networks;
- witness stream;
- subject stream;
- manifest;
- verification result;
- export package.

Evidence from separate runs must not be merged.

## 8. Run Outcomes

Each run produces one of three verdicts:

### PASS

Every required public invariant passed.

### FAIL

At least one required public invariant was contradicted.

### INCOMPLETE

The evidence was insufficient for a valid final decision.

An `INCOMPLETE` run may be repeated within the Sprint when time remains.

A `FAIL` run must not be deleted, hidden, or relabelled as infrastructure noise without evidence supporting that classification.

## 9. Rerun Rules

A rerun is comparable to the original run only when the following remain unchanged:

- scenario snapshot;
- invariant-contract digest;
- subject-image digest;
- harness-image identities;
- adapter-contract version;
- acceptance thresholds.

If any of these inputs change, the rerun begins a new evidence cohort.

The earlier result remains part of the Sprint record.

A corrected runtime image must use a new image digest.

A corrected scenario or contract must use a new version.

## 10. Fourteen-Day Sequence

### Days 1–2: Admission and Baseline

Objectives:

- verify the Docker environment;
- confirm image identities;
- confirm the participant boundary;
- lock scenario and contract versions;
- run infrastructure preflight;
- complete one baseline scenario run;
- confirm evidence can be exported safely.

Required output:

- environment evidence;
- image identity record;
- first valid run directory;
- confirmed evidence-retention location.

### Days 3–6: Mandatory Scenario Execution

Objectives:

- run all four mandatory scenarios;
- preserve every verdict;
- identify infrastructure and adapter-boundary issues;
- verify deterministic artifact handling;
- begin independent participant review.

Required output:

- at least one complete run for each mandatory scenario;
- manifest and verification result for every run;
- recorded deviation list.

### Days 7–10: Repetition and Shadow Observation

Objectives:

- repeat mandatory scenarios;
- test run-to-run consistency;
- perform approved shadow observation;
- distinguish deterministic failures from environmental failures;
- complete the required evidence series.

Required output:

- target of three independent runs per mandatory scenario;
- scenario-level result matrix;
- retained `PASS`, `FAIL`, and `INCOMPLETE` evidence.

### Days 11–12: Evidence Review

Objectives:

- verify artifact hashes;
- verify contract coverage;
- review failed and incomplete checks;
- confirm that protected material was not exported;
- confirm that result language remains bounded.

Required output:

- participant review notes;
- unresolved issue list;
- evidence-integrity decision;
- disclosure-boundary decision.

### Day 13: Final Permitted Reruns

Objectives:

- repeat only justified incomplete runs;
- confirm reproducibility of accepted runs;
- freeze the final evidence set.

A new image, scenario, or invariant contract introduced on Day 13 creates a new evidence cohort and does not erase earlier results.

### Day 14: Decision

The Sprint ends with one decision state:

- `TECHNICALLY_ACCEPTED`;
- `NOT_ACCEPTED`;
- `INCOMPLETE`;
- `WITHDRAWN`.

The decision must identify:

- participant;
- evaluation window;
- scenario versions;
- contract digest;
- subject-image digest;
- number of runs;
- run verdicts;
- unresolved deviations;
- next commercial action, if any.

## 11. Technical Acceptance

Technical acceptance is governed by:

```text
docs/evaluation/ACCEPTANCE_CRITERIA.md
```

A single successful demonstration is not sufficient.

Acceptance requires:

- complete mandatory scenario coverage;
- valid evidence integrity;
- stable run identity;
- required repeated results;
- no unresolved duplicate acceptance;
- no unresolved continuity-reference replacement;
- no missing required rejection verdict;
- no prohibited evidence disclosure;
- no unexplained contract deviation.

Technical acceptance does not automatically create a subscription.

## 12. Paid Continuation

If the Sprint reaches `TECHNICALLY_ACCEPTED`, the participant may choose to enter a paid subscription review.

Paid continuation requires a separate agreement defining:

- subscription scope;
- permitted environments;
- runtime delivery;
- support boundaries;
- security obligations;
- commercial terms;
- renewal and termination;
- production-readiness work;
- service-level commitments, if any.

There is no automatic conversion.

There is no automatic billing.

There is no subscription obligation unless the participant separately agrees to continue.

## 13. No-Continuation Outcome

If the Sprint reaches:

- `NOT_ACCEPTED`;
- `INCOMPLETE`;
- `WITHDRAWN`;

and no separate continuation agreement is executed, the evaluation ends.

The participant must then:

- stop the evaluation runtime;
- remove the authorised subject image as required;
- remove temporary credentials;
- remove run-specific containers and networks;
- preserve only evidence permitted by the evaluation terms;
- follow the agreed evidence-retention or deletion requirements.

The participant may retain the public repository.

The participant does not receive ownership of the protected runtime or its mechanisms.

## 14. Participant Responsibilities

The participant must provide:

- a supported Docker environment;
- authorised personnel;
- timely access to evaluation infrastructure;
- accurate environment information;
- sufficient storage for evidence;
- an approved data classification;
- protection of the supplied image;
- preservation of all run outcomes;
- timely review during the 14-day window.

The participant must not:

- publish the supplied subject image;
- transfer it to an unauthorised party;
- attempt to extract protected implementation material;
- mount the image filesystem for reverse engineering;
- attach unrestricted debugging or tracing tools;
- inject production secrets;
- omit failed evidence from the final review;
- represent the Sprint as production certification.

## 15. VRP Evaluation Responsibilities

The VRP evaluation side provides, within the agreed scope:

- the public validation harness;
- the public invariant contract;
- the authorised adapter boundary;
- the approved subject-image reference;
- technical execution instructions;
- clarification of public evidence semantics;
- review of final evidence packages.

The VRP evaluation side does not provide during the no-cost Sprint:

- protected source code;
- unrestricted runtime internals;
- participant-specific production integration;
- unlimited incident response;
- production operational ownership;
- guarantees beyond the written evaluation scope.

## 16. Evidence Deliverables

The Sprint evidence set contains:

```text
out/<run-id>/
├── input/
│   ├── scenario.yaml
│   ├── schedule.tsv
│   └── invariant-contract.json
├── witness/
│   ├── environment.json
│   └── events.jsonl
├── subject/
│   ├── subject-evidence.json
│   └── subject-events.jsonl
├── manifest.json
├── verification.json
└── report/
    ├── summary.md
    ├── export-manifest.json
    ├── package-SHA256SUMS
    └── exports/
```

The final Sprint decision package should include:

- scenario result matrix;
- accepted run identifiers;
- failed run identifiers;
- incomplete run identifiers;
- all unresolved deviations;
- contract and image digests;
- final decision state;
- subscription decision, if made.

## 17. Evidence Preservation

Evidence must be:

- retained without silent modification;
- stored under its original run identifier;
- protected from unauthorised write access;
- reviewed with its original contract snapshot;
- exported through the allowlisted exporter;
- linked to the subject-image identity used for that run.

A participant must not combine artifacts from different runs into one apparent run.

If an artifact changes after verification, the export must be rejected until the run is re-evaluated.

## 18. Stop Conditions

The Sprint must stop immediately if:

- protected runtime material appears in public evidence;
- production secrets are introduced;
- the Docker host is suspected of compromise;
- evidence tampering is detected;
- the subject image is transferred outside the approved boundary;
- production traffic becomes dependent on the evaluation runtime;
- reverse-engineering activity is detected;
- the agreed non-production boundary cannot be maintained.

After a stop condition:

1. stop the affected execution;
2. preserve existing evidence;
3. isolate the supplied image;
4. record the reason;
5. classify affected runs as `INCOMPLETE` or `FAIL`;
6. determine whether the Sprint can safely continue.

## 19. Security Boundary

The Sprint assumes:

- the Docker host is controlled;
- the Docker daemon is trusted;
- the supplied images are obtained through approved channels;
- digest-qualified references are used for controlled runs;
- the subject cannot access the harness control plane;
- the subject cannot modify witness evidence;
- the participant does not alter the verifier during the run series.

A compromised host invalidates the evidence generated on that host.

## 20. Intellectual-Property Boundary

The participant may inspect:

- public scenario definitions;
- public orchestration;
- public evidence formats;
- public invariant definitions;
- public verification behavior;
- exported reports.

The participant does not receive:

- protected runtime source code;
- internal authority calculations;
- private recovery algorithms;
- key-derivation internals;
- private packet-processing logic;
- internal replay-window structures;
- ownership of VRP intellectual property.

The evaluation is designed to make behavior testable without transferring the mechanism.

## 21. Communications Boundary

No party should publicly describe a Sprint result as universal proof or certification.

Permitted bounded language is:

> The supplied subject image returned the recorded verdict under the identified scenarios, contract digest, environment, and run series.

Publication of participant identity, private findings, or non-public evidence requires separate approval.

The public harness may be referenced without disclosing the protected evaluation image.

## 22. Relationship to an Enterprise Pilot

The Shadow Validation Sprint is an entry technical evaluation.

It is not a complete enterprise production Pilot.

A later enterprise Pilot may include:

- participant-specific integration;
- production-readiness analysis;
- security architecture review;
- real-network testing;
- extended-duration testing;
- operational procedures;
- support commitments;
- commercial milestones;
- contractual acceptance.

Completion of the no-cost Sprint does not guarantee admission to a later enterprise Pilot or production subscription.

## 23. Governing Documents

The Sprint should be read with:

- [VRP Docker Evidence Lab](./VRP_DOCKER_EVIDENCE_LAB.md)
- [Acceptance Criteria](./ACCEPTANCE_CRITERIA.md)
- [Participant Boundary](./PARTICIPANT_BOUNDARY.md)
- [Docker Continuity Lab README](../../docker/continuity-lab/README.md)

If an executed agreement conflicts with this public description, the executed agreement governs the participant-specific engagement.

## 24. Final Decision Rule

The Sprint is intentionally simple:

```text
If the evidence satisfies the locked acceptance criteria:
    the participant may choose a paid subscription review.

If the evidence does not satisfy the locked acceptance criteria:
    the evaluation ends without a subscription obligation.
```

The participant tests before purchasing.

The decision follows evidence, not promises.