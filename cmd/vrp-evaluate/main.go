package main

import (
	"crypto/sha256"
	"encoding/hex"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"runtime"
	"strings"
	"time"
)

const version = "0.2.0"

type check struct {
	Name   string
	Status string
	Detail string
}

type stageResult struct {
	Name   string
	Status string
	RC     int
	Detail string
}

func main() {
	if len(os.Args) < 2 {
		usage()
		os.Exit(2)
	}

	switch os.Args[1] {
	case "doctor":
		os.Exit(runDoctor())
	case "verify-sample":
		os.Exit(runVerifySample())
	case "run":
		os.Exit(runEvaluation())
	case "version":
		fmt.Printf("vrp-evaluate %s\n", version)
	default:
		fmt.Fprintf(os.Stderr, "unknown command: %s\n\n", os.Args[1])
		usage()
		os.Exit(2)
	}
}

func usage() {
	fmt.Println("VRP Public Evaluation Capsule")
	fmt.Println()
	fmt.Println("Usage:")
	fmt.Println("  vrp-evaluate doctor")
	fmt.Println("  vrp-evaluate verify-sample")
	fmt.Println("  vrp-evaluate run")
	fmt.Println("  vrp-evaluate version")
}

func runDoctor() int {
	fmt.Println("============================================================")
	fmt.Println("VRP PUBLIC EVALUATION CAPSULE")
	fmt.Println("ENVIRONMENT DOCTOR")
	fmt.Println("============================================================")
	fmt.Println()

	checks := []check{
		{Name: "GO_RUNTIME", Status: "PASS", Detail: runtime.Version()},
		{Name: "PLATFORM", Status: "PASS", Detail: runtime.GOOS + "/" + runtime.GOARCH},
	}

	requiredFiles := []string{
		"go.mod",
		"cmd/attack-suite/main.go",
		"cmd/evidence-verify/main.go",
		"cmd/vrp-runtime-scenario/main.go",
		"cmd/vrp-test/main.go",
		"cmd/vrp-evaluate/main.go",
		"evidence/sample/core-evidence.json",
		"docker/continuity-lab/expected/invariant-contract.json",
	}

	for _, path := range requiredFiles {
		if _, err := os.Stat(path); err != nil {
			checks = append(checks, check{
				Name: "FILE_" + sanitize(path), Status: "FAIL", Detail: path,
			})
		} else {
			checks = append(checks, check{
				Name: "FILE_" + sanitize(path), Status: "PASS", Detail: path,
			})
		}
	}

	for _, name := range []string{"go", "git"} {
		path, err := exec.LookPath(name)
		if err != nil {
			checks = append(checks, check{
				Name: "COMMAND_" + sanitize(name), Status: "FAIL", Detail: "not found",
			})
			continue
		}

		checks = append(checks, check{
			Name: "COMMAND_" + sanitize(name), Status: "PASS", Detail: path,
		})
	}

	if path, err := exec.LookPath("docker"); err != nil {
		checks = append(checks, check{
			Name:   "DOCKER",
			Status: "INFO",
			Detail: "not available; Docker continuity scenarios unavailable on this host",
		})
	} else {
		checks = append(checks, check{
			Name: "DOCKER", Status: "PASS", Detail: path,
		})
	}

	if path, err := exec.LookPath("tc"); err != nil {
		checks = append(checks, check{
			Name:   "TC_NETEM",
			Status: "INFO",
			Detail: "tc not available; host network fault injection unavailable",
		})
	} else {
		checks = append(checks, check{
			Name: "TC_NETEM", Status: "PASS", Detail: path,
		})
	}

	failed := 0

	for _, c := range checks {
		fmt.Printf("%-58s : %s\n", c.Name, c.Status)
		fmt.Printf("  %s\n", c.Detail)

		if c.Status == "FAIL" {
			failed++
		}
	}

	fmt.Println()
	fmt.Println("============================================================")
	fmt.Println("DOCTOR SUMMARY")
	fmt.Println("============================================================")
	fmt.Printf("checks_total=%d\n", len(checks))
	fmt.Printf("checks_failed=%d\n", failed)

	if failed != 0 {
		fmt.Println("FINAL_VERDICT=ENVIRONMENT_NOT_READY")
		fmt.Println("FINAL_RC=1")
		return 1
	}

	fmt.Println("FINAL_VERDICT=ENVIRONMENT_READY")
	fmt.Println("FINAL_RC=0")
	return 0
}

func runVerifySample() int {
	const evidencePath = "evidence/sample/core-evidence.json"

	fmt.Println("============================================================")
	fmt.Println("VRP PUBLIC EVALUATION CAPSULE")
	fmt.Println("INDEPENDENT SAMPLE EVIDENCE VERIFICATION")
	fmt.Println("============================================================")
	fmt.Println()

	data, err := os.ReadFile(evidencePath)
	if err != nil {
		fmt.Fprintf(os.Stderr, "error=read_evidence reason=%v\n", err)
		fmt.Println("FINAL_VERDICT=EVIDENCE_VERIFY_FAILED")
		fmt.Println("FINAL_RC=1")
		return 1
	}

	sum := sha256.Sum256(data)

	fmt.Printf("evidence_file=%s\n", evidencePath)
	fmt.Printf("artifact_sha256=%s\n", hex.EncodeToString(sum[:]))
	fmt.Println()

	rc := runCommand(
		"go",
		"run",
		"./cmd/evidence-verify",
		"--file",
		evidencePath,
	)

	if rc != 0 {
		fmt.Printf("verifier_rc=%d\n", rc)
		fmt.Println("FINAL_VERDICT=EVIDENCE_VERIFY_FAILED")
		fmt.Println("FINAL_RC=1")
		return 1
	}

	fmt.Println()
	fmt.Println("CAPSULE_VERIFICATION=PASS")
	fmt.Println("FINAL_VERDICT=EVIDENCE_VERIFIED")
	fmt.Println("FINAL_RC=0")
	return 0
}

func runEvaluation() int {
	runID := "capsule-" + time.Now().UTC().Format("20060102T150405Z")

	fmt.Println("============================================================")
	fmt.Println("VRP PUBLIC EVALUATION CAPSULE")
	fmt.Println("UNIFIED EVALUATION RUN")
	fmt.Println("============================================================")
	fmt.Println()

	fmt.Printf("capsule_version=%s\n", version)
	fmt.Printf("run_id=%s\n", runID)
	fmt.Printf("started_at_utc=%s\n", time.Now().UTC().Format(time.RFC3339))
	fmt.Printf("platform=%s/%s\n", runtime.GOOS, runtime.GOARCH)
	fmt.Printf("go_runtime=%s\n", runtime.Version())

	if head := gitValue("rev-parse", "HEAD"); head != "" {
		fmt.Printf("git_head=%s\n", head)
	}

	if branch := gitValue("branch", "--show-current"); branch != "" {
		fmt.Printf("git_branch=%s\n", branch)
	}

	stages := []stageResult{
		executeInternalStage("doctor", runDoctor),
		executeInternalStage("verify-sample", runVerifySample),
		executeCommandStage("validation-model", "go", "run", "./cmd/vrp-test"),
		executeCommandStage("attack-model", "go", "run", "./cmd/attack-suite"),
		executeCommandStage("runtime-scenario-model", "go", "run", "./cmd/vrp-runtime-scenario"),
		evaluateDockerCapability(),
		evaluateNetemCapability(),
	}

	passed := 0
	failed := 0
	skipped := 0

	fmt.Println()
	fmt.Println("============================================================")
	fmt.Println("CAPSULE STAGE SUMMARY")
	fmt.Println("============================================================")

	for _, stage := range stages {
		fmt.Printf("STAGE=%s STATUS=%s RC=%d",
			stage.Name,
			stage.Status,
			stage.RC,
		)

		if stage.Detail != "" {
			fmt.Printf(" DETAIL=%s", quoteMachineValue(stage.Detail))
		}

		fmt.Println()

		switch stage.Status {
		case "PASS":
			passed++
		case "FAIL":
			failed++
		case "SKIPPED":
			skipped++
		}
	}

	fmt.Println()
	fmt.Println("============================================================")
	fmt.Println("MACHINE READABLE RESULT")
	fmt.Println("============================================================")
	fmt.Printf("CAPSULE_VERSION=%s\n", version)
	fmt.Printf("RUN_ID=%s\n", runID)
	fmt.Printf("PASSED=%d\n", passed)
	fmt.Printf("FAILED=%d\n", failed)
	fmt.Printf("SKIPPED=%d\n", skipped)

	if failed != 0 {
		fmt.Println("FINAL_RC=1")
		fmt.Println("FINAL_VERDICT=PUBLIC_EVALUATION_FAILED")
		fmt.Printf("completed_at_utc=%s\n", time.Now().UTC().Format(time.RFC3339))
		return 1
	}

	fmt.Println("FINAL_RC=0")

	if skipped != 0 {
		fmt.Println("FINAL_VERDICT=PUBLIC_EVALUATION_PASSED_WITH_SKIPPED_CAPABILITIES")
		fmt.Println("interpretation=skipped_capabilities_are_not_claimed_as_passed")
	} else {
		fmt.Println("FINAL_VERDICT=PUBLIC_EVALUATION_PASSED")
	}

	fmt.Printf("completed_at_utc=%s\n", time.Now().UTC().Format(time.RFC3339))
	return 0
}

func executeInternalStage(name string, fn func() int) stageResult {
	fmt.Println()
	fmt.Println("============================================================")
	fmt.Printf("STAGE: %s\n", name)
	fmt.Println("============================================================")

	rc := fn()

	result := stageResult{Name: name, RC: rc}

	if rc == 0 {
		result.Status = "PASS"
	} else {
		result.Status = "FAIL"
	}

	fmt.Println()
	fmt.Printf("STAGE=%s\n", name)
	fmt.Printf("RC=%d\n", rc)
	fmt.Printf("STATUS=%s\n", result.Status)

	return result
}

func executeCommandStage(name string, command string, args ...string) stageResult {
	fmt.Println()
	fmt.Println("============================================================")
	fmt.Printf("STAGE: %s\n", name)
	fmt.Println("============================================================")

	rc := runCommand(command, args...)

	result := stageResult{Name: name, RC: rc}

	if rc == 0 {
		result.Status = "PASS"
	} else {
		result.Status = "FAIL"
	}

	fmt.Println()
	fmt.Printf("STAGE=%s\n", name)
	fmt.Printf("RC=%d\n", rc)
	fmt.Printf("STATUS=%s\n", result.Status)

	return result
}

func evaluateDockerCapability() stageResult {
	fmt.Println()
	fmt.Println("============================================================")
	fmt.Println("STAGE: docker-capability")
	fmt.Println("============================================================")

	path, err := exec.LookPath("docker")
	if err != nil {
		fmt.Println("docker_available=false")
		fmt.Println("STATUS=SKIPPED")
		fmt.Println("reason=docker_command_not_available")
		fmt.Println("note=SKIPPED_IS_NOT_PASS")

		return stageResult{
			Name:   "docker-capability",
			Status: "SKIPPED",
			RC:     0,
			Detail: "docker command not available",
		}
	}

	cmd := exec.Command(path, "info")

	if err := cmd.Run(); err != nil {
		fmt.Printf("docker_path=%s\n", path)
		fmt.Println("docker_runtime_available=false")
		fmt.Println("STATUS=SKIPPED")
		fmt.Println("reason=docker_runtime_not_accessible")
		fmt.Println("note=SKIPPED_IS_NOT_PASS")

		return stageResult{
			Name:   "docker-capability",
			Status: "SKIPPED",
			RC:     0,
			Detail: "docker runtime not accessible",
		}
	}

	fmt.Printf("docker_path=%s\n", path)
	fmt.Println("docker_runtime_available=true")
	fmt.Println("STATUS=PASS")

	return stageResult{
		Name:   "docker-capability",
		Status: "PASS",
		RC:     0,
		Detail: "docker runtime available",
	}
}

func evaluateNetemCapability() stageResult {
	fmt.Println()
	fmt.Println("============================================================")
	fmt.Println("STAGE: netem-capability")
	fmt.Println("============================================================")

	path, err := exec.LookPath("tc")
	if err != nil {
		fmt.Println("tc_available=false")
		fmt.Println("STATUS=SKIPPED")
		fmt.Println("reason=tc_command_not_available")
		fmt.Println("note=SKIPPED_IS_NOT_PASS")

		return stageResult{
			Name:   "netem-capability",
			Status: "SKIPPED",
			RC:     0,
			Detail: "tc command not available",
		}
	}

	fmt.Printf("tc_path=%s\n", path)
	fmt.Println("tc_available=true")
	fmt.Println("STATUS=PASS")

	return stageResult{
		Name:   "netem-capability",
		Status: "PASS",
		RC:     0,
		Detail: "tc command available",
	}
}

func runCommand(command string, args ...string) int {
	cmd := exec.Command(command, args...)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	cmd.Stdin = os.Stdin

	if err := cmd.Run(); err != nil {
		if exitErr, ok := err.(*exec.ExitError); ok {
			return exitErr.ExitCode()
		}

		fmt.Fprintf(os.Stderr, "command_error=%s reason=%v\n", command, err)
		return 1
	}

	return 0
}

func gitValue(args ...string) string {
	cmd := exec.Command("git", args...)

	output, err := cmd.Output()
	if err != nil {
		return ""
	}

	return strings.TrimSpace(string(output))
}

func quoteMachineValue(value string) string {
	value = strings.ReplaceAll(value, "\\", "\\\\")
	value = strings.ReplaceAll(value, "\"", "\\\"")
	return "\"" + value + "\""
}

func sanitize(path string) string {
	result := ""

	for _, r := range filepath.ToSlash(path) {
		switch {
		case r >= 'a' && r <= 'z':
			result += string(r - 32)
		case r >= 'A' && r <= 'Z':
			result += string(r)
		case r >= '0' && r <= '9':
			result += string(r)
		default:
			result += "_"
		}
	}

	return result
}
