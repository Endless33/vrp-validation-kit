package main

import (
	"fmt"
	"os"
)

const (
	attempts = 9999
	original = uint64(1000)
)

// Window is a standalone PUBLIC invariant model.
// It is NOT the protected VRP replay implementation.
type Window struct {
	initialized bool
	maxSeen     uint64
}

func (w *Window) Accept(seq uint64) bool {
	if !w.initialized {
		w.initialized = true
		w.maxSeen = seq
		return true
	}

	if seq <= w.maxSeen {
		return false
	}

	w.maxSeen = seq
	return true
}

func fail(reason string) {
	fmt.Printf("FAIL_REASON=%s\n", reason)
	fmt.Println("FINAL_VERDICT=FAIL")
	os.Exit(1)
}

func main() {
	fmt.Println("==============================================================")
	fmt.Println("       VEIL ROUTING PROTOCOL | PUBLIC VALIDATION KIT")
	fmt.Println("                  REPLAY STORM 9,999")
	fmt.Println("==============================================================")
	fmt.Println("MODE=PUBLIC_STANDALONE_INVARIANT_VALIDATION")
	fmt.Println("PROTECTED_RUNTIME_SOURCE=NOT_INCLUDED")
	fmt.Println("TRANSPORT=NOT_EXERCISED")
	fmt.Println()

	w := &Window{}

	if !w.Accept(original) {
		fail("ORIGINAL_NOT_ACCEPTED")
	}

	before := w.maxSeen
	accepted := 0
	rejected := 0

	for i := 0; i < attempts; i++ {
		if w.Accept(original) {
			accepted++
		} else {
			rejected++
		}
	}

	afterAttack := w.maxSeen
	statePreserved := before == afterAttack

	fmt.Printf("ATTACK_TYPE=DUPLICATE_SEQUENCE_REPLAY\n")
	fmt.Printf("ATTACK_ATTEMPTS=%d\n", attempts)
	fmt.Printf("REPLAY_REJECTED=%d\n", rejected)
	fmt.Printf("REPLAY_ACCEPTED=%d\n", accepted)
	fmt.Printf("CANONICAL_MAX_BEFORE_ATTACK=%d\n", before)
	fmt.Printf("CANONICAL_MAX_AFTER_ATTACK=%d\n", afterAttack)
	fmt.Printf("STATE_PRESERVED_DURING_ATTACK=%t\n", statePreserved)

	if rejected != attempts {
		fail("REJECTION_COUNT_MISMATCH")
	}

	if accepted != 0 {
		fail("DUPLICATE_ACCEPTED")
	}

	if !statePreserved {
		fail("CANONICAL_STATE_CHANGED")
	}

	next := original + 1
	nextAccepted := w.Accept(next)

	fmt.Printf("NEXT_LEGITIMATE_SEQUENCE=%d\n", next)
	fmt.Printf("NEXT_SEQUENCE_ACCEPTED=%t\n", nextAccepted)

	if !nextAccepted {
		fail("LEGITIMATE_PROGRESS_BLOCKED")
	}

	fmt.Println("REJECTION_RATE=100.00%")
	fmt.Println("DUPLICATE_ACCEPTANCE=0")
	fmt.Println("LEGITIMATE_PROGRESS=PRESERVED")
	fmt.Println("FINAL_VERDICT=PASS")
	fmt.Println("==============================================================")
}
