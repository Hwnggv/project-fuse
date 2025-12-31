#!/bin/bash
# GPU Setup Fix Script - Addresses all pre-flight check failures
set -e

echo "=========================================="
echo "GPU Setup Fix Script"
echo "=========================================="
echo ""

# 1. Setup CUDA Environment
echo "1. Setting up CUDA environment..."
if [ -d /usr/local/cuda-11.8 ]; then
    export PATH="/usr/local/cuda-11.8/bin:$PATH"
    export LD_LIBRARY_PATH="/usr/local/cuda-11.8/lib64:$LD_LIBRARY_PATH"
    echo "  ✓ CUDA 11.8 paths configured"
elif [ -d /usr/local/cuda ]; then
    export PATH="/usr/local/cuda/bin:$PATH"
    export LD_LIBRARY_PATH="/usr/local/cuda/lib64:$LD_LIBRARY_PATH"
    echo "  ✓ CUDA paths configured"
else
    echo "  ✗ CUDA not found, need to install"
    exit 1
fi

# Verify CUDA
if command -v nvcc &> /dev/null; then
    CUDA_VERSION=$(nvcc --version | grep -oP 'release \K[0-9]+\.[0-9]+')
    echo "  ✓ CUDA version: $CUDA_VERSION"
    if [ "$CUDA_VERSION" != "11.8" ]; then
        echo "  ⚠ Warning: CUDA $CUDA_VERSION detected, 11.8 recommended"
    fi
else
    echo "  ✗ nvcc not found in PATH"
    exit 1
fi

# 2. Install GCC 12
echo ""
echo "2. Checking GCC version..."
GCC_VERSION=$(gcc --version | head -n1 | grep -oP '\d+' | head -n1)
if [ "$GCC_VERSION" -gt "12" ]; then
    echo "  Installing GCC 12..."
    sudo apt-get update -qq
    sudo apt-get install -y gcc-12 g++-12
    export CC=gcc-12
    export CXX=g++-12
    echo "  ✓ GCC 12 installed and set"
elif [ "$GCC_VERSION" -eq "12" ]; then
    echo "  ✓ GCC 12 already installed"
    export CC=gcc-12
    export CXX=g++-12
else
    echo "  ⚠ GCC $GCC_VERSION detected, installing GCC 12 as backup..."
    sudo apt-get update -qq
    sudo apt-get install -y gcc-12 g++-12
    export CC=gcc-12
    export CXX=g++-12
fi

# 3. Setup Rust Environment
echo ""
echo "3. Setting up Rust environment..."
if [ -f "$HOME/.cargo/env" ]; then
    source "$HOME/.cargo/env"
    echo "  ✓ Cargo environment sourced"
else
    echo "  ✗ Cargo environment not found"
    exit 1
fi

# Verify Rust
if command -v rustc &> /dev/null && command -v cargo &> /dev/null; then
    echo "  ✓ Rust: $(rustc --version)"
    echo "  ✓ Cargo: $(cargo --version)"
else
    echo "  ✗ Rust/Cargo not found"
    exit 1
fi

# 4. Check RISC Zero toolchain (custom toolchain, not rustup target)
echo ""
echo "4. Checking RISC Zero toolchain..."
if [ -d "$HOME/.risc0/toolchains" ]; then
    RISC0_RUSTC=$(find "$HOME/.risc0/toolchains" -name "rustc" -type f | head -1)
    if [ -n "$RISC0_RUSTC" ]; then
        echo "  ✓ RISC Zero toolchain found: $RISC0_RUSTC"
        export RUSTC="$RISC0_RUSTC"
    else
        echo "  ⚠ RISC Zero toolchain directory exists but rustc not found"
        echo "  Run: rzup install rust"
    fi
else
    echo "  ⚠ RISC Zero toolchain not found"
    echo "  Run: rzup install rust"
fi

# 5. Clone/Update Project
echo ""
echo "5. Setting up project..."
if [ -d /tmp/fuse ]; then
    echo "  Project exists, updating..."
    cd /tmp/fuse
    git pull origin main || echo "  ⚠ Git pull failed, continuing..."
else
    echo "  Cloning project..."
    cd /tmp
    if git clone https://github.com/Mikebrown0409/project-fuse.git fuse 2>/dev/null; then
        echo "  ✓ Cloned via HTTPS"
    else
        echo "  ✗ Git clone failed"
        exit 1
    fi
    cd fuse
fi

if [ -f Cargo.toml ]; then
    echo "  ✓ Project ready"
else
    echo "  ✗ Cargo.toml not found"
    exit 1
fi

# 6. Check RISC Zero version and update if needed
echo ""
echo "6. Checking RISC Zero version..."
CURRENT_VERSION=$(grep -A 2 "risc0-zkvm" Cargo.toml | grep "version" | head -1 | grep -oP '"\K[0-9]+\.[0-9]+' || echo "unknown")
echo "  Current version: $CURRENT_VERSION"

if [ "$CURRENT_VERSION" == "1.0" ]; then
    echo "  ⚠ RISC Zero 1.0 detected. Checking for updates..."
    # Check latest version available
    LATEST=$(cargo search risc0-zkvm 2>/dev/null | head -1 | grep -oP 'risc0-zkvm = "\K[0-9]+\.[0-9]+' || echo "unknown")
    if [ "$LATEST" != "unknown" ] && [ "$LATEST" != "$CURRENT_VERSION" ]; then
        echo "  Latest available: $LATEST"
        echo "  Consider updating Cargo.toml to version \"$LATEST\" for better CUDA support"
    fi
fi

# 7. Clean build state (optional, but recommended)
echo ""
echo "7. Build state..."
if [ -d target ]; then
    echo "  ⚠ target/ directory exists. Consider 'cargo clean' for fresh build"
else
    echo "  ✓ Clean build state"
fi

# 8. Export environment for build
echo ""
echo "8. Creating build environment script..."
cat > /tmp/fuse-build-env.sh << 'ENVEOF'
#!/bin/bash
# Source this before building: source /tmp/fuse-build-env.sh

export PATH="/usr/local/cuda-11.8/bin:/usr/local/cuda/bin:$PATH"
export LD_LIBRARY_PATH="/usr/local/cuda-11.8/lib64:/usr/local/cuda/lib64:$LD_LIBRARY_PATH"
export CC=gcc-12
export CXX=g++-12

if [ -f "$HOME/.cargo/env" ]; then
    source "$HOME/.cargo/env"
fi

cd /tmp/fuse
ENVEOF
chmod +x /tmp/fuse-build-env.sh
echo "  ✓ Build environment script created at /tmp/fuse-build-env.sh"

echo ""
echo "=========================================="
echo "Setup Complete!"
echo "=========================================="
echo ""
echo "Next steps:"
echo "1. Source the build environment: source /tmp/fuse-build-env.sh"
echo "2. Build guest program: cargo build -p fuse-guest --release --target riscv32im-risc0-zkvm-elf"
echo "3. Build with GPU: cargo build --release --workspace --features gpu"
echo ""
