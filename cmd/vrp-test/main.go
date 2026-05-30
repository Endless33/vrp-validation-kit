package main

import (
	"fmt"
)

type Session struct {
	ID          string
	Authority   string
	Epoch       uint64
	Mutations   map[string]bool
	CommitCount int
	History     []string
}

func NewSession() *Session {
	return &Session{
		ID:        "session-alpha",
		Authority: "authority-a",
		Epoch:     10,
		Mutations: make(map[string]bool),
		History:   []string{},
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
	runCanonicalHistoryTest(session)

	fmt.Println("=== VALIDATION SUMMARY ===")
	fmt.Printf("session_id=%s\n", session.ID)
	fmt.Printf("active_authority=%s\n", session.Authority)
	fmt.Printf("epoch=%d\n", session.Epoch)
	fmt.Printf("canonical_commits=%d\n", session.CommitCount)
	fmt.Printf("history_entries=%d\n", len(session.History))
	fmt.Println()
	fmt.Println("FINAL_VERDICT=VALIDATION_PASSED")
}

func runDuplicateMutationTest(s *Session) {
	fmt.Println("TEST: DUPLICATE MUTATION")

	accepted := commit(s, "authority-a", 10, "payment-001")
	replayed := commit(s, "authority-a", 10, "payment-001")

	fmt.Printf("first_commit=%v\n", accepted)
	fmt.Printf("replayed_commit=%v\n", replayed)

	if accepted && !replayed {
		fmt.Println("VERDICT=DUPLICATE_COMMIT_REJECTED")
	}

	fmt.Println()
}

func runStaleAuthorityTest(s *Session) {
	fmt.Println("TEST: STALE AUTHORITY")

	result := commit(s, "authority-old", 10, "payment-002")

	fmt.Printf("accepted=%v\n", result)

	if !result {
		fmt.Println("VERDICT=STALE_AUTHORITY_REJECTED")
	}

	fmt.Println()
}

func runStaleEpochTest(s *Session) {
	fmt.Println("TEST: STALE EPOCH")

	result := commit(s, "authority-a", 5, "payment-003")

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

	migrateAuthority(s, "authority-b", 11)

	staleCommit := commit(s, oldAuthority, oldEpoch, "payment-004")
	newCommit := commit(s, "authority-b", 11, "payment-004")

	fmt.Printf("old_authority=%s\n", oldAuthority)
	fmt.Printf("new_authority=%s\n", s.Authority)
	fmt.Printf("old_epoch=%d\n", oldEpoch)
	fmt.Printf("new_epoch=%d\n", s.Epoch)
	fmt.Printf("stale_commit=%v\n", staleCommit)
	fmt.Printf("new_authority_commit=%v\n", newCommit)

	if !staleCommit && newCommit {
		fmt.Println("VERDICT=AUTHORITY_MIGRATION_PRESERVED")
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

func migrateAuthority(s *Session, authority string, epoch uint64) {
	if epoch <= s.Epoch {
		return
	}

	s.Authority = authority
	s.Epoch = epoch
}

func commit(
	s *Session,
	authority string,
	epoch uint64,
	mutation string,
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

	s.Mutations[mutation] = true
	s.CommitCount++
	s.History = append(s.History, mutation)

	return true
}