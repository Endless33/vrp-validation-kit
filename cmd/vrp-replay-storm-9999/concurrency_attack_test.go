package main

import (
	"runtime"
	"sync"
	"sync/atomic"
	"testing"
)

// These tests intentionally exercise a shared Window concurrently.
// The current public replay model does not declare shared-Window concurrency safety.
// A failure or race is therefore evidence about an unqualified boundary, not by itself
// evidence of a protected-runtime vulnerability.

func TestAttackConcurrentSameSequence(t *testing.T) {
	const workers = 256

	var w Window
	if !w.Accept(1000) {
		t.Fatal("initial sequence rejected")
	}

	start := make(chan struct{})
	var wg sync.WaitGroup
	var accepted atomic.Int64
	var rejected atomic.Int64

	wg.Add(workers)
	for i := 0; i < workers; i++ {
		go func() {
			defer wg.Done()
			<-start
			runtime.Gosched()
			if w.Accept(1001) {
				accepted.Add(1)
			} else {
				rejected.Add(1)
			}
		}()
	}

	close(start)
	wg.Wait()

	a := accepted.Load()
	r := rejected.Load()

	t.Logf("CONCURRENT_SAME_SEQUENCE_WORKERS=%d", workers)
	t.Logf("CONCURRENT_SAME_SEQUENCE_ACCEPTED=%d", a)
	t.Logf("CONCURRENT_SAME_SEQUENCE_REJECTED=%d", r)
	t.Logf("CONCURRENT_SAME_SEQUENCE_FINAL_MAX=%d", w.maxSeen)

	if a != 1 {
		t.Fatalf("linearization violation candidate: accepted=%d expected=1", a)
	}
	if r != workers-1 {
		t.Fatalf("rejection count mismatch: rejected=%d expected=%d", r, workers-1)
	}
	if w.maxSeen != 1001 {
		t.Fatalf("unexpected final max: %d", w.maxSeen)
	}
}

func TestAttackConcurrentForwardProgress(t *testing.T) {
	const workers = 1024

	var w Window
	if !w.Accept(1000) {
		t.Fatal("initial sequence rejected")
	}

	start := make(chan struct{})
	var wg sync.WaitGroup

	wg.Add(workers)
	for i := 0; i < workers; i++ {
		seq := uint64(1001 + i)
		go func(seq uint64) {
			defer wg.Done()
			<-start
			runtime.Gosched()
			w.Accept(seq)
		}(seq)
	}

	close(start)
	wg.Wait()

	expectedMax := uint64(1000 + workers)
	t.Logf("CONCURRENT_FORWARD_WORKERS=%d", workers)
	t.Logf("CONCURRENT_FORWARD_EXPECTED_MAX=%d", expectedMax)
	t.Logf("CONCURRENT_FORWARD_FINAL_MAX=%d", w.maxSeen)

	if w.maxSeen != expectedMax {
		t.Fatalf("monotonic final-state violation candidate: got=%d expected=%d",
			w.maxSeen, expectedMax)
	}
}

func TestAttackConcurrentReplayAgainstProgress(t *testing.T) {
	const (
		progressWorkers = 512
		replayWorkers   = 512
	)

	var w Window
	if !w.Accept(1000) {
		t.Fatal("initial sequence rejected")
	}

	start := make(chan struct{})
	var wg sync.WaitGroup
	var replayAccepted atomic.Int64

	wg.Add(progressWorkers + replayWorkers)

	for i := 0; i < progressWorkers; i++ {
		seq := uint64(1001 + i)
		go func(seq uint64) {
			defer wg.Done()
			<-start
			runtime.Gosched()
			w.Accept(seq)
		}(seq)
	}

	for i := 0; i < replayWorkers; i++ {
		go func() {
			defer wg.Done()
			<-start
			runtime.Gosched()
			if w.Accept(1000) {
				replayAccepted.Add(1)
			}
		}()
	}

	close(start)
	wg.Wait()

	expectedMax := uint64(1000 + progressWorkers)

	t.Logf("MIXED_PROGRESS_WORKERS=%d", progressWorkers)
	t.Logf("MIXED_REPLAY_WORKERS=%d", replayWorkers)
	t.Logf("MIXED_REPLAY_ACCEPTED=%d", replayAccepted.Load())
	t.Logf("MIXED_EXPECTED_MAX=%d", expectedMax)
	t.Logf("MIXED_FINAL_MAX=%d", w.maxSeen)

	if replayAccepted.Load() != 0 {
		t.Fatalf("replay accepted under concurrency: %d", replayAccepted.Load())
	}
	if w.maxSeen != expectedMax {
		t.Fatalf("mixed final-state violation candidate: got=%d expected=%d",
			w.maxSeen, expectedMax)
	}
}

func TestAttackConcurrentInitialization(t *testing.T) {
	const workers = 256

	var w Window
	start := make(chan struct{})
	var wg sync.WaitGroup
	var accepted atomic.Int64

	wg.Add(workers)
	for i := 0; i < workers; i++ {
		go func() {
			defer wg.Done()
			<-start
			runtime.Gosched()
			if w.Accept(1) {
				accepted.Add(1)
			}
		}()
	}

	close(start)
	wg.Wait()

	t.Logf("CONCURRENT_INIT_WORKERS=%d", workers)
	t.Logf("CONCURRENT_INIT_ACCEPTED=%d", accepted.Load())
	t.Logf("CONCURRENT_INIT_FINAL_MAX=%d", w.maxSeen)

	if accepted.Load() != 1 {
		t.Fatalf("initialization linearization violation candidate: accepted=%d expected=1",
			accepted.Load())
	}
	if !w.initialized || w.maxSeen != 1 {
		t.Fatalf("unexpected initialized state: initialized=%v max=%d",
			w.initialized, w.maxSeen)
	}
}
