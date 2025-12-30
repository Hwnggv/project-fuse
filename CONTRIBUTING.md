# Contributing to Project FUSE

Thank you for your interest in contributing to Project FUSE! This document provides guidelines and instructions for contributing.

## Code of Conduct

This project adheres to a Code of Conduct that all contributors are expected to follow. Please read [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md) before contributing.

## How to Contribute

### Reporting Bugs

- Use the GitHub issue tracker to report bugs
- Include a clear title and description
- Provide steps to reproduce the issue
- Include relevant logs, error messages, or screenshots
- Specify your environment (OS, Rust version, etc.)

### Suggesting Enhancements

- Open an issue with the "enhancement" label
- Clearly describe the feature and its use case
- Explain why this feature would be useful
- Consider implementation approaches if you have ideas

### Pull Requests

1. **Fork the repository** and create a branch from `main`
2. **Make your changes** following our coding standards
3. **Write or update tests** as needed
4. **Update documentation** if you've changed functionality
5. **Run tests** to ensure everything passes:
   ```bash
   make test
   make lint
   ```
6. **Commit your changes** with clear, descriptive commit messages
7. **Push to your fork** and open a Pull Request

## Development Setup

### Prerequisites

- Rust 1.70+ (stable)
- RISC Zero toolchain (for zkVM development)
- Cargo

### Building the Project

```bash
# Install RISC Zero toolchain
rzup install

# Build the project
make build

# Run tests
make test
```

### Project Structure

- `fuse-core/` - Core VCE protocol implementation
- `fuse-cli/` - Command-line tools
- `fuse-guest/` - zkVM guest program
- `fuse-checkers/` - Compliance checker implementations
- `examples/` - Example specifications and test data
- `docs/` - Documentation

## Coding Standards

### Rust Style

- Follow standard Rust formatting (`cargo fmt`)
- Run `cargo clippy` and fix warnings
- Use meaningful variable and function names
- Add comments for complex logic
- Write unit tests for new functionality

### Code Formatting

```bash
# Format code
make fmt

# Run linter
make lint
```

### Testing

- Write tests for new features
- Ensure all tests pass: `make test`
- Use `RISC0_DEV_MODE=1` for fast test execution
- Add integration tests in `fuse-core/tests/`

### Documentation

- Update relevant documentation when adding features
- Add doc comments to public APIs
- Keep README and docs up to date

## Commit Messages

Use clear, descriptive commit messages:

```
Short summary (50 chars or less)

More detailed explanation if needed. Wrap at 72 characters.
Explain what and why, not how.

- Bullet points are okay
- Use present tense ("Add feature" not "Added feature")
```

## Review Process

1. All PRs require review before merging
2. Maintainers will review code quality, tests, and documentation
3. Address feedback promptly
4. PRs should pass CI checks (tests, linting, formatting)

## License

By contributing to Project FUSE, you agree that your contributions will be licensed under the Apache License 2.0.

## Important: Open Source Only

**Project FUSE is open-source software (Apache 2.0).**

### What Belongs in FUSE (OSS)

- ✅ Core VCE protocol implementation
- ✅ Zero-knowledge proof generation and verification
- ✅ Compliance checker framework
- ✅ CLI tools and utilities
- ✅ Documentation and examples
- ✅ Test fixtures and test data
- ✅ Open standards and specifications

### What Does NOT Belong in FUSE (Proprietary)

- ❌ Business-specific logic or integrations
- ❌ Proprietary algorithms or trade secrets
- ❌ Customer-specific configurations or data
- ❌ Commercial/proprietary features
- ❌ Internal business plans or strategies
- ❌ Proprietary products built on top of FUSE (keep those in separate repositories)

### Separation Principle

FUSE provides the **open-source foundation** (protocol, proof generation, verification). Proprietary products should be built **on top of** FUSE as separate repositories/products, not within FUSE itself.

**If you're unsure whether something belongs in FUSE:**
- Ask yourself: "Would this be useful to anyone building on FUSE?"
- If it's business-specific or proprietary, it belongs in a separate repository
- When in doubt, open an issue to discuss

## Questions?

- Open an issue for questions or discussions
- Check existing documentation in `docs/`
- Review [ARCHITECTURE.md](docs/ARCHITECTURE.md) for technical details

Thank you for contributing to Project FUSE!
