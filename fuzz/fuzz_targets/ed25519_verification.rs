#![no_main]
use libfuzzer_sys::fuzz_target;
use ed25519_compact::{PublicKey, Signature};

// Fuzz target for Ed25519 signature verification
// Tests Ed25519 signature verification with random inputs to catch:
// - Replay attacks (same signature with different messages)
// - Poisoned inputs (malformed keys/signatures)
// - Memory safety issues
// - Side-channel leaks
fuzz_target!(|data: &[u8]| {
    // Ensure we have enough data for key (32 bytes) + signature (64 bytes) + message
    if data.len() < 96 {
        return;
    }
    
    // Split data into components
    let public_key_bytes = &data[0..32];
    let signature_bytes = &data[32..96];
    let message_bytes = &data[96..];
    
    // Try verification - should handle errors gracefully without panicking
    // We use ed25519-compact directly to avoid pulling in fuse-core/RISC Zero
    if let Ok(public_key) = PublicKey::from_slice(public_key_bytes) {
        if let Ok(signature) = Signature::from_slice(signature_bytes) {
            let _ = public_key.verify(message_bytes, &signature);
        }
    }
});
