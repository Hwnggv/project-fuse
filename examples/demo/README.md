# C2PA Selective Disclosure Demo

This demo demonstrates selective disclosure of C2PA manifests: **cryptographically proving that a full C2PA manifest was verified, while only revealing a small, chosen subset of fields**.

## What This Demo Shows

- Parse a C2PA manifest from a JPEG image
- Generate a zero-knowledge proof that verifies the full manifest
- Only disclose selected fields in the proof journal (privacy-preserving)
- Verify the proof cryptographically

## Running the Demo

From the project root:

```bash
./examples/demo-c2pa-selective-disclosure.sh
```

Or from the `examples/` directory:

```bash
cd examples
./demo-c2pa-selective-disclosure.sh
```

## How It Works

1. **Parse C2PA Manifest**: Extracts signature data from a C2PA-signed JPEG
2. **Generate Proof**: Creates a zkVM proof that verifies the entire manifest
3. **Selective Disclosure**: Only specified fields appear in the proof journal
4. **Verify**: Cryptographically verifies the proof

The demo uses `c2pa-selective-disclosure-spec.json` (in the `demo/` directory), which specifies:
- Which fields to disclose: `claim_generator`, `capture_time`, `issuer`
- All other fields remain hidden (proven but not revealed)

You can modify `c2pa-selective-disclosure-spec.json` to change which fields are disclosed. The selective disclosure operates at **top-level JSON keys only** (no nested field selection in v0.1).

## Requirements

- RISC Zero toolchain installed (`rzup install`)
- Guest program built (`make build-guest`)
- A C2PA-signed JPEG image (or use the test fixtures)

## Example Output

```
Parsing C2PA manifest...
Generating proof...
Proof generated successfully!

Journal Output:
{
  "claim_generator": "Adobe Photoshop",
  "capture_time": "2022-01-24T12:00:00Z",
  "issuer": "Adobe"
}

(Note: Other fields like location, creator, etc. are proven but not revealed)
```

## Files

- `demo-c2pa-selective-disclosure.sh` - Main demo script
- `c2pa-selective-disclosure-spec.json` - Selective disclosure specification
- `output.vce` - Generated compliance envelope

## Learn More

- Review the [Architecture Documentation](../../docs/ARCHITECTURE.md)
- Check [C2PA Integration Tests](../../fuse-core/tests/c2pa_integration.rs) for examples
- Explore modifying `c2pa-selective-disclosure-spec.json` to disclose different fields
