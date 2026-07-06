VRP PILOT DEPLOYMENT GUIDE

Veil Routing Protocol
Continuity-First Runtime Architecture

Version: 1.0
Document Type: Public Pilot Guide
Prepared For: Pilot Partners / Technical Evaluation Teams
Prepared By: Vitalijus Riabovas
Project: VRP — Veil Routing Protocol
Contact: jumpingvpn@proton.me
Private Pilot Application: https://tally.so/r/ZjQLN0

Document Status: Pilot Evaluation Draft

────────────────────────────────────────

IMPORTANT NOTICE

This document describes the public pilot evaluation process for VRP.

It does not disclose protected core logic.

It does not disclose private runtime implementation details.

It does not disclose proprietary internal decision mechanisms.

The purpose of this document is to help technical teams evaluate observable runtime behavior, validation results, deployment requirements, expected pilot flow, and evidence outputs.

VRP evaluation is based on observable behavior, reproducible validation, and runtime evidence.

────────────────────────────────────────

TABLE OF CONTENTS

1. Executive Summary
2. Purpose of This Document
3. What VRP Is
4. What VRP Is Not
5. Pilot Scope
6. Pilot Evaluation Objectives
7. Core Runtime Principles
8. Continuity-First Architecture
9. Session Identity Model
10. Transport Independence
11. Authority Preservation
12. Replay Containment
13. Fail-Closed Runtime Behavior
14. Evidence-Oriented Validation
15. Protected Core Model
16. Public Adapter Model
17. Customer Responsibilities
18. Deployment Requirements
19. Supported Evaluation Environment
20. Local Pilot Harness
21. External Application Adapter
22. Basic Pilot Flow
23. Test Scenario 1 — Session Creation
24. Test Scenario 2 — Wi-Fi Loss
25. Test Scenario 3 — Internet Blackout
26. Test Scenario 4 — NAT Rebinding
27. Test Scenario 5 — Replay Rejection
28. Test Scenario 6 — Duplicate Mutation Rejection
29. Test Scenario 7 — Stale Authority Rejection
30. Test Scenario 8 — Recovery Timeline
31. Evidence Export
32. Logs and Observability
33. Health Checks
34. Security Boundaries
35. Redaction Policy
36. Claims Supported by Current Validation
37. Claims Not Yet Supported
38. Known Limitations
39. Pilot Acceptance Checklist
40. Contact and Next Steps

────────────────────────────────────────

1. EXECUTIVE SUMMARY

VRP — Veil Routing Protocol — is a continuity-first networking architecture focused on preserving session identity, execution correctness, and recovery integrity across unstable or changing network conditions.

Most traditional networked systems treat transport failure as a reason to reconnect, rebuild, re-authenticate, or restart execution flow.

VRP approaches the problem differently.

In VRP, transport is replaceable.

Session identity is preserved.

Failure is treated as a runtime state transition, not as automatic session death.

The pilot objective is not to prove that a network can avoid failure.

The pilot objective is to verify what remains correct when failure occurs.

Current validation work has tested VRP behavior under:

- Wi-Fi loss
- Internet blackout
- NAT rebinding
- Path migration
- Replay storms
- Packet delay
- Packet reordering
- Split-brain authority attempts
- Duplicate critical mutations
- Stale authority frames
- Invalid frame admission
- Deterministic recovery scenarios
- Adversarial invariant testing
- Fuzz-generated input validation

The current engineering verdict is:

PILOT_INTEGRATION_READY_WITH_LIMITATIONS

This means VRP is ready for deterministic local pilot evaluation through a controlled pilot harness and external adapter model.

It does not mean universal production deployment is complete.

It does not mean customer-specific deployment pipelines are finished.

It does not mean every external infrastructure condition has already been validated.

It means that technical teams can begin evaluating observable runtime behavior without accessing protected internal implementation details.

────────────────────────────────────────

2. PURPOSE OF THIS DOCUMENT

This document exists to help pilot partners understand:

- what VRP is designed to validate;
- what the pilot includes;
- what the pilot does not include;
- how the local evaluation flow works;
- which invariants are expected to hold;
- what evidence is produced;
- what information remains protected;
- what a successful pilot should demonstrate.

The document is intended for:

- CTOs
- engineering managers
- distributed systems engineers
- infrastructure engineers
- network engineers
- security engineers
- R&D teams
- pilot evaluation teams
- technical decision-makers

The document is not intended to expose VRP protected core internals.

Questions about protected runtime logic, proprietary mechanisms, implementation internals, reverse engineering, private algorithms, or internal state machine design are outside the scope of this public pilot guide.

────────────────────────────────────────

3. WHAT VRP IS

VRP is a continuity-first runtime architecture for unstable network conditions.

It is designed around the idea that execution correctness should not automatically collapse when transport connectivity changes.

VRP focuses on preserving logical continuity across transport instability.

Key ideas:

- Session identity must not be the same thing as transport path.
- Transport can disappear, change, degrade, or recover.
- Runtime state must remain protected against invalid mutation.
- Replay must be rejected.
- Duplicate logical mutations must not commit twice.
- Authority must remain monotonic.
- Recovery must be observable.
- Evidence must be exportable without exposing protected internals.

VRP is built for environments where network instability is not an exception, but an expected operating condition.

Examples of relevant environments:

- critical infrastructure
- hospitals
- industrial systems
- mobile networks
- edge networks
- multi-path systems
- unstable wireless environments
- distributed runtime systems
- transport migration scenarios
- environments where reconnect semantics are not enough

────────────────────────────────────────

4. WHAT VRP IS NOT

VRP is not a traditional VPN product.

VRP is not simply a tunnel.

VRP is not a UI layer for server selection.

VRP is not a reconnect helper.

VRP is not a replacement for every transport protocol.

VRP is not a claim that networks will never fail.

VRP is not a public disclosure of protected runtime internals.

VRP does not require pilot evaluators to access private core logic in order to validate observable behavior.

The purpose of VRP is not to hide failure.

The purpose of VRP is to control what failure is allowed to change.

────────────────────────────────────────

5. PILOT SCOPE

The public pilot scope focuses on observable runtime behavior.

The pilot may include:

- local runtime evaluation;
- deterministic pilot harness execution;
- external application adapter example;
- failure injection scenarios;
- evidence export;
- validation reports;
- replay rejection tests;
- duplicate mutation rejection tests;
- stale authority rejection tests;
- transport migration tests;
- blackout recovery tests;
- session continuity tests;
- basic integration readiness review.

The pilot does not include:

- protected core source code disclosure;
- proprietary runtime logic disclosure;
- internal algorithm walkthroughs;
- reverse engineering support;
- production SLA commitment;
- customer-specific production deployment unless separately agreed;
- unrestricted architecture extraction;
- private key material;
- license internals;
- protected decision mechanisms.

Pilot access is limited and reviewed manually.

Private Pilot Application:

https://tally.so/r/ZjQLN0

Technical Contact:

jumpingvpn@proton.me

────────────────────────────────────────

6. PILOT EVALUATION OBJECTIVES

The pilot should answer the following engineering questions:

1. Can session identity remain stable when transport changes?

2. Can a runtime preserve logical continuity after simulated Wi-Fi loss?

3. Can the system reject replayed frames?

4. Can duplicate logical mutations be prevented?

5. Can stale authority be rejected?

6. Can invalid frames be rejected before they mutate runtime state?

7. Can the runtime remain fail-closed during blackout conditions?

8. Can recovery be observed through deterministic evidence?

9. Can an external application interact with the public adapter without access to protected core logic?

10. Can a technical team validate behavior through reproducible local execution?

The pilot is successful only if observable behavior matches the expected invariants.

────────────────────────────────────────

7. CORE RUNTIME PRINCIPLES

VRP is built around a small set of runtime principles.

These principles define what must remain true even when the network becomes unstable.

Principle 1:

Session identity is not transport identity.

A session must not die simply because Wi-Fi disappears, a path changes, or NAT rebinding occurs.

Principle 2:

Transport is replaceable.

A runtime may observe different paths over time, but the logical session must remain bounded to its identity.

Principle 3:

Invalid input must not mutate canonical state.

Any invalid frame, replay, stale authority, corrupted payload, reused nonce, or mismatched session must be rejected before it changes runtime state.

Principle 4:

Authority must be monotonic.

Older authority must not overwrite newer authority.

Same-epoch authority conflicts must be rejected.

Principle 5:

Logical mutation must commit at most once.

Network retries, duplicated packets, replay attempts, and delayed frames must not create duplicate execution.

Principle 6:

Failure must be observable.

The runtime must produce evidence that describes what happened, what was rejected, what was preserved, and what recovered.

Principle 7:

Evidence must not leak protected internals.

Pilot evidence should expose outcomes, verdicts, and observable behavior — not private implementation mechanisms.

────────────────────────────────────────

8. CONTINUITY-FIRST ARCHITECTURE

Traditional network architecture often treats connectivity as the center of execution.

When connectivity fails, the application usually reconnects, rebuilds session context, retries operations, or replays work.

This creates risk.

The same logical operation may be repeated.

State may diverge.

A stale path may return.

A delayed packet may arrive late.

A duplicated request may commit twice.

VRP treats continuity as a runtime responsibility.

The runtime observes transport instability and decides whether execution continuity can be preserved without allowing invalid state mutation.

The core architectural separation is:

Session Identity
≠
Transport Path

This separation allows VRP to reason about continuity across changing transport conditions.

────────────────────────────────────────

9. SESSION IDENTITY MODEL

In VRP, the session is the logical identity anchor.

Transport paths may change.

Network addresses may change.

Connection state may degrade.

Packets may arrive late.

But the runtime must preserve the session identity unless a valid transition requires otherwise.

During pilot evaluation, the expected behavior is:

- a valid session is established;
- transport instability is introduced;
- the runtime observes the change;
- invalid frames are rejected;
- fallback path may be selected;
- session identity remains stable;
- recovery evidence is produced.

Expected verdict:

SESSION_IDENTITY_PRESERVED

────────────────────────────────────────

10. TRANSPORT INDEPENDENCE

Transport independence means that VRP does not treat a single path as the permanent owner of execution correctness.

A path can be:

- active;
- degraded;
- lost;
- delayed;
- replaced;
- recovered;
- rejected;
- stale.

The runtime should not confuse path recovery with execution authority.

A transport path may return after a delay.

That does not automatically mean it is allowed to mutate canonical runtime state.

Expected behavior:

- old delayed packets are rejected when stale;
- replayed frames are rejected;
- migration does not reset session identity;
- fallback path can continue execution if valid.

Expected verdict:

TRANSPORT_REPLACED_WITHOUT_SESSION_RESET

────────────────────────────────────────

11. AUTHORITY PRESERVATION

Authority preservation is one of the most important VRP runtime properties.

During unstable conditions, more than one path or node may appear to claim authority.

VRP must prevent split-brain behavior.

Expected behavior:

- authority epoch remains monotonic;
- stale authority cannot overwrite newer authority;
- same-epoch conflicts are rejected;
- delayed old authority does not become canonical;
- one canonical authority path remains valid.

Expected verdicts:

AUTHORITY_MONOTONIC
STALE_AUTHORITY_REJECTED
SPLIT_BRAIN_CONTAINED

────────────────────────────────────────

12. REPLAY CONTAINMENT

Replay is a critical failure mode in unstable networks.

Packets can be duplicated.

Operations can be retried.

Old frames can reappear.

Malicious or malformed inputs may attempt to reuse previous state.

VRP must reject replay attempts before they mutate state.

Replay containment may include:

- sequence validation;
- nonce validation;
- payload hash validation;
- mutation identity validation;
- session binding validation;
- authority epoch validation.

Expected verdict:

REPLAY_REJECTED

────────────────────────────────────────

13. FAIL-CLOSED RUNTIME BEHAVIOR

Fail-closed behavior means the runtime must reject unknown, invalid, ambiguous, or unsafe input by default.

During blackout or unstable conditions, the runtime must not guess.

It must not accept frames just because connectivity has returned.

It must not mutate state from uncertain input.

Expected behavior:

- unknown transition rejected;
- invalid frame rejected;
- stale path rejected;
- malformed input rejected;
- corrupted payload rejected;
- reused nonce rejected;
- no canonical state mutation occurs.

Expected verdict:

FAIL_CLOSED

────────────────────────────────────────

14. EVIDENCE-ORIENTED VALIDATION

VRP pilot evaluation depends on evidence.

The purpose of evidence is to show what happened without exposing protected internal logic.

Evidence may include:

- session preserved;
- replay rejected;
- duplicate mutation rejected;
- stale authority rejected;
- fallback path selected;
- blackout observed;
- recovery completed;
- final verdict;
- runtime validation status.

Evidence should not include:

- private keys;
- protected algorithms;
- internal challenge phrases;
- proprietary decision logic;
- customer secrets;
- license internals;
- implementation details that expose the protected core.

Expected verdict:

EVIDENCE_EXPORTED_REDACTED

────────────────────────────────────────

15. PROTECTED CORE MODEL

VRP is designed with a protected core model.

This means the protected runtime logic is not required for public evaluation.

External teams should be able to validate observable behavior through:

- public adapter;
- deterministic harness;
- local pilot scenario;
- evidence export;
- expected verdicts;
- validation reports.

The protected core remains private.

This protects intellectual property while still allowing technical evaluation.

The public pilot does not require trust in private claims.

It requires verification of observable behavior.

────────────────────────────────────────

16. PUBLIC ADAPTER MODEL

The public adapter model allows an external application to interact with VRP behavior without receiving protected core internals.

The adapter provides a boundary between:

External Application

and

VRP Runtime

The external application can submit logical operations.

The runtime can return deterministic verdicts.

The evidence layer can export outcome-oriented reports.

The application does not need direct access to protected runtime logic.

Expected flow:

External App
→ VRP Adapter
→ Runtime Validation
→ Verdict
→ Evidence Export

Expected verdict:

PUBLIC_ADAPTER_EVALUATION_READY

────────────────────────────────────────

17. CUSTOMER RESPONSIBILITIES

A pilot partner is expected to provide:

- technical contact;
- intended use case;
- deployment environment description;
- operating system details;
- network environment description;
- expected failure scenarios;
- security requirements;
- evaluation scope;
- feedback on missing scenarios;
- pilot timeline;
- approval for local testing conditions.

The pilot partner should not request:

- protected core source code;
- private algorithms;
- reverse engineering assistance;
- internal design extraction;
- proprietary implementation walkthroughs.

Pilot evaluation is based on observable behavior and reproducible evidence.

────────────────────────────────────────

18. DEPLOYMENT REQUIREMENTS

Initial local pilot evaluation may require:

- Linux or Windows environment;
- Go toolchain;
- Git;
- terminal access;
- ability to run local commands;
- ability to inspect generated evidence;
- optional VM environment;
- optional simulated unstable network conditions.

Recommended environment:

- Linux or Oracle Linux VM;
- Go installed;
- access to repository or pilot package;
- ability to run go test and demo binaries;
- ability to collect output logs.

Basic validation commands:

go fmt ./...
go vet ./...
go test ./...
go build ./...

Expected result:

PASS

Known limitation:

Production deployment requirements may differ from local pilot evaluation requirements.

────────────────────────────────────────

19. SUPPORTED EVALUATION ENVIRONMENT

Current validation has been performed in local and controlled environments.

Known validated categories:

- Go runtime build
- local deterministic tests
- adversarial invariant testing
- local pilot harness
- local end-to-end demo
- resilience simulation
- fuzz-generated inputs
- evidence export

Current pilot readiness verdict:

PILOT_INTEGRATION_READY_WITH_LIMITATIONS

This means:

- local pilot evaluation is supported;
- deterministic harness is available;
- public adapter example exists;
- evidence export exists;
- protected core remains isolated;
- customer-specific production deployment is not yet claimed.

────────────────────────────────────────

20. NEXT SECTION

The next section of this guide will cover:

- Local Pilot Harness
- External App Adapter
- Local End-to-End Demo
- Step-by-step pilot execution
- Expected command output
- Expected verdicts
- How to interpret failures
- How to prepare evidence for review

END OF PART 1

────────────────────────────────────────

21. LOCAL PILOT HARNESS

The Local Pilot Harness is the recommended entry point for evaluating VRP.

Its purpose is to allow engineering teams to observe runtime behavior under controlled conditions before integrating VRP into existing infrastructure.

The harness executes deterministic scenarios and produces reproducible evidence.

No protected runtime logic is exposed during execution.

Typical validation flow:

Initialize Runtime

↓

Create Session

↓

Inject Failure

↓

Observe Runtime

↓

Validate Invariants

↓

Generate Evidence

↓

Export Final Verdict

The harness is designed to answer one engineering question:

"Does observable runtime behavior remain correct under instability?"

────────────────────────────────────────

22. EXTERNAL APPLICATION ADAPTER

The public adapter demonstrates how an external application can communicate with the VRP runtime.

The adapter intentionally exposes only a minimal integration surface.

Observable interface:

Application

↓

Public Adapter

↓

Validation Layer

↓

Runtime

↓

Evidence Export

The adapter is intentionally designed so that external software never requires access to protected runtime implementation.

Observable behavior is sufficient for pilot evaluation.

Protected implementation remains isolated.

────────────────────────────────────────

23. LOCAL END-TO-END PILOT FLOW

The recommended evaluation sequence is:

STEP 1

Start the runtime.

Expected result:

Runtime initialized.

STEP 2

Create a logical session.

Expected result:

SESSION_CREATED

STEP 3

Transmit normal traffic.

Expected result:

Traffic accepted.

STEP 4

Introduce instability.

Examples:

• disable Wi-Fi
• disconnect transport
• simulate blackout
• inject delayed packets

Expected result:

Runtime enters controlled recovery.

STEP 5

Restore connectivity.

Expected result:

Recovery completes.

STEP 6

Review evidence.

Expected result:

Session identity preserved.

Replay rejected.

Authority preserved.

Evidence exported.

────────────────────────────────────────

24. TEST SCENARIO

SESSION CREATION

Objective

Verify that a runtime establishes a canonical logical session.

Expected observations

✓ Runtime starts

✓ Session created

✓ Initial authority assigned

✓ Validation successful

Expected verdict

SESSION_CREATED

────────────────────────────────────────

25. TEST SCENARIO

WI-FI LOSS

Objective

Verify continuity after transport disappearance.

Procedure

• establish session

• transmit traffic

• disconnect Wi-Fi

• continue runtime

Expected observations

✓ transport lost

✓ runtime remains active

✓ session identity preserved

✓ recovery begins

Expected verdict

SESSION_IDENTITY_PRESERVED

────────────────────────────────────────

26. TEST SCENARIO

INTERNET BLACKOUT

Objective

Validate runtime behavior during complete transport loss.

Procedure

Introduce complete transport interruption.

Expected observations

✓ transport unavailable

✓ runtime remains fail-closed

✓ invalid mutations rejected

✓ no duplicate execution

✓ recovery waits for valid transport

Expected verdict

FAIL_CLOSED

────────────────────────────────────────

27. TEST SCENARIO

NAT REBINDING

Objective

Validate runtime continuity after address change.

Expected observations

✓ transport identity changed

✓ logical session unchanged

✓ recovery successful

Expected verdict

TRANSPORT_CHANGED

SESSION_PRESERVED

────────────────────────────────────────

28. TEST SCENARIO

REPLAY ATTACK

Objective

Verify replay rejection.

Procedure

Replay previously accepted frame.

Expected observations

✓ replay detected

✓ replay rejected

✓ canonical state unchanged

Expected verdict

REPLAY_REJECTED

────────────────────────────────────────

29. TEST SCENARIO

STALE AUTHORITY

Objective

Verify stale authority rejection.

Procedure

Inject authority with older epoch.

Expected observations

✓ stale authority detected

✓ rejected

✓ canonical authority preserved

Expected verdict

STALE_AUTHORITY_REJECTED

────────────────────────────────────────

30. TEST SCENARIO

DUPLICATE LOGICAL MUTATION

Objective

Verify commit-once behavior.

Procedure

Submit duplicate logical operation.

Expected observations

✓ first mutation accepted

✓ duplicate rejected

✓ state unchanged

Expected verdict

CRITICAL_MUTATION_COMMIT_ONCE

────────────────────────────────────────

31. TEST SCENARIO

SPLIT-BRAIN

Objective

Verify authority conflict containment.

Procedure

Inject conflicting authority candidates.

Expected observations

✓ conflict detected

✓ canonical authority preserved

✓ invalid authority rejected

Expected verdict

SPLIT_BRAIN_CONTAINED

────────────────────────────────────────

32. TEST SCENARIO

PACKET REORDERING

Objective

Verify deterministic admission after packet disorder.

Expected observations

✓ packets reordered

✓ runtime accepts only valid sequence

✓ stale packets rejected

Expected verdict

ORDER_PRESERVED

────────────────────────────────────────

33. TEST SCENARIO

PACKET DELAY

Objective

Verify delayed packet handling.

Expected observations

✓ delayed packet received

✓ stale evaluation performed

✓ invalid packet rejected if necessary

Expected verdict

DELAY_HANDLED

────────────────────────────────────────

34. TEST SCENARIO

REPLAY STORM

Objective

Evaluate runtime behavior under massive replay attempts.

Expected observations

✓ replay attempts detected

✓ canonical state preserved

✓ no duplicate commits

✓ runtime stable

Expected verdict

REPLAY_STORM_REJECTED

────────────────────────────────────────

35. TEST SCENARIO

RUNTIME RECOVERY

Objective

Verify deterministic recovery.

Expected observations

ACTIVE

↓

TRANSPORT_LOST

↓

FAIL_CLOSED

↓

FALLBACK_SELECTED

↓

RECOVERY_COMPLETE

↓

SESSION_CONTINUES

Expected verdict

RECOVERY_SUCCESSFUL

────────────────────────────────────────

36. OBSERVABLE INVARIANTS

During evaluation the following invariants should remain true.

Invariant 1

Session identity remains stable.

Invariant 2

Transport changes do not redefine logical execution.

Invariant 3

Replay never mutates canonical state.

Invariant 4

Duplicate logical mutations never commit twice.

Invariant 5

Authority never rolls backward.

Invariant 6

Invalid input is rejected before state mutation.

Invariant 7

Recovery is deterministic.

Invariant 8

Evidence reflects observable runtime behavior.

────────────────────────────────────────

37. EXPECTED EVIDENCE

Successful execution should generate evidence similar to:

SESSION_IDENTITY_PRESERVED

TRANSPORT_REPLACED

REPLAY_REJECTED

STALE_AUTHORITY_REJECTED

FAIL_CLOSED

RECOVERY_COMPLETE

CANONICAL_STATE_PRESERVED

FINAL_VERDICT=SUCCESS

────────────────────────────────────────

38. FAILURE REPORTING

If unexpected behavior is observed, include:

• operating system

• Go version

• runtime logs

• evidence bundle

• command executed

• expected behavior

• observed behavior

• reproduction steps

This information allows deterministic analysis.

────────────────────────────────────────

39. PILOT ACCEPTANCE CRITERIA

A pilot evaluation is considered successful when:

✓ runtime initializes

✓ session is created

✓ continuity survives transport instability

✓ replay is rejected

✓ stale authority rejected

✓ duplicate mutation rejected

✓ fail-closed preserved

✓ deterministic recovery observed

✓ evidence exported

✓ observable behavior matches documented invariants

────────────────────────────────────────

40. NEXT STEPS

Organizations interested in continuing beyond local pilot evaluation may request a private pilot review.

Required information:

• organization

• engineering contact

• business email

• intended deployment

• expected scale

• evaluation objectives

Private Pilot Application

https://tally.so/r/ZjQLN0

Technical Contact

jumpingvpn@proton.me

The purpose of the pilot is not to ask participants to trust implementation claims.

The purpose is to allow engineering teams to verify observable runtime behavior through deterministic validation and reproducible evidence.

END OF PART 2