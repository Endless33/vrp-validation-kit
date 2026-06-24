cd ~/audit-kit/vrp-validation-kit

mkdir -p cmd/signed-evidence-verify

cat > cmd/signed-evidence-verify/main.go <<'EOF'
package main

import (
	"crypto/ed25519"
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"fmt"
	"os"
	"sort"
	"strings"
)

type SignedEvidenceBundle struct {
	SchemaVersion     string            `json:"schema_version"`
	Protocol          string            `json:"protocol"`
	Scenario          string            `json:"scenario"`
	CoreVersion       string            `json:"core_version"`
	GeneratedAt       string            `json:"generated_at"`
	SessionID         string            `json:"session_id"`
	AuthorityID       string            `json:"authority_id"`
	Epoch             uint64            `json:"epoch"`
	Invariants        map[string]bool   `json:"invariants"`
	Verdicts          []string          `json:"verdicts"`
	Counts            map[string]uint64 `json:"counts"`
	EvidenceHash      string            `json:"evidence_hash"`
	EvidenceSignature string            `json:"evidence_signature"`
	SigningKeyID      string            `json:"signing_key_id"`
	PublicKey         string            `json:"public_key"`
}

func main() {
	if len(os.Args) != 3 || os.Args[1] != "--file" {
		fmt.Println("usage: go run ./cmd/signed-evidence-verify --file evidence/sample/signed-evidence-bundle.json")
		fmt.Println("FINAL_VERDICT=SIGNED_EVIDENCE_REJECTED")
		os.Exit(1)
	}

	path := os.Args[2]

	data, err := os.ReadFile(path)
	if err != nil {
		fmt.Printf("error=failed_to_read_file reason=%s\n", err)
		fmt.Println("FINAL_VERDICT=SIGNED_EVIDENCE_REJECTED")
		os.Exit(1)
	}

	var bundle SignedEvidenceBundle
	if err := json.Unmarshal(data, &bundle); err != nil {
		fmt.Printf("error=invalid_json reason=%s\n", err)
		fmt.Println("FINAL_VERDICT=SIGNED_EVIDENCE_REJECTED")
		os.Exit(1)
	}

	computedHash := computeEvidenceHash(bundle)
	hashMatches := computedHash == bundle.EvidenceHash
	signatureValid := verifySignature(bundle)

	fmt.Println("=== VRP SIGNED EVIDENCE VERIFIER ===")
	fmt.Printf("file=%s\n", path)
	fmt.Printf("schema_version=%s\n", bundle.SchemaVersion)
	fmt.Printf("protocol=%s\n", bundle.Protocol)
	fmt.Printf("scenario=%s\n", bundle.Scenario)
	fmt.Printf("signing_key_id=%s\n", bundle.SigningKeyID)
	fmt.Printf("expected_hash=%s\n", bundle.EvidenceHash)
	fmt.Printf("computed_hash=%s\n", computedHash)
	fmt.Printf("hash_matches=%t\n", hashMatches)
	fmt.Printf("signature_valid=%t\n", signatureValid)

	if bundle.Protocol != "VRP" {
		fmt.Println("reason=unexpected protocol")
		fmt.Println("VERDICT=SIGNED_EVIDENCE_BUNDLE_REJECTED")
		fmt.Println("FINAL_VERDICT=SIGNED_EVIDENCE_REJECTED")
		os.Exit(1)
	}

	if !hashMatches {
		fmt.Println("reason=evidence hash mismatch")
		fmt.Println("VERDICT=SIGNED_EVIDENCE_BUNDLE_REJECTED")
		fmt.Println("FINAL_VERDICT=SIGNED_EVIDENCE_REJECTED")
		os.Exit(1)
	}

	if !signatureValid {
		fmt.Println("reason=evidence signature invalid")
		fmt.Println("VERDICT=SIGNED_EVIDENCE_SIGNATURE_INVALID")
		fmt.Println("FINAL_VERDICT=SIGNED_EVIDENCE_REJECTED")
		os.Exit(1)
	}

	fmt.Println("reason=signed evidence bundle verified")
	fmt.Println("VERDICT=SIGNED_EVIDENCE_BUNDLE_VERIFIED")
	fmt.Println("FINAL_VERDICT=SIGNED_EVIDENCE_VERIFIED")
}

func verifySignature(bundle SignedEvidenceBundle) bool {
	publicKeyBytes, err := hex.DecodeString(bundle.PublicKey)
	if err != nil {
		return false
	}

	signatureBytes, err := hex.DecodeString(bundle.EvidenceSignature)
	if err != nil {
		return false
	}

	if len(publicKeyBytes) != ed25519.PublicKeySize {
		return false
	}

	if len(signatureBytes) != ed25519.SignatureSize {
		return false
	}

	return ed25519.Verify(ed25519.PublicKey(publicKeyBytes), []byte(bundle.EvidenceHash), signatureBytes)
}

func computeEvidenceHash(bundle SignedEvidenceBundle) string {
	canonical := canonicalEvidence(bundle)
	sum := sha256.Sum256([]byte(canonical))
	return hex.EncodeToString(sum[:])
}

func canonicalEvidence(bundle SignedEvidenceBundle) string {
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

	b.WriteString("signing_key_id=" + bundle.SigningKeyID + "\n")
	b.WriteString("public_key=" + bundle.PublicKey + "\n")

	return b.String()
}
EOF