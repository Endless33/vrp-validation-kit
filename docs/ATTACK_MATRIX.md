Attack                         Expected Verdict

Replay                         REPLAY_WINDOW_ENFORCED
Rollback                       AUTHORITY_ROLLBACK_REJECTED
Duplicate Commit               DUPLICATE_COMMIT_REJECTED
Commit Replay                  COMMIT_REPLAY_REJECTED
History Rewrite                CANONICAL_HISTORY_REWRITE_REJECTED
Authority Race                 AUTHORITY_RACE_RESOLVED
Transport Storm                TRANSPORT_MIGRATION_PRESERVED
Runtime Recovery               SESSION_RECOVERY_PRESERVED
Partition Recovery             PARTITION_RECOVERY_PRESERVED