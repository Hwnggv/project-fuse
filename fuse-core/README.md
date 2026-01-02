# fuse-core

**Core VCE protocol implementation for verifiable procedural proofs.**

This crate provides the fundamental data structures and operations for creating and verifying Verifiable Compliance Envelopes (VCE).

## Overview

`fuse-core` is the stable, infrastructure-only layer of Project FUSE. It proves *that* a procedural verification ran to completion; it does not assert the *truth* of the content being verified.

## Key Components

- **`ComplianceSpec`**: Defines what needs to be verified
- **`VerifiableComplianceEnvelope`**: The complete VCE artifact
- **`ComplianceProof`**: Zero-knowledge proof structure
- **`ComplianceResult`**: Pass/Fail enumeration
- **`JournalOutput`**: Decoded journal data from zkVM execution

## Usage

Add to your `Cargo.toml`:

```toml
[dependencies]
fuse-core = "1.2.0"
```

## Example

```rust
use fuse_core::{ComplianceSpec, VerifiableComplianceEnvelope, Result};

// Create a compliance specification
let spec = ComplianceSpec::new(
    "Example claim".to_string(),
    "system_hash".to_string(),
    Default::default(),
    "jurisdiction".to_string(),
    "1.0".to_string(),
    chrono::Utc::now() + chrono::Duration::days(365),
);

// Load and verify an envelope
let mut envelope = VerifiableComplianceEnvelope::from_file("proof.vce")?;
envelope.verify()?;
let is_compliant = envelope.is_compliant()?;
```

## Stability

As of v1.0.0, the core proof format and verification semantics are considered stable. Breaking changes will only be introduced in v2.0.0.

## License

Licensed under the Apache License 2.0. See the main [Project FUSE repository](https://github.com/Mikebrown0409/project-fuse) for details.
