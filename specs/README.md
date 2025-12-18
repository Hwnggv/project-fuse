# VCE Specification Directory

This directory contains the formal specification for the Verifiable Compliance Envelope (VCE) format.

## Contents

- **[VCE_SPECIFICATION_V0.1.md](VCE_SPECIFICATION_V0.1.md)**: The complete VCE specification document
- **[schemas/](schemas/)**: JSON Schema files for validation

## Specification Document

The [VCE Specification v0.1](VCE_SPECIFICATION_V0.1.md) defines:
- VCE file format (`.vce` files)
- ComplianceSpec format (input specifications)
- Proof format (RISC Zero receipts)
- Verification process
- Security considerations
- Examples

## JSON Schemas

The `schemas/` directory contains JSON Schema files for validating VCE files and input specifications:

- **[vce-schema.json](schemas/vce-schema.json)**: Validates complete `.vce` files
- **[compliance-spec-schema.json](schemas/compliance-spec-schema.json)**: Validates input `ComplianceSpec` files

### Using the Schemas

#### Validating with Python

```python
import json
import jsonschema

# Load schema
with open('specs/schemas/vce-schema.json') as f:
    schema = json.load(f)

# Load VCE file
with open('compliance.vce') as f:
    vce = json.load(f)

# Validate
try:
    jsonschema.validate(instance=vce, schema=schema)
    print("Valid VCE file")
except jsonschema.exceptions.ValidationError as e:
    print(f"Validation error: {e.message}")
```

#### Validating with Node.js

```javascript
const Ajv = require('ajv');
const ajv = new Ajv();

// Load schema
const schema = require('./specs/schemas/vce-schema.json');

// Load VCE file
const vce = require('./compliance.vce');

// Validate
const validate = ajv.compile(schema);
const valid = validate(vce);

if (!valid) {
    console.log('Validation errors:', validate.errors);
} else {
    console.log('Valid VCE file');
}
```

#### Validating with Rust

```rust
use jsonschema::JSONSchema;

// Load schema
let schema_str = std::fs::read_to_string("specs/schemas/vce-schema.json")?;
let schema_value: serde_json::Value = serde_json::from_str(&schema_str)?;
let schema = JSONSchema::compile(&schema_value)?;

// Load VCE file
let vce_str = std::fs::read_to_string("compliance.vce")?;
let vce_value: serde_json::Value = serde_json::from_str(&vce_str)?;

// Validate
if let Err(errors) = schema.validate(&vce_value) {
    for error in errors {
        println!("Validation error: {}", error);
    }
} else {
    println!("Valid VCE file");
}
```

## Versioning

The specification is versioned. Current version: **v0.1**

See the [VCE Specification v0.1](VCE_SPECIFICATION_V0.1.md) for versioning policy and changelog.

## Contributing

If you find issues with the specification or schemas, please:
1. Open an issue on GitHub
2. Propose changes via pull request
3. Ensure changes maintain backward compatibility where possible

## References

- [VCE Specification v0.1](VCE_SPECIFICATION_V0.1.md)
- [JSON Schema Specification](https://json-schema.org/)
- [Project FUSE Repository](../README.md)

