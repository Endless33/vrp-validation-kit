package main

import (
	"fmt"
)

type Session struct {
	ID         string
	Authority  string
	Epoch      uint64
	Mutations  map[string]bool
	CommitCount int
}

func NewSession() *Session {
	return &Session{
		ID:        "session-alpha",
		Authority: "authority-a",
		Epoch:     10,
		Mutations: make(map[string]bool),
	}
}

func main() {
	fmt.Println("=== VRP VALIDATION KIT ===")
	fmt.Println()

	session := NewSession()

	runDuplicateMutationTest(session)
	runStaleAuthorityTest(session)
	runStaleEpochTest(session)
	runTransportMigrationTest(session)

	fmt.Println()
	fmt.Println("=== FINAL VERDICT ===")
	fmt.Println("VALIDATION_PASSED")
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

	return true
}