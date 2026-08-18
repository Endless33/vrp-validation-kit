# Validation Fix History — 2026-08-15

## Objective

Close the remaining gaps preventing deterministic public validation of the blackout-recovery scenario.

## Fixes completed

### Subject lifecycle synchronization

The blackout-recovery subject was changed to synchronize against explicit public blackout boundaries rather than assuming timing internally.

Public synchronization boundaries:

- blackout-start
- blackout-end

No protected runtime state is transferred through these markers.

### Blackout-end delivery

A control-flow defect was identified in the scenario runner.

The blackout-recovery configuration restores a single logical path using:

path.enable

The runner previously delivered the blackout-end subject stimulus only from the multi-path enable branch.

The path.enable branch was corrected to deliver the public blackout-end synchronization event.

Result:

RUN_STATE=COMPLETE

### Subject evidence finalization

Stimulus commands no longer prematurely finalize subject evidence.

Evidence finalization remains owned by the primary subject execution lifecycle.

### Subject lifetime handling

The subject remains alive for the declared evaluation lifecycle and exits cleanly when terminated by the harness.

### Evidence counter consistency

The subject evidence correctly reported:

successful_progress_event_count=10
path_transition_count=1
accepted_mutation_count=1

### Transition verification semantics

The verifier previously required a dedicated:

event_kind=path-transition

event.

The public black-box evidence contract already exposes ordered logical_path observations.

The verifier was corrected to derive logical transitions from changes in the ordered public event stream:

wifi → mobile

This removed the false counter-consistency failure without introducing synthetic subject evidence.

### Final result

Before final verifier correction:

13 PASS
1 FAIL

After correction:

VERDICT=PASS

The failure was in verifier interpretation, not in observed blackout recovery behavior.