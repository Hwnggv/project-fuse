#!/bin/bash
# Security audit script for FUSE project
# Runs cargo-audit, clippy security checks, and semgrep

set -e

echo "=========================================="
echo "FUSE Security Audit"
echo "=========================================="
echo ""

# Check if cargo-audit is installed
if ! command -v cargo-audit &> /dev/null; then
    echo "Installing cargo-audit..."
    cargo install cargo-audit --locked || {
        echo "Warning: Failed to install cargo-audit. Continuing with other checks..."
    }
fi

# Run cargo-audit
echo "1. Running cargo-audit (dependency vulnerability scan)..."
echo "----------------------------------------"
if command -v cargo-audit &> /dev/null; then
    cargo audit || {
        echo "Warning: cargo-audit found vulnerabilities. Review output above."
        echo "Continuing with other checks..."
    }
else
    echo "Skipping: cargo-audit not available"
fi

echo ""
echo "2. Running security-focused clippy checks..."
echo "----------------------------------------"
cargo clippy --workspace -- -D warnings -W clippy::suspicious -W clippy::cargo -W clippy::pedantic || {
    echo "Warning: Clippy found security-related warnings. Review output above."
}

echo ""
echo "3. Running semgrep (crypto pattern detection)..."
echo "----------------------------------------"
if command -v semgrep &> /dev/null; then
    semgrep --config=auto --config=r/crypto . || {
        echo "Warning: semgrep found potential issues. Review output above."
    }
else
    echo "Skipping: semgrep not installed. Install with: pip install semgrep"
    echo "  Or: brew install semgrep"
fi

echo ""
echo "=========================================="
echo "Security audit complete"
echo "=========================================="
echo ""
echo "Review findings above and document in docs/SECURITY_AUDIT.md"
