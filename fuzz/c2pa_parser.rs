#![no_main]
use libfuzzer_sys::fuzz_target;
use fuse_cli::c2pa::parse_c2pa_manifest;

/// Fuzz target for C2PA manifest parsing
/// 
/// Tests that C2PA parser handles corrupted/random payloads gracefully
/// without panicking or leaking data on invalid inputs.
fuzz_target!(|data: &[u8]| {
    // Create a temporary file with fuzzed data
    let temp_file = std::env::temp_dir().join(format!("fuzz_c2pa_{}.jpg", std::process::id()));
    
    // Write fuzzed data to temp file
    if std::fs::write(&temp_file, data).is_err() {
        return;
    }
    
    // Try to parse - should handle errors gracefully
    let _ = parse_c2pa_manifest(temp_file.to_str().unwrap_or(""));
    
    // Clean up
    let _ = std::fs::remove_file(&temp_file);
});
