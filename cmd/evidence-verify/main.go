package main

import (
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"fmt"
	"os"
	"sort"
	"strings"
)

type EvidenceBundle struct {
	SchemaVersion string            `json:"schema_version"`
	Protocol     string            `json:"protocol"`
	Scenario     string            `json:"scenario"`
	CoreVersion  string            `json:"core_version"`
	GeneratedAt  string            `json:"generated_at"`
	SessionID    string            `json:"session_id"`
	AuthorityID  string            `json:"authority_id"`
	Epoch        uint64            `json:"epoch"`
	Invariants   map[string]bool   `json:"invariants"`
	Verdicts     []string          `json:"verdicts"`
	Counts       map[string]uint64 `json:"counts"`
	EvidenceHash string            `json:"evidence_hash"`
}

type VerificationResult struct {
	Accepted bool
	Reason   string
}

func main() {
	if len(os.Args) != 3 || os.Args[1] != "--file" {
		fmt.Println("usage: go run ./cmd/evidence-verify --file evidence/sample/core-evidence.json")
		fmt.Println("FINAL_VERDICT=EVIDENCE_VERIFY_FAILED")
		os.Exit(1)
	}

	path := os.Args[2]

	data, err := os.ReadFile(path)
	if err != nil {
		fmt.Printf("error=failed_to_read_file path=%s reason=%s\n", path, err)
		fmt.Println("FINAL_VERDICT=EVIDENCE_VERIFY_FAILED")
		os.Exit(1)
	}

	var bundle EvidenceBundle
	if err := json.Unmarshal(data, &bundle); err != nil {
		fmt.Printf("error=invalid_json reason=%s\n", err)
		fmt.Println("FINAL_VERDICT=EVIDENCE_VERIFY_FAILED")
		os.Exit(1)
	}

	result := VerifyEvidence(bundle)

	fmt.Println("=== VRP EVIDENCE VERIFIER ===")
	fmt.Printf("file=%s\n", path)
	fmt.Printf("schema_version=%s\n", bundle.SchemaVersion)
	fmt.Printf("protocol=%s\n", bundle.Protocol)
	fmt.Printf("scenario=%s\n", bundle.Scenario)
	fmt.Printf("core_version=%s\n", bundle.CoreVersion)
	fmt.Printf("session_id=%s\n", bundle.SessionID)
	fmt.Printf("authority_id=%s\n", bundle.AuthorityID)
	fmt.Printf("epoch=%d\n", bundle.Epoch)
	fmt.Printf("expected_hash=%s\n", bundle.EvidenceHash)
	fmt.Printf("computed_hash=%s\n", ComputeEvidenceHash(bundle))
	fmt.Printf("accepted=%t\n", result.Accepted)
	fmt.Printf("reason=%s\n", result.Reason)

	if result.Accepted {
		fmt.Println("VERDICT=EVIDENCE_BUNDLE_VERIFIED")
		fmt.Println("FINAL_VERDICT=EVIDENCE_VERIFIED")
		return
	}

	fmt.Println("VERDICT=EVIDENCE_BUNDLE_REJECTED")
	fmt.Println("FINAL_VERDICT=EVIDENCE_VERIFY_FAILED")
	os.Exit(1)
}

func VerifyEvidence(bundle EvidenceBundle) VerificationResult {
	if strings.TrimSpace(bundle.SchemaVersion) == "" {
		return VerificationResult{Accepted: false, Reason: "missing schema version"}
	}

	if bundle.Protocol != "VRP" {
		return VerificationResult{Accepted: false, Reason: "unexpected protocol"}
	}

	if strings.TrimSpace(bundle.Scenario) == "" {
		return VerificationResult{Accepted: false, Reason: "missing scenario"}
	}

	if strings.TrimSpace(bundle.SessionID) == "" {
		return VerificationResult{Accepted: false, Reason: "missing session id"}
	}

	if strings.TrimSpace(bundle.AuthorityID) == "" {
		return VerificationResult{Accepted: false, Reason: "missing authority id"}
	}

	if bundle.Epoch == 0 {
		return VerificationResult{Accepted: false, Reason: "epoch must be non-zero"}
	}

	if len(bundle.Invariants) == 0 {
		return VerificationResult{Accepted: false, Reason: "no invariants provided"}
	}

	if len(bundle.Verdicts) == 0 {
		return VerificationResult{Accepted: false, Reason: "no verdicts provided"}
	}

	for name, preserved := range bundle.Invariants {
		if strings.TrimSpace(name) == "" {
			return VerificationResult{Accepted: false, Reason: "empty invariant name"}
		}

		if !preserved {
			return VerificationResult{Accepted: false, Reason: fmt.Sprintf("invariant not preserved: %s", name)}
		}
	}

	for _, verdict := range bundle.Verdicts {
		if strings.TrimSpace(verdict) == "" {
			return VerificationResult{Accepted: false, Reason: "empty verdict"}
		}

		if strings.Contains(verdict, "FAILED") || strings.Contains(verdict, "REJECTED_UNEXPECTED") {
			return VerificationResult{Accepted: false, Reason: fmt.Sprintf("rejected verdict detected: %s", verdict)}
		}
	}

	expectedHash := strings.TrimSpace(bundle.EvidenceHash)
	if expectedHash == "" {
		return VerificationResult{Accepted: false, Reason: "missing evidence hash"}
	}

	computedHash := ComputeEvidenceHash(bundle)
	if expectedHash != computedHash {
		return VerificationResult{Accepted: false, Reason: "evidence hash mismatch"}
	}

	return VerificationResult{Accepted: true, Reason: "evidence bundle verified"}
}

func ComputeEvidenceHash(bundle EvidenceBundle) string {
	canonical := canonicalEvidence(bundle)
	sum := sha256.Sum256([]byte(canonical))
	return hex.EncodeToString(sum[:])
}

func canonicalEvidence(bundle EvidenceBundle) string {
	var b strings.Builder

	b.WriteString("schema_version=" + bundle.SchemaVersion + "\n")
	b.WriteString("protocol=" + bundle.Protocol + "\n")
	b.WriteString("scenario=" + bundle.Scenario + "\n")
	b.WriteString("core_version=" + bundle.CoreVersion + "\n")
	b.WriteString("generated_at=" + bundle.GeneratedAt + "\n")
	b.WriteString("session_id=" + bundle.SessionID + "\n")
	b.WriteString("authority_id=" + bundle.AuthorityID + "\n")
	b.WriteString(fmt.Sprintf("epoch=%d\n", bundle.Epoch))

	invariantKeys := make([]string, 0, len(bundle.Invariants))
	for key := range bundle.Invariants {
		invariantKeys = append(invariantKeys, key)
	}
	sort.Strings(invariantKeys)

	for _, key := range invariantKeys {
		b.WriteString(fmt.Sprintf("invariant.%s=%t\n", key, bundle.Invariants[key]))
	}

	for i, verdict := range bundle.Verdicts {
		b.WriteString(fmt.Sprintf("verdict.%03d=%s\n", i, verdict))
	}

	countKeys := make([]string, 0, len(bundle.Counts))
	for key := range bundle.Counts {
		countKeys = append(countKeys, key)
	}
	sort.Strings(countKeys)

	for _, key := range countKeys {
		b.WriteString(fmt.Sprintf("count.%s=%d\n", key, bundle.Counts[key]))
	}

	return b.String()
}