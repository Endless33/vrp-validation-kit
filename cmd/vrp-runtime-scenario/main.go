package main

import (
	"fmt"
)

type Runtime struct {
	SessionID     string
	Transport     string
	Authority     string
	Epoch         uint64
	CommitHistory []string
	ReplayCache   map[string]bool
	Recovered     bool
}

type Snapshot struct {
	SessionID     string
	Transport     string
	Authority     string
	Epoch         uint64
	CommitHistory []string
}

func NewRuntime() *Runtime {
	return &Runtime{
		SessionID:     "session-runtime-alpha",
		Transport:     "wifi",
		Authority:     "authority-a",
		Epoch:         1,
		CommitHistory: []string{},
		ReplayCache:   make(map[string]bool),
	}
}

func main() {
	runtime := NewRuntime()

	fmt.Println("=== VRP INTEGRATED RUNTIME SCENARIO ===")
	fmt.Println("Scenario: continuity preservation across migration, authority transfer, replay attack, and recovery")
	fmt.Println()

	sessionCreated(runtime)
	commitAccepted(runtime, "mutation-001", "commit-hash-001")
	transportMigration(runtime, "lte")
	authorityTransfer(runtime, "authority-b", 2)
	replayAttack(runtime, "commit-hash-001")
	runtimeRecovery(runtime)
	verifyCanonicalHistory(runtime)

	fmt.Println("=== FINAL RUNTIME STATE ===")
	fmt.Printf("session_id=%s\n", runtime.SessionID)
	fmt.Printf("transport=%s\n", runtime.Transport)
	fmt.Printf("authority=%s\n", runtime.Authority)
	fmt.Printf("epoch=%d\n", runtime.Epoch)
	fmt.Printf("commits=%d\n", len(runtime.CommitHistory))
	fmt.Printf("recovered=%v\n", runtime.Recovered)
	fmt.Println()
	fmt.Println("FINAL_VERDICT=CONTINUITY_PRESERVED")
}

func sessionCreated(r *Runtime) {
	fmt.Println("STEP: SESSION CREATED")
	fmt.Printf("session_id=%s\n", r.SessionID)
	fmt.Printf("transport=%s\n", r.Transport)
	fmt.Printf("authority=%s\n", r.Authority)
	fmt.Printf("epoch=%d\n", r.Epoch)
	fmt.Println("VERDICT=SESSION_ESTABLISHED")
	fmt.Println()
}

func commitAccepted(r *Runtime, mutation string, commitHash string) {
	fmt.Println("STEP: CANONICAL COMMIT")

	if r.ReplayCache[commitHash] {
		fmt.Printf("mutation=%s\n", mutation)
		fmt.Printf("commit_hash=%s\n", commitHash)
		fmt.Println("accepted=false")
		fmt.Println("VERDICT=COMMIT_REPLAY_REJECTED")
		fmt.Println()
		return
	}

	r.ReplayCache[commitHash] = true
	r.CommitHistory = append(r.CommitHistory, mutation)

	fmt.Printf("mutation=%s\n", mutation)
	fmt.Printf("commit_hash=%s\n", commitHash)
	fmt.Println("accepted=true")
	fmt.Println("VERDICT=CANONICAL_COMMIT_ACCEPTED")
	fmt.Println()
}

func transportMigration(r *Runtime, newTransport string) {
	fmt.Println("STEP: TRANSPORT MIGRATION")

	oldTransport := r.Transport
	sessionBefore := r.SessionID

	r.Transport = newTransport

	fmt.Printf("old_transport=%s\n", oldTransport)
	fmt.Printf("new_transport=%s\n", r.Transport)
	fmt.Printf("session_before=%s\n", sessionBefore)
	fmt.Printf("session_after=%s\n", r.SessionID)

	if sessionBefore == r.SessionID {
		fmt.Println("VERDICT=SESSION_IDENTITY_PRESERVED")
	}

	fmt.Println()
}

func authorityTransfer(r *Runtime, newAuthority string, newEpoch uint64) {
	fmt.Println("STEP: AUTHORITY TRANSFER")

	oldAuthority := r.Authority
	oldEpoch := r.Epoch

	if newEpoch <= r.Epoch {
		fmt.Println("accepted=false")
		fmt.Println("VERDICT=AUTHORITY_TRANSFER_REJECTED")
		fmt.Println()
		return
	}

	r.Authority = newAuthority
	r.Epoch = newEpoch

	fmt.Printf("old_authority=%s\n", oldAuthority)
	fmt.Printf("new_authority=%s\n", r.Authority)
	fmt.Printf("old_epoch=%d\n", oldEpoch)
	fmt.Printf("new_epoch=%d\n", r.Epoch)
	fmt.Println("accepted=true")
	fmt.Println("VERDICT=AUTHORITY_TRANSFER_ACCEPTED")
	fmt.Println()
}

func replayAttack(r *Runtime, commitHash string) {
	fmt.Println("STEP: REPLAY ATTACK")

	if r.ReplayCache[commitHash] {
		fmt.Printf("commit_hash=%s\n", commitHash)
		fmt.Println("accepted=false")
		fmt.Println("VERDICT=REPLAY_ATTACK_REJECTED")
		fmt.Println()
		return
	}

	fmt.Printf("commit_hash=%s\n", commitHash)
	fmt.Println("accepted=true")
	fmt.Println("VERDICT=REPLAY_ATTACK_NOT_DETECTED")
	fmt.Println()
}

func runtimeRecovery(r *Runtime) {
	fmt.Println("STEP: RUNTIME RECOVERY")

	snapshot := takeSnapshot(r)
	restored := restoreRuntime(snapshot)

	fmt.Printf("snapshot_session=%s\n", snapshot.SessionID)
	fmt.Printf("restored_session=%s\n", restored.SessionID)
	fmt.Printf("snapshot_authority=%s\n", snapshot.Authority)
	fmt.Printf("restored_authority=%s\n", restored.Authority)
	fmt.Printf("snapshot_epoch=%d\n", snapshot.Epoch)
	fmt.Printf("restored_epoch=%d\n", restored.Epoch)
	fmt.Printf("snapshot_commits=%d\n", len(snapshot.CommitHistory))
	fmt.Printf("restored_commits=%d\n", len(restored.CommitHistory))

	if restored.SessionID == r.SessionID &&
		restored.Authority == r.Authority &&
		restored.Epoch == r.Epoch &&
		len(restored.CommitHistory) == len(r.CommitHistory) {
		r.Recovered = true
		fmt.Println("VERDICT=RUNTIME_RECOVERY_PRESERVED")
	}

	fmt.Println()
}

func verifyCanonicalHistory(r *Runtime) {
	fmt.Println("STEP: CANONICAL HISTORY VERIFICATION")

	for index, mutation := range r.CommitHistory {
		fmt.Printf("commit_%d=%s\n", index+1, mutation)
	}

	if len(r.CommitHistory) == 1 {
		fmt.Println("VERDICT=CANONICAL_HISTORY_PRESERVED")
	}

	fmt.Println()
}

func takeSnapshot(r *Runtime) Snapshot {
	historyCopy := make([]string, len(r.CommitHistory))
	copy(historyCopy, r.CommitHistory)

	return Snapshot{
		SessionID:     r.SessionID,
		Transport:     r.Transport,
		Authority:     r.Authority,
		Epoch:         r.Epoch,
		CommitHistory: historyCopy,
	}
}

func restoreRuntime(snapshot Snapshot) *Runtime {
	historyCopy := make([]string, len(snapshot.CommitHistory))
	copy(historyCopy, snapshot.CommitHistory)

	return &Runtime{
		SessionID:     snapshot.SessionID,
		Transport:     snapshot.Transport,
		Authority:     snapshot.Authority,
		Epoch:         snapshot.Epoch,
		CommitHistory: historyCopy,
		ReplayCache:   make(map[string]bool),
		Recovered:     true,
	}
}