# VRP Pilot Validation Model

## Purpose

The VRP Pilot is not a source-code review of the private runtime.

It is a controlled validation process designed to verify externally observable continuity, recovery, integrity, and failure-handling behavior without exposing protected implementation details.

## Validation Boundary

The participant may validate:

- transport migration behavior;
- continuity under path loss;
- blackout recovery;
- replay rejection;
- duplicate mutation rejection;
- evidence integrity;
- deterministic verdict generation;
- bounded runtime behavior.

The participant does not receive:

- private runtime source code;
- protected decision logic;
- authority internals;
- proprietary recovery algorithms;
- unrestricted access to core components.

## Pilot Flow

Environment preparation

→ Scenario execution

→ Failure injection

→ Evidence generation

→ Independent verification

→ Final verdict

## Expected Outputs

A Pilot run may produce:

- execution logs;
- signed or hashed evidence bundles;
- scenario verdicts;
- integrity verification results;
- engineering observations;
- Pilot completion report.

## Success Criteria

A Pilot is considered successful when:

- declared scenarios execute reproducibly;
- continuity behavior matches the contract;
- invalid or tampered evidence is rejected;
- recovery remains deterministic;
- no protected implementation detail is required for verification.

## Important

The validation kit is not the private runtime.

It is an external verification surface.

The private runtime remains isolated behind the Pilot boundary.