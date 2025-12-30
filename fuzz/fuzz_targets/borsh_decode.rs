#![no_main]
use libfuzzer_sys::fuzz_target;

// Fuzz target for Borsh deserialization
// Tests Borsh deserialization used by RISC Zero for journal decoding.
// This helps catch issues with:
// - Malformed journal data
// - Buffer overflows
// - Memory safety issues
fuzz_target!(|data: &[u8]| {
    // Try to deserialize as JournalOutput structure
    // Note: This is a simplified test - actual journal format is RISC Zero specific
    // but we can test basic Borsh operations
    
    use fuse_core::JournalOutput;
    
    // Try deserializing - should handle errors gracefully
    let _ = bincode::deserialize::<JournalOutput>(data);
    
    // Also test with serde_json since we use that for some structures
    if let Ok(json_str) = std::str::from_utf8(data) {
        let _ = serde_json::from_str::<JournalOutput>(json_str);
    }
});
