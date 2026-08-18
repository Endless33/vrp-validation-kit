# VRP Public Access Lifecycle

**Status:** Active  
**Final public-access boundary:** 31 December 2026, 23:59  
**Earlier closure:** Possible

---

## Purpose

VRP is currently in a limited public evaluation phase.

Selected repositories, validation tools, evidence, test reports, and engineering documentation are publicly accessible so independent engineers and organisations can examine the observable behavior of the project without requiring access to the protected VRP runtime.

This public phase is temporary.

It must not be interpreted as a permanent commitment to keep VRP technical material publicly accessible.

---

## Current State

At the time of publication, selected VRP evaluation resources remain public.

They may include:

- validation tooling;
- engineering evaluation tooling;
- Pilot documentation;
- reproducible test procedures;
- adversarial validation scenarios;
- evidence verification tooling;
- execution reports;
- cryptographic hashes;
- public protocol-boundary documentation.

Protected runtime internals are not part of the public evaluation surface.

Several VRP repositories and technical components have already been moved to private access.

The public-access reduction has therefore already started.

---

## What Can Happen Before 31 December 2026

Additional repositories, documents, binaries, examples, or technical material may be moved to private access before the final deadline.

There is no guarantee that every resource visible today will remain publicly accessible until 31 December.

Engineering work and additional validation may continue during this period.

New test results and evidence may also be published when development time permits.

Public today does not mean public permanently.

---

## Final Public Boundary

The current public-access phase has an absolute upper boundary:

**31 December 2026, 23:59**

The public phase may end earlier.

After closure, VRP should no longer be treated as a project that can necessarily be evaluated through unrestricted anonymous public access.

---

## After Public Closure

After the public phase ends, one or more of the following may occur:

- additional repositories become private;
- public technical documentation is reduced;
- public binaries are withdrawn;
- public evidence publication stops;
- development continues privately;
- development is temporarily suspended;
- VRP is archived as protected intellectual property;
- evaluation access becomes invitation-only.

No specific post-deadline access model is guaranteed.

---

## Invitation-Only Evaluation

A serious organisation may still request an evaluation after public closure.

If accepted, controlled access may be provided to selected evaluation resources.

Acceptance is not automatic.

The repository set, duration, conditions, binaries, documentation, and validation surface available at that time may differ from what is publicly accessible today.

Therefore:

**future invitation-only access should not be treated as equivalent to current public access.**

---

## What Changes for Evaluators

### During the public phase

An evaluator can independently:

1. inspect the available repositories;
2. clone the available tooling;
3. record the exact Git commit;
4. build the available validation components;
5. execute the tests;
6. reproduce supported scenarios;
7. inspect generated evidence;
8. verify hashes;
9. challenge the verifier;
10. preserve an independent record of the evaluation.

No permission from the VRP creator is required to inspect material that is currently public.

### After public closure

That assumption disappears.

Access may require:

- direct contact;
- qualification;
- explicit approval;
- controlled repository access;
- defined evaluation scope;
- additional confidentiality or intellectual-property boundaries.

Or access may simply not be offered.

---

## What You Risk Losing by Waiting

Waiting does not invalidate VRP.

It changes your access to it.

A team that postpones evaluation may lose:

- immediate public repository access;
- anonymous self-service evaluation;
- the ability to reproduce the current public state directly;
- access to particular documentation or binaries;
- the current evaluation workflow;
- the current Pilot model;
- the ability to evaluate without first requesting permission.

The technical question can be investigated now.

There is no engineering advantage in postponing a reproducible test merely because nobody else has performed it first.

---

## Engineering Principle

VRP does not ask evaluators to accept a marketing claim.

The intended process is:

**inspect → execute → mutate → verify → decide**

If the implementation fails under a supported test, record the failure.

If the verifier accepts invalid evidence, preserve the mutation and demonstrate it.

If continuity breaks under a reproducible scenario, document the conditions.

That evidence is more valuable than either belief or skepticism.

---

## Final Notice

The public evaluation window exists now.

It is finite.

**31 December 2026 is the maximum public-access boundary.**

Closure may occur earlier.

Do not assume that material available today will still be publicly accessible when you eventually decide to investigate it.