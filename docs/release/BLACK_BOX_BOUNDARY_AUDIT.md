# Black-Box Boundary Audit

## Purpose

The VRP Validation Kit is intentionally separated from the protected VRP runtime.

The public repository exists to validate observable behavior and evidence.

It is not a source distribution of the VRP runtime.

## Public boundary

The participant can observe:

- scenario configuration;
- externally scheduled faults;
- logical path availability;
- public continuity reference;
- public progress events;
- public mutation verdicts;
- recovery behavior;
- public evidence counters;
- verifier results;
- export manifests.

## Protected boundary

The public repository does not require disclosure of:

- private runtime source code;
- internal authority state;
- cryptographic secrets;
- private keys;
- bearer material;
- production credentials;
- raw protected packet payloads;
- internal runtime decision traces;
- private protocol mechanisms.

## Adapter model

The subject is supplied as an authorized black-box image through:

VRP_LAB_SUBJECT_IMAGE

The validation harness communicates through the declared public adapter interface.

The harness does not require source access to the protected implementation.

## Evidence policy

Public evidence is deliberately bounded.

The verifier rejects prohibited evidence fields associated with protected runtime material.

The result is:

PUBLIC BEHAVIOR: OBSERVABLE
PUBLIC EVIDENCE: VERIFIABLE
PRIVATE IMPLEMENTATION: NOT DISCLOSED