# Reproducibility Guide

## Purpose

The purpose of this guide is to allow independent organizations to reproduce published validation results using the VRP Validation Kit.

Engineering claims should be reproducible.

This guide explains how to perform that process.

---

# Step 1

Obtain the latest published Validation Kit.

Verify repository integrity.

Review the published documentation.

---

# Step 2

Prepare a supported environment.

Ensure required dependencies are installed.

Record:

- operating system

- architecture

- Go version

- validation date

---

# Step 3

Execute the published validation commands.

Follow the documented validation procedure without modification whenever possible.

---

# Step 4

Collect generated evidence.

Typical artifacts include:

- validation reports

- evidence bundles

- manifests

- hashes

- signatures

- runtime verdicts

---

# Step 5

Review the generated evidence.

Verify:

- evidence integrity

- validation completion

- published verdicts

- generated hashes

- reported runtime behavior

---

# Step 6

Compare your results with published reports.

Equivalent environments should produce equivalent engineering conclusions.

Minor environmental differences may influence timing.

They should not change validation correctness.

---

# Step 7

Document observations.

Independent evaluators are encouraged to record:

- environment

- executed procedures

- observed behavior

- validation verdict

- unexpected observations

---

# Recommended Engineering Practice

Perform validation more than once.

Repeat validation on different systems whenever practical.

Independent repetition increases engineering confidence.

---

# Reporting Differences

If observed behavior differs from published validation:

- preserve generated evidence

- preserve validation reports

- preserve hashes

- document the execution environment

Engineering discussion should be based on observable evidence.

---

# Engineering Philosophy

Validation is valuable only if independent engineers can reproduce it.

Engineering confidence increases when independent organizations obtain equivalent results using the same procedures.

---

# Final Principle

Do not rely on published conclusions alone.

Execute the validation yourself.

Review the evidence yourself.

Reach your own engineering conclusions.