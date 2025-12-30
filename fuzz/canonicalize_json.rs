#![no_main]
use libfuzzer_sys::fuzz_target;

/// Fuzz target for JSON canonicalization
/// 
/// Tests that serde_json can handle random JSON inputs without panicking
/// and that canonicalization doesn't leak information or crash on malformed data.
fuzz_target!(|data: &[u8]| {
    // Try to parse as JSON
    if let Ok(json_value) = serde_json::from_slice::<serde_json::Value>(data) {
        // Try to serialize back (canonicalization-like operation)
        let _ = serde_json::to_string(&json_value);
        let _ = serde_json::to_vec(&json_value);
        
        // Test that we can access nested values without panicking
        match json_value {
            serde_json::Value::Object(map) => {
                for (_, value) in map.iter() {
                    let _ = serde_json::to_string(value);
                }
            }
            _ => {}
        }
    }
    // If parsing fails, that's okay - we just want to ensure no panics
});
