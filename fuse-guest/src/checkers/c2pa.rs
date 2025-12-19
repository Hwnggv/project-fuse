//! C2PA signature verification checker (guest program)
//!
//! This checker verifies C2PA signatures using Ed25519.
//! C2PA signatures are Ed25519 signatures over C2PA claim data.
//!
//! The system_data should contain:
//! - `public_key`: Ed25519 public key (hex-encoded, 32 bytes)
//! - `message`: Signed message/claim data (hex-encoded)
//! - `signature`: Ed25519 signature (hex-encoded, 64 bytes)

use serde_json::Value;
use crate::checker::ComplianceResult;
use ed25519_dalek::{VerifyingKey, Signature};

pub fn check(_spec: &Value, system_data: &Value) -> ComplianceResult {
    // Extract public key, message, and signature from system_data
    let public_key_hex = match system_data.get("public_key").and_then(|v| v.as_str()) {
        Some(hex) => hex,
        None => return ComplianceResult::Fail,
    };

    let message_hex = match system_data.get("message").and_then(|v| v.as_str()) {
        Some(hex) => hex,
        None => return ComplianceResult::Fail,
    };

    let signature_hex = match system_data.get("signature").and_then(|v| v.as_str()) {
        Some(hex) => hex,
        None => return ComplianceResult::Fail,
    };

    // Decode hex strings to bytes
    let public_key_bytes = match hex::decode(public_key_hex) {
        Ok(bytes) => bytes,
        Err(_) => return ComplianceResult::Fail,
    };

    let message_bytes = match hex::decode(message_hex) {
        Ok(bytes) => bytes,
        Err(_) => return ComplianceResult::Fail,
    };

    let signature_bytes = match hex::decode(signature_hex) {
        Ok(bytes) => bytes,
        Err(_) => return ComplianceResult::Fail,
    };

    // Validate lengths
    if public_key_bytes.len() != 32 {
        return ComplianceResult::Fail;
    }
    if signature_bytes.len() != 64 {
        return ComplianceResult::Fail;
    }

    // Convert to arrays for Ed25519 verification
    let public_key_array: [u8; 32] = match public_key_bytes.try_into() {
        Ok(arr) => arr,
        Err(_) => return ComplianceResult::Fail,
    };
    let signature_array: [u8; 64] = match signature_bytes.try_into() {
        Ok(arr) => arr,
        Err(_) => return ComplianceResult::Fail,
    };

    // Create verifying key
    let public_key = match VerifyingKey::from_bytes(&public_key_array) {
        Ok(key) => key,
        Err(_) => return ComplianceResult::Fail,
    };

    // Create signature
    let signature = Signature::from_bytes(&signature_array);

    // Verify signature
    match public_key.verify_strict(&message_bytes, &signature) {
        Ok(_) => ComplianceResult::Pass,
        Err(_) => ComplianceResult::Fail,
    }
}

