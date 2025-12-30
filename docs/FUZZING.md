# Fuzzing Guide

This document describes the fuzzing infrastructure for Project FUSE and how to run fuzz tests.

## Overview

Fuzzing is a critical security testing technique that feeds random, malformed, or unexpected inputs to programs to find bugs, crashes, and security vulnerabilities. Project FUSE uses `cargo-fuzz` with libFuzzer to test critical code paths.

## Fuzz Targets

We have 5 fuzz targets covering different aspects of the codebase:

### 1. `canonicalize_json`
- **Purpose**: Tests JSON canonicalization and parsing
- **What it fuzzes**: Random JSON inputs to `serde_json`
- **Security focus**: Memory safety, no panics on malformed JSON

### 2. `c2pa_parser`
- **Purpose**: Tests C2PA manifest parsing
- **What it fuzzes**: Corrupted/random JPEG/C2PA payloads
- **Security focus**: Graceful error handling, no data leaks on invalid inputs

### 3. `ed25519_verification`
- **Purpose**: Tests Ed25519 signature verification
- **What it fuzzes**: Random public keys, signatures, and messages
- **Security focus**: Replay attack detection, poisoned input handling, memory safety

### 4. `spec_validation`
- **Purpose**: Tests compliance spec parsing and validation
- **What it fuzzes**: Malformed JSON specs, missing fields, invalid types
- **Security focus**: Input validation, no panics on invalid specs

### 5. `borsh_decode`
- **Purpose**: Tests Borsh deserialization (used by RISC Zero journals)
- **What it fuzzes**: Random binary data
- **Security focus**: Buffer overflow prevention, memory safety

## Running Fuzz Tests Locally

### Prerequisites

```bash
# Install cargo-fuzz
cargo install cargo-fuzz --locked

# Ensure project builds
cargo build --workspace
```

### Running Individual Targets

```bash
cd fuzz

# Run a specific target for 1 hour
cargo fuzz run canonicalize_json --fuzz-time 3600s

# Run with more verbose output
cargo fuzz run c2pa_parser --fuzz-time 3600s -- -max_total_time=3600 -print_final_stats=1
```

### Running All Targets

```bash
cd fuzz

# Run each target sequentially
for target in canonicalize_json c2pa_parser ed25519_verification spec_validation borsh_decode; do
    echo "Fuzzing $target..."
    cargo fuzz run $target --fuzz-time 3600s
done
```

## CI Integration

Fuzzing runs automatically in GitHub Actions:
- **On every push/PR**: Quick fuzz run (1 hour per target)
- **Nightly**: Extended fuzzing runs
- **Manual trigger**: Use "workflow_dispatch" to run on demand

See `.github/workflows/fuzz.yml` for configuration.

## Success Criteria

- ✅ All fuzz targets compile without errors
- ✅ No crashes after 1M+ iterations per target
- ✅ All targets handle malformed inputs gracefully (no panics)
- ✅ Fuzzing integrated into CI pipeline

## Interpreting Results

### Crashes Found

If a fuzzer finds a crash:
1. **Don't panic** - This is why we fuzz!
2. **Reproduce**: `cargo fuzz run <target> <crash_file>`
3. **Fix**: Address the root cause
4. **Verify**: Re-run fuzzing to ensure fix works
5. **Document**: Add to `docs/SECURITY_AUDIT.md`

### Common Issues

- **Panics on invalid input**: Should return errors, not panic
- **Memory leaks**: Use tools like `valgrind` or `cargo-valgrind`
- **Slow performance**: May indicate inefficient code paths

## Seed Corpus

Fuzzers work better with seed inputs. We use:
- Test fixtures from `fuse-core/tests/fixtures/c2pa/`
- Example specs from `examples/specs/`
- Valid C2PA assets for `c2pa_parser` target

To add seeds:
```bash
cd fuzz
mkdir -p fuzz_targets/<target>/in/
cp ../fuse-core/tests/fixtures/c2pa/*.jpg fuzz_targets/c2pa_parser/in/
```

## Security Focus Areas

### Replay Attacks
- Ed25519 fuzzer tests that same signature with different messages fails
- Proof timestamp validation prevents replay

### Poisoned Inputs
- All parsers handle malformed data without leaking information
- ZK doesn't expose data on invalid inputs

### Memory Safety
- No buffer overflows
- No use-after-free
- No undefined behavior

### Side-Channel Resistance
- Note: Dev mode is not side-channel resistant
- Real proofs use RISC Zero's secure implementation

## Continuous Improvement

- **Add more targets**: As new features are added, add fuzz targets
- **Improve seeds**: Better seed corpus = better fuzzing coverage
- **Monitor coverage**: Use `cargo-fuzz` coverage reports to find gaps
- **Fix issues promptly**: Don't let crashes accumulate

## Resources

- [cargo-fuzz documentation](https://github.com/rust-fuzz/cargo-fuzz)
- [libFuzzer documentation](https://llvm.org/docs/LibFuzzer.html)
- [Rust Fuzz Book](https://rust-fuzz.github.io/book/)
