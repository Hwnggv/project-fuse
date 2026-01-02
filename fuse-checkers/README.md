# fuse-checkers

**Reference implementations of compliance checkers for the VCE protocol.**

This crate provides example checkers that demonstrate how to implement procedural verification logic for various use cases. These are **reference implementations** — downstream systems (like Witness) will build their own checkers.

## Overview

`fuse-checkers` contains example implementations of the `ComplianceChecker` trait. These checkers are used by the FUSE CLI tools and serve as documentation for how to build custom checkers.

## Available Checkers

- **SOC2 Control X**: Example SOC2 audit check
- **GDPR Data Residency**: GDPR data residency verification
- **Supply Chain Provenance**: Supply-chain provenance validation
- **ML Model Usage Constraint**: ML model usage constraint checking
- **Ed25519 Signature Verification**: Cryptographic signature verification
- **C2PA Signature Verification**: C2PA manifest parsing and signature verification
- **JSON Parsing Only**: Minimal checker for performance benchmarking

## Usage

Add to your `Cargo.toml`:

```toml
[dependencies]
fuse-checkers = "1.2.0"
fuse-core = "1.2.0"
```

## Example

```rust
use fuse_checkers::{CheckerRegistry, ComplianceChecker};
use fuse_core::{ComplianceSpec, ComplianceResult};

let registry = CheckerRegistry::new();
let checker = registry.get_checker("C2PA signature verification")?;
let result = checker.check(&spec, &system_data)?;
```

## Building Custom Checkers

Implement the `ComplianceChecker` trait:

```rust
use fuse_core::{ComplianceSpec, ComplianceResult, Result};
use fuse_checkers::ComplianceChecker;

pub struct MyCustomChecker;

impl ComplianceChecker for MyCustomChecker {
    fn check(&self, spec: &ComplianceSpec, system_data: &str) -> Result<ComplianceResult> {
        // Your verification logic here
        Ok(ComplianceResult::Pass)
    }
}
```

## Note

These checkers are **examples only**. Production systems should implement their own checkers based on their specific requirements and trust models.

## License

Licensed under the Apache License 2.0. See the main [Project FUSE repository](https://github.com/Mikebrown0409/project-fuse) for details.
