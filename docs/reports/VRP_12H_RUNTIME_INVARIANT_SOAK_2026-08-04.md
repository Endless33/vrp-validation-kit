# VRP 12-Hour Runtime-Invariant Soak — Public Validation Report

**Result:** PASS  
**Validation ID:** VRP-PUBLIC-VAL-2026-08-04-12H-001  
**Protocol:** Veil Routing Protocol (VRP)  
**Execution date:** 4 August 2026  
**Environment:** Linux virtual machine in Google Cloud

## Summary

VRP completed a controlled 12-hour runtime-invariant soak validation.

The qualified validation suite ran continuously for 43,210 seconds and completed 1,713 full cycles without a recorded failed step.

## Results

| Metric | Result |
|---|---:|
| Configured duration | 43,200 seconds |
| Actual duration | 43,210 seconds |
| Completed cycles | 1,713 |
| Recorded events | 13,721 |
| Failed steps | 0 |
| SHA-256 evidence files checked | 17,170 |
| SHA-256 verification | PASS |
| Source-tree changes during execution | 0 |

## Validation Timeline

- Started: `2026-08-04T09:04:04Z`
- Finished: `2026-08-04T21:04:14Z`
- Completion reason: `completed_12_hour_validation`

## Preflight

Before the soak began, the following checks passed:

- complete Go test suite;
- Go Vet static analysis;
- complete default build;
- build and execution qualification for every included scenario.

## Repeated Validation Cycle

Each cycle executed:

1. Complete Go test suite
2. Continuity proof
3. Migration safety
4. NAT rebinding
5. Network-disorder handling
6. Blackout recovery
7. Replay protection
8. Epoch-authority validation

A cycle was counted only after every included step completed successfully.

## Evidence Integrity

The generated evidence set was verified using SHA-256.

A total of 17,170 evidence files were checked successfully. The tested source tree remained unchanged throughout the validation window.

## Scope

This report records a controlled engineering validation performed in the stated environment.

The PASS result applies only to the qualified scenarios included in this run.

It does not claim:

- independent third-party certification;
- validation across every platform or network topology;
- validation of private-runtime components outside the qualified suite;
- universal production readiness;
- immunity from every possible implementation or operational failure.

Production-readiness evaluation requires participant-specific deployment, security review, integration testing, threat modelling, and acceptance evidence under the VRP Pilot framework.

## Verdict

**VRP PASSED THE 12-HOUR RUNTIME-INVARIANT SOAK.**

The qualified suite completed 1,713 full cycles, recorded 13,721 validation events, produced zero failed steps, passed verification of 17,170 SHA-256 evidence files, and preserved the tested source tree throughout execution.

---

**Vitalijus Riabovas**  
Creator of the Veil Routing Protocol