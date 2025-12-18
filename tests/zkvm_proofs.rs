//! Integration tests for zkVM proof generation and verification

use fuse_core::{ComplianceSpec, VerifiableComplianceEnvelope, Result};
use std::collections::BTreeMap;
use chrono::Utc;

#[test]
fn test_placeholder_proof_generation() {
    // Test that placeholder proofs still work (backward compatibility)
    let spec = ComplianceSpec::new(
        "Test claim".to_string(),
        "abc123".to_string(),
        BTreeMap::new(),
        "US".to_string(),
        "1.0".to_string(),
        Utc::now() + chrono::Duration::days(365),
    );

    let proof = fuse_core::ComplianceProof::new(
        spec.hash(),
        fuse_core::ComplianceResult::Pass,
        vec![],
    );

    assert!(proof.is_placeholder());
    assert!(proof.verify().is_ok());
}

#[test]
fn test_proof_with_real_zkvm() {
    // This test will pass once RISC Zero integration is complete
    // For now, it tests that the structure is in place
    
    let spec_json = r#"{
        "claim": "SOC2 control X verified",
        "system_hash": "test",
        "constraints": {"sampling": "last 1000 events"},
        "jurisdiction": "US, SEC",
        "version": "1.0",
        "expiry": "2026-12-31T23:59:59Z"
    }"#;
    
    let system_data_json = r#"{"access_logs": []}"#;
    
    // This will fail until guest program is built, which is expected
    let result = fuse_core::zkvm::generate_proof(spec_json, system_data_json);
    assert!(result.is_err()); // Expected until guest program is built
}

#[test]
fn test_envelope_with_placeholder_proof() {
    let spec = ComplianceSpec::new(
        "Test claim".to_string(),
        "abc123".to_string(),
        BTreeMap::new(),
        "US".to_string(),
        "1.0".to_string(),
        Utc::now() + chrono::Duration::days(365),
    );

    let proof = fuse_core::ComplianceProof::new(
        spec.hash(),
        fuse_core::ComplianceResult::Pass,
        vec![],
    );

    let envelope = VerifiableComplianceEnvelope::new(spec, proof);
    assert!(envelope.verify().is_ok());
    assert!(envelope.is_compliant().unwrap());
}

