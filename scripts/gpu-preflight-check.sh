#!/bin/bash
# GPU Pre-flight Verification Script
# Based on Grok's recommendations for RISC Zero CUDA compatibility

set -e

echo "=========================================="
echo "GPU Pre-Flight Verification Checklist"
echo "=========================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

ERRORS=0
WARNINGS=0

# Function to check and report
check_item() {
    local name=$1
    local check_cmd=$2
    local expected=$3
    
    echo -n "Checking $name... "
    if eval "$check_cmd" > /dev/null 2>&1; then
        local result=$(eval "$check_cmd" 2>/dev/null)
        if [ -n "$expected" ]; then
            if [[ "$result" == *"$expected"* ]] || [ "$result" == "$expected" ]; then
                echo -e "${GREEN}✓${NC} ($result)"
            else
                echo -e "${RED}✗${NC} Got: $result, Expected: $expected"
                ERRORS=$((ERRORS + 1))
            fi
        else
            echo -e "${GREEN}✓${NC} ($result)"
        fi
    else
        echo -e "${RED}✗${NC} Not found or failed"
        ERRORS=$((ERRORS + 1))
    fi
}

warn_item() {
    local name=$1
    local check_cmd=$2
    local warning_msg=$3
    
    echo -n "Checking $name... "
    if eval "$check_cmd" > /dev/null 2>&1; then
        local result=$(eval "$check_cmd" 2>/dev/null)
        echo -e "${GREEN}✓${NC} ($result)"
    else
        echo -e "${YELLOW}⚠${NC} $warning_msg"
        WARNINGS=$((WARNINGS + 1))
    fi
}

echo "1. CUDA Setup Verification"
echo "---------------------------"
check_item "CUDA Toolkit installed" "nvcc --version" "release"
check_item "CUDA Version" "nvcc --version | grep -oP 'release \K[0-9]+\.[0-9]+'" "11.8"
check_item "CUDA lib64 exists" "[ -d /usr/local/cuda/lib64 ]" ""
check_item "CUDA bin in PATH" "echo \$PATH | grep -q cuda" ""
check_item "LD_LIBRARY_PATH set" "[ -n \"\$LD_LIBRARY_PATH\" ] && echo \$LD_LIBRARY_PATH | grep -q cuda" ""

echo ""
echo "2. GCC Version Check (Critical for CUDA)"
echo "-----------------------------------------"
GCC_VERSION=$(gcc --version | head -n1 | grep -oP '\d+' | head -n1)
echo -n "Checking GCC version... "
if [ -n "$GCC_VERSION" ]; then
    if [ "$GCC_VERSION" -gt "12" ]; then
        echo -e "${RED}✗${NC} GCC $GCC_VERSION detected (too high, should be 12)"
        echo "  → Install GCC 12: sudo apt install gcc-12 g++-12"
        echo "  → Set: export CC=gcc-12 CXX=g++-12"
        ERRORS=$((ERRORS + 1))
    elif [ "$GCC_VERSION" -eq "12" ]; then
        echo -e "${GREEN}✓${NC} GCC $GCC_VERSION (correct)"
    else
        echo -e "${YELLOW}⚠${NC} GCC $GCC_VERSION (may work, but GCC 12 recommended)"
        WARNINGS=$((WARNINGS + 1))
    fi
else
    echo -e "${RED}✗${NC} Could not determine GCC version"
    ERRORS=$((ERRORS + 1))
fi

# Check if gcc-12 is available
warn_item "GCC 12 available" "which gcc-12" "Install with: sudo apt install gcc-12 g++-12"

echo ""
echo "3. RISC Zero Setup"
echo "------------------"
check_item "RISC Zero toolchain" "[ -d \$HOME/.risc0/toolchains ]" ""
check_item "RISC Zero Rust toolchain" "ls \$HOME/.risc0/toolchains/*/bin/rustc 2>/dev/null | head -1" ""
warn_item "rzup installed" "which rzup || cargo rzup --version 2>/dev/null" "May need: cargo install cargo-risczero"

echo ""
echo "4. Rust Environment"
echo "-------------------"
check_item "Rust installed" "rustc --version" ""
check_item "Cargo installed" "cargo --version" ""
check_item "RISC Zero target installed" "rustup target list | grep -q riscv32im-risc0-zkvm-elf" ""

echo ""
echo "5. Project State"
echo "----------------"
check_item "Project directory exists" "[ -d /tmp/fuse ]" ""
check_item "Cargo.toml exists" "[ -f /tmp/fuse/Cargo.toml ]" ""
check_item "Guest program source exists" "[ -f /tmp/fuse/fuse-guest/Cargo.toml ]" ""

echo ""
echo "6. Build Environment"
echo "-------------------"
warn_item "Clean build state" "[ ! -d /tmp/fuse/target ] || echo 'target/ exists (may need cargo clean)'" "Consider: cargo clean before build"

echo ""
echo "7. RISC Zero Version Check"
echo "--------------------------"
if [ -f /tmp/fuse/Cargo.toml ]; then
    RISC0_VERSION=$(grep -A 2 "risc0-zkvm" /tmp/fuse/Cargo.toml | grep "version" | head -1 | grep -oP '"\K[0-9]+\.[0-9]+' || echo "unknown")
    echo -n "Checking RISC Zero version in Cargo.toml... "
    if [ "$RISC0_VERSION" != "unknown" ]; then
        echo -e "${GREEN}✓${NC} $RISC0_VERSION"
        if [ "$RISC0_VERSION" == "1.0" ]; then
            echo -e "  ${YELLOW}⚠${NC} Consider updating to 1.1.2+ for better CUDA support"
            WARNINGS=$((WARNINGS + 1))
        fi
    else
        echo -e "${YELLOW}⚠${NC} Could not determine version"
        WARNINGS=$((WARNINGS + 1))
    fi
else
    echo -e "${YELLOW}⚠${NC} Cargo.toml not found, skipping version check"
    WARNINGS=$((WARNINGS + 1))
fi

echo ""
echo "=========================================="
echo "Summary"
echo "=========================================="
if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo -e "${GREEN}✓ All checks passed! Safe to proceed with build.${NC}"
    exit 0
elif [ $ERRORS -eq 0 ]; then
    echo -e "${YELLOW}⚠ $WARNINGS warning(s) found. Review above before building.${NC}"
    exit 0
else
    echo -e "${RED}✗ $ERRORS error(s) found. Fix these before building!${NC}"
    echo -e "${RED}✗ $WARNINGS warning(s) found.${NC}"
    exit 1
fi
