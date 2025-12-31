#!/bin/bash
# C2PA Selective Disclosure Demo Script
# Demonstrates selective disclosure of C2PA manifests using FUSE

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Colors for output
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

SPEC_FILE="$SCRIPT_DIR/demo/c2pa-selective-disclosure-spec.json"
OUTPUT_FILE="$SCRIPT_DIR/demo/output.vce"

echo ""
echo -e "${CYAN}========================================${NC}"
echo -e "${CYAN}  C2PA Selective Disclosure Demo${NC}"
echo -e "${CYAN}========================================${NC}"
echo ""

# Check if spec file exists
if [ ! -f "$SPEC_FILE" ]; then
    echo -e "${YELLOW}Error: Spec file not found: $SPEC_FILE${NC}"
    exit 1
fi

# Check if we have a C2PA test fixture
FIXTURE_DIR="$PROJECT_ROOT/fuse-core/tests/fixtures/c2pa"
FIXTURE_FILE=""

if [ -d "$FIXTURE_DIR" ]; then
    # Try to find a C2PA fixture
    for file in "$FIXTURE_DIR"/*.jpg; do
        if [ -f "$file" ]; then
            FIXTURE_FILE="$file"
            break
        fi
    done
fi

if [ -z "$FIXTURE_FILE" ]; then
    echo -e "${YELLOW}Warning: No C2PA fixtures found in $FIXTURE_DIR${NC}"
    echo "Please download C2PA test fixtures or provide a C2PA-signed JPEG."
    exit 1
fi

echo "Using C2PA fixture: $(basename "$FIXTURE_FILE")"
echo ""

# Change to project root
cd "$PROJECT_ROOT"

# Build if needed
if [ ! -f "target/release/fuse-prove" ]; then
    echo "Building FUSE..."
    make build-guest
    cargo build --release
fi

# Generate proof
echo "Generating proof with selective disclosure..."
echo ""

RISC0_DEV_MODE=1 cargo run --release --bin fuse-prove -- \
    --spec "$SPEC_FILE" \
    --c2pa "$FIXTURE_FILE" \
    --output "$OUTPUT_FILE" \
    --prover local

if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}✓ Proof generated successfully!${NC}"
    echo ""
    echo "Output file: $OUTPUT_FILE"
    echo ""
    echo "To verify the proof:"
    echo "  cargo run --release --bin fuse-verify -- $OUTPUT_FILE"
else
    echo ""
    echo -e "${YELLOW}Proof generation failed. Check errors above.${NC}"
    exit 1
fi
