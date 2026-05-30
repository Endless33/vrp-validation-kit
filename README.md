---

Closed Core Runner

The validation kit also includes a closed-core runner preview distributed as prebuilt binaries.

The runner exposes executable validation scenarios without exposing private implementation details.

Linux:

chmod +x vrp-core-runner-linux-amd64

./vrp-core-runner-linux-amd64 --list

Windows:

.\vrp-core-runner-windows-amd64.exe --list

Available scenarios:

replay-storm
authority-rollback
runtime-recovery
transport-migration
integrated-chaos

---

Replay Window Scenario

Linux:

./vrp-core-runner-linux-amd64 --scenario replay-storm --packets 10000

Windows:

.\vrp-core-runner-windows-amd64.exe --scenario replay-storm --packets 10000

Expected behavior:

packets=10000
accepted=1
rejected=9999

VERDICT=REPLAY_WINDOW_ENFORCED

This scenario validates replay admission behavior by repeatedly submitting the same sequence identifier through a replay window.

---

Authority Rollback Scenario

Linux:

./vrp-core-runner-linux-amd64 --scenario authority-rollback --epoch 5

Windows:

.\vrp-core-runner-windows-amd64.exe --scenario authority-rollback --epoch 5

Expected behavior:

current_epoch=10
candidate_epoch=5

rollback_accepted=false

VERDICT=AUTHORITY_ROLLBACK_REJECTED

This scenario validates epoch monotonicity and authority rollback containment.

---

Session Recovery Scenario

Linux:

./vrp-core-runner-linux-amd64 --scenario runtime-recovery

Windows:

.\vrp-core-runner-windows-amd64.exe --scenario runtime-recovery

Expected behavior:

session_preserved=true
authority_preserved=true
epoch_preserved=true
history_preserved=true
recovered=true

VERDICT=SESSION_RECOVERY_PRESERVED

This scenario validates snapshot-based recovery and restoration consistency.