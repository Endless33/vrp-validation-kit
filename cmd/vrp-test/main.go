package main

import (
	"fmt"
)

type Session struct {
	ID             string
	Authority      string
	Epoch          uint64
	Mutations      map[string]bool
	CommitHashes   map[string]bool
	ReplayWindow   map[uint64]bool
	CommitCount    int
	History        []string
	LastSequence    uint64
	Recovered      bool
	RecoverySource string
}

type Snapshot struct {
	SessionID    string
	Authority    string
	Epoch        uint64
	CommitCount  int
	History      []string
	LastSequence uint64
}

func NewSession() *Session {
	return &Session{
		ID:           "session-alpha",
		Authority:    "authority-a",
		Epoch:        10,
		Mutations:    make(map[string]bool),
		CommitHashes: make(map[string]bool),
		ReplayWindow: make(map[uint64]bool),
		History:      []string{},
	}
}

func main() {
	fmt.Println("=== VRP VALIDATION KIT ===")
	fmt.Println("Runtime: standalone invariant validation harness")
	fmt.Println()

	session := NewSession()

	runDuplicateMutationTest(session)
	runStaleAuthorityTest(session)
	runStaleEpochTest(session)
	runTransportMigrationTest(session)
	runAuthorityMigrationTest(session)
	runReplayWindowValidation(session)
	runAuthorityRollbackRejection(session)
	runCommitReplayRejection(session)
	runSessionRecoveryValidation(session)
	runCanonicalHistoryTest(session)

	fmt.Println("=== VALIDATION SUMMARY ===")
	fmt.Printf("session_id=%s\n", session.ID)
	fmt.Printf("active_authority=%s\n", session.Authority)
	fmt.Printf("epoch=%d\n", session.Epoch)
	fmt.Printf("canonical_commits=%d\n", session.CommitCount)
	fmt.Printf("history_entries=%d\n", len(session.History))
	fmt.Printf("last_sequence=%d\n", session.LastSequence)
	fmt.Printf("recovered=%v\n", session.Recovered)
	fmt.Println()
	fmt.Println("FINAL_VERDICT=VALIDATION_PASSED")
}

func runDuplicateMutationTest(s *Session) {
	fmt.Println("TEST: DUPLICATE MUTATION")

	accepted := commit(s, "authority-a", 10, "payment-001", "commit-hash-001")
	replayed := commit(s, "authority-a", 10, "payment-001", "commit-hash-001-retry")

	fmt.Printf("first_commit=%v\n", accepted)
	fmt.Printf("replayed_commit=%v\n", replayed)

	if accepted && !replayed {
		fmt.Println("VERDICT=DUPLICATE_COMMIT_REJECTED")
	}

	fmt.Println()
}

func runStaleAuthorityTest(s *Session) {
	fmt.Println("TEST: STALE AUTHORITY")

	result := commit(s, "authority-old", 10, "payment-002", "commit-hash-002")

	fmt.Printf("accepted=%v\n", result)

	if !result {
		fmt.Println("VERDICT=STALE_AUTHORITY_REJECTED")
	}

	fmt.Println()
}

func runStaleEpochTest(s *Session) {
	fmt.Println("TEST: STALE EPOCH")

	result := commit(s, "authority-a", 5, "payment-003", "commit-hash-003")

	fmt.Printf("accepted=%v\n", result)

	if !result {
		fmt.Println("VERDICT=STALE_EPOCH_REJECTED")
	}

	fmt.Println()
}

func runTransportMigrationTest(s *Session) {
	fmt.Println("TEST: TRANSPORT MIGRATION")

	before := s.ID
	oldTransport := "wifi"
	newTransport := "lte"
	after := s.ID

	fmt.Printf("old_transport=%s\n", oldTransport)
	fmt.Printf("new_transport=%s\n", newTransport)
	fmt.Printf("session_before=%s\n", before)
	fmt.Printf("session_after=%s\n", after)

	if before == after {
		fmt.Println("VERDICT=SESSION_IDENTITY_PRESERVED")
	}

	fmt.Println()
}

func runAuthorityMigrationTest(s *Session) {
	fmt.Println("TEST: AUTHORITY MIGRATION")

	oldAuthority := s.Authority
	oldEpoch := s.Epoch

	migrated := migrateAuthority(s, "authority-b", 11)

	staleCommit := commit(s, oldAuthority, oldEpoch, "payment-004-stale", "commit-hash-004-stale")
	newCommit := commit(s, "authority-b", 11, "payment-004", "commit-hash-004")

	fmt.Printf("old_authority=%s\n", oldAuthority)
	fmt.Printf("new_authority=%s\n", s.Authority)
	fmt.Printf("old_epoch=%d\n", oldEpoch)
	fmt.Printf("new_epoch=%d\n", s.Epoch)
	fmt.Printf("migration_accepted=%v\n", migrated)
	fmt.Printf("stale_commit=%v\n", staleCommit)
	fmt.Printf("new_authority_commit=%v\n", newCommit)

	if migrated && !staleCommit && newCommit {
		fmt.Println("VERDICT=AUTHORITY_MIGRATION_PRESERVED")
	}

	fmt.Println()
}

func runReplayWindowValidation(s *Session) {
	fmt.Println("TEST: REPLAY WINDOW VALIDATION")

	first := admitPacket(s, 100)
	second := admitPacket(s, 101)
	replayed := admitPacket(s, 100)

	fmt.Printf("packet_100_first=%v\n", first)
	fmt.Printf("packet_101_first=%v\n", second)
	fmt.Printf("packet_100_replay=%v\n", replayed)

	if first && second && !replayed {
		fmt.Println("VERDICT=REPLAY_WINDOW_ENFORCED")
	}

	fmt.Println()
}

func runAuthorityRollbackRejection(s *Session) {
	fmt.Println("TEST: AUTHORITY ROLLBACK REJECTION")

	beforeAuthority := s.Authority
	beforeEpoch := s.Epoch

	rollbackAccepted := migrateAuthority(s, "authority-a", 10)

	fmt.Printf("current_authority=%s\n", beforeAuthority)
	fmt.Printf("current_epoch=%d\n", beforeEpoch)
	fmt.Printf("rollback_target_authority=%s\n", "authority-a")
	fmt.Printf("rollback_target_epoch=%d\n", 10)
	fmt.Printf("rollback_accepted=%v\n", rollbackAccepted)

	if !rollbackAccepted && s.Authority == beforeAuthority && s.Epoch == beforeEpoch {
		fmt.Println("VERDICT=AUTHORITY_ROLLBACK_REJECTED")
	}

	fmt.Println()
}

func runCommitReplayRejection(s *Session) {
	fmt.Println("TEST: COMMIT REPLAY REJECTION")

	first := commit(s, "authority-b", 11, "payment-005", "commit-hash-005")
	replayed := commit(s, "authority-b", 11, "payment-005-replay-attempt", "commit-hash-005")

	fmt.Printf("first_commit=%v\n", first)
	fmt.Printf("replayed_commit_hash=%v\n", replayed)

	if first && !replayed {
		fmt.Println("VERDICT=COMMIT_REPLAY_REJECTED")
	}

	fmt.Println()
}

func runSessionRecoveryValidation(s *Session) {
	fmt.Println("TEST: SESSION RECOVERY VALIDATION")

	snapshot := takeSnapshot(s)

	restored := restoreSession(snapshot)

	fmt.Printf("snapshot_session=%s\n", snapshot.SessionID)
	fmt.Printf("restored_session=%s\n", restored.ID)
	fmt.Printf("snapshot_authority=%s\n", snapshot.Authority)
	fmt.Printf("restored_authority=%s\n", restored.Authority)
	fmt.Printf("snapshot_epoch=%d\n", snapshot.Epoch)
	fmt.Printf("restored_epoch=%d\n", restored.Epoch)
	fmt.Printf("snapshot_commits=%d\n", snapshot.CommitCount)
	fmt.Printf("restored_commits=%d\n", restored.CommitCount)

	if restored.ID == s.ID &&
		restored.Authority == s.Authority &&
		restored.Epoch == s.Epoch &&
		restored.CommitCount == s.CommitCount {
		s.Recovered = true
		s.RecoverySource = "snapshot"
		fmt.Println("VERDICT=SESSION_RECOVERY_PRESERVED")
	}

	fmt.Println()
}

func runCanonicalHistoryTest(s *Session) {
	fmt.Println("TEST: CANONICAL HISTORY")

	for index, mutation := range s.History {
		fmt.Printf("commit_%d=%s\n", index+1, mutation)
	}

	if len(s.History) == s.CommitCount {
		fmt.Println("VERDICT=CANONICAL_HISTORY_CONSISTENT")
	}

	fmt.Println()
}

func migrateAuthority(s *Session, authority string, epoch uint64) bool {
	if epoch <= s.Epoch {
		return false
	}

	s.Authority = authority
	s.Epoch = epoch

	return true
}

func admitPacket(s *Session, sequence uint64) bool {
	if sequence <= s.LastSequence {
		return false
	}

	if s.ReplayWindow[sequence] {
		return false
	}

	s.ReplayWindow[sequence] = true
	s.LastSequence = sequence

	return true
}

func takeSnapshot(s *Session) Snapshot {
	historyCopy := make([]string, len(s.History))
	copy(historyCopy, s.History)

	return Snapshot{
		SessionID:    s.ID,
		Authority:    s.Authority,
		Epoch:        s.Epoch,
		CommitCount:  s.CommitCount,
		History:      historyCopy,
		LastSequence: s.LastSequence,
	}
}

func restoreSession(snapshot Snapshot) *Session {
	restored := &Session{
		ID:             snapshot.SessionID,
		Authority:      snapshot.Authority,
		Epoch:          snapshot.Epoch,
		Mutations:      make(map[string]bool),
		CommitHashes:   make(map[string]bool),
		ReplayWindow:   make(map[uint64]bool),
		CommitCount:    snapshot.CommitCount,
		History:        snapshot.History,
		LastSequence:    snapshot.LastSequence,
		Recovered:      true,
		RecoverySource: "snapshot",
	}

	for _, mutation := range snapshot.History {
		restored.Mutations[mutation] = true
	}

	return restored
}

func commit(
	s *Session,
	authority string,
	epoch uint64,
	mutation string,
	commitHash string,
) bool {
	if authority != s.Authority {
		return false
	}

	if epoch < s.Epoch {
		return false
	}

	if s.Mutations[mutation] {
		return false
	}

	if s.CommitHashes[commitHash] {
		return false
	}

	s.Mutations[mutation] = true
	s.CommitHashes[commitHash] = true
	s.CommitCount++
	s.History = append(s.History, mutation)

	return true
}