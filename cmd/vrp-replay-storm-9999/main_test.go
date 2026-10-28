package main

import (
	"math"
	"testing"
)

func TestExactDuplicateRejectedWithoutMutation(t *testing.T) {
	var w Window

	if !w.Accept(1000) {
		t.Fatal("initial sequence rejected")
	}

	before := w.maxSeen

	if w.Accept(1000) {
		t.Fatal("duplicate sequence accepted")
	}

	if w.maxSeen != before {
		t.Fatalf("rejected duplicate mutated state: before=%d after=%d",
			before, w.maxSeen)
	}

	t.Logf("EXACT_DUPLICATE_REJECTED=YES before=%d after=%d",
		before, w.maxSeen)
}

func TestStaleSequenceRejectedWithoutMutation(t *testing.T) {
	var w Window

	if !w.Accept(1000) {
		t.Fatal("initial sequence rejected")
	}

	before := w.maxSeen

	for _, seq := range []uint64{
		999, 998, 500, 42, 1, 0,
	} {
		if w.Accept(seq) {
			t.Fatalf("stale sequence accepted: seq=%d", seq)
		}

		if w.maxSeen != before {
			t.Fatalf(
				"stale rejection mutated state: seq=%d before=%d after=%d",
				seq, before, w.maxSeen,
			)
		}
	}

	t.Logf("STALE_REJECTION_STATE_PRESERVED=YES max=%d", w.maxSeen)
}

func TestReplayStorm9999DirectImplementation(t *testing.T) {
	var w Window

	const (
		original = uint64(1000)
		attempts = 9999
	)

	if !w.Accept(original) {
		t.Fatal("initial sequence rejected")
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

	after := w.maxSeen

	t.Logf("ATTACK_ATTEMPTS=%d", attempts)
	t.Logf("REPLAY_REJECTED=%d", rejected)
	t.Logf("REPLAY_ACCEPTED=%d", accepted)
	t.Logf("CANONICAL_MAX_BEFORE_ATTACK=%d", before)
	t.Logf("CANONICAL_MAX_AFTER_ATTACK=%d", after)

	if accepted != 0 {
		t.Fatalf("duplicate acceptance detected: accepted=%d", accepted)
	}

	if rejected != attempts {
		t.Fatalf(
			"rejection count mismatch: rejected=%d expected=%d",
			rejected, attempts,
		)
	}

	if before != after {
		t.Fatalf(
			"replay storm mutated canonical state: before=%d after=%d",
			before, after,
		)
	}

	t.Log("STATE_PRESERVED_DURING_ATTACK=true")
}

func TestReplayStorm100000DirectImplementation(t *testing.T) {
	var w Window

	if !w.Accept(1000) {
		t.Fatal("initial sequence rejected")
	}

	before := w.maxSeen

	const attempts = 100000
	accepted := 0

	for i := 0; i < attempts; i++ {
		if w.Accept(1000) {
			accepted++
		}
	}

	if accepted != 0 {
		t.Fatalf("duplicate accepted during 100000 storm: %d", accepted)
	}

	if w.maxSeen != before {
		t.Fatalf(
			"state changed during 100000 replay storm: before=%d after=%d",
			before, w.maxSeen,
		)
	}

	t.Logf(
		"REPLAY_STORM_100000=PRESERVED attempts=%d accepted=%d max=%d",
		attempts, accepted, w.maxSeen,
	)
}

func TestAlternatingReplayAndStaleInputs(t *testing.T) {
	var w Window

	if !w.Accept(1000) {
		t.Fatal("initial sequence rejected")
	}

	before := w.maxSeen

	attack := []uint64{
		1000, 999, 1000, 998,
		500, 1000, 42, 1,
		0, 999, 777, 1000,
	}

	for i, seq := range attack {
		if w.Accept(seq) {
			t.Fatalf(
				"attack input accepted: index=%d seq=%d",
				i, seq,
			)
		}
	}

	if w.maxSeen != before {
		t.Fatalf(
			"alternating attack mutated state: before=%d after=%d",
			before, w.maxSeen,
		)
	}

	t.Logf(
		"ALTERNATING_REPLAY_STALE=PRESERVED attempts=%d max=%d",
		len(attack), w.maxSeen,
	)
}

func TestLegitimateProgressAfterReplayStorm(t *testing.T) {
	var w Window

	if !w.Accept(1000) {
		t.Fatal("initial sequence rejected")
	}

	for i := 0; i < 9999; i++ {
		if w.Accept(1000) {
			t.Fatalf("replay accepted at iteration=%d", i)
		}
	}

	if w.maxSeen != 1000 {
		t.Fatalf(
			"attack changed state before legitimate progress: max=%d",
			w.maxSeen,
		)
	}

	if !w.Accept(1001) {
		t.Fatal("first legitimate sequence blocked after replay storm")
	}

	if !w.Accept(1002) {
		t.Fatal("second legitimate sequence blocked after replay storm")
	}

	if w.maxSeen != 1002 {
		t.Fatalf("unexpected final state: max=%d", w.maxSeen)
	}

	t.Log("POST_ATTACK_LEGITIMATE_PROGRESS=PRESERVED")
}

func TestForwardJumpThenOldSequenceRejected(t *testing.T) {
	var w Window

	if !w.Accept(1000) {
		t.Fatal("initial sequence rejected")
	}

	if !w.Accept(5000) {
		t.Fatal("legitimate forward jump rejected")
	}

	before := w.maxSeen

	if w.Accept(1001) {
		t.Fatal("old sequence accepted after forward jump")
	}

	if w.maxSeen != before {
		t.Fatalf(
			"old sequence mutated state: before=%d after=%d",
			before, w.maxSeen,
		)
	}

	t.Logf("FORWARD_JUMP_CONTROL=PASS max=%d", w.maxSeen)
}

func TestUint64BoundaryAndWraparound(t *testing.T) {
	var w Window

	if !w.Accept(math.MaxUint64 - 1) {
		t.Fatal("MaxUint64-1 rejected")
	}

	if !w.Accept(math.MaxUint64) {
		t.Fatal("MaxUint64 legitimate forward progress rejected")
	}

	before := w.maxSeen

	if w.Accept(math.MaxUint64) {
		t.Fatal("MaxUint64 duplicate accepted")
	}

	if w.Accept(0) {
		t.Fatal("wraparound attempt MaxUint64 -> 0 accepted")
	}

	if w.maxSeen != before {
		t.Fatalf(
			"boundary rejection mutated state: before=%d after=%d",
			before, w.maxSeen,
		)
	}

	t.Logf("UINT64_BOUNDARY=PRESERVED max=%d", w.maxSeen)
}

func TestRejectedInputsCannotPoisonBoundary(t *testing.T) {
	var w Window

	if !w.Accept(50000) {
		t.Fatal("initial sequence rejected")
	}

	before := w.maxSeen

	for seq := uint64(0); seq < 10000; seq++ {
		if w.Accept(seq) {
			t.Fatalf("state poisoning input accepted: seq=%d", seq)
		}
	}

	if w.maxSeen != before {
		t.Fatalf(
			"boundary poisoned: before=%d after=%d",
			before, w.maxSeen,
		)
	}

	t.Logf("STALE_STATE_POISONING=REJECTED max=%d", w.maxSeen)
}

func TestInterleavedLegitimateAndDuplicateTraffic(t *testing.T) {
	var w Window

	const limit = uint64(10000)

	for seq := uint64(1); seq <= limit; seq++ {
		if !w.Accept(seq) {
			t.Fatalf("legitimate sequence rejected: seq=%d", seq)
		}

		before := w.maxSeen

		if w.Accept(seq) {
			t.Fatalf("duplicate accepted: seq=%d", seq)
		}

		if w.maxSeen != before {
			t.Fatalf(
				"duplicate mutated state: seq=%d before=%d after=%d",
				seq, before, w.maxSeen,
			)
		}
	}

	if w.maxSeen != limit {
		t.Fatalf("unexpected final max: %d", w.maxSeen)
	}

	t.Logf(
		"INTERLEAVED_PROGRESS_DUPLICATES=PASS legitimate=%d duplicates_rejected=%d",
		limit, limit,
	)
}
