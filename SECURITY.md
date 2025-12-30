# Security Policy

## Supported Versions

We provide security updates for the following versions:

| Version | Supported          |
| ------- | ------------------ |
| 1.1.x   | :white_check_mark: |
| < 1.1   | :x:                |

## Reporting a Vulnerability

We take security vulnerabilities seriously. If you discover a security vulnerability, please follow these steps:

### 1. **Do NOT** open a public issue

Security vulnerabilities should be reported privately to protect users until a fix is available.

### 2. Report via GitHub Security Advisories

Please report security vulnerabilities using GitHub's Security Advisory feature:

1. Go to the repository's **Security** tab
2. Click **Report a vulnerability**
3. Fill out the security advisory form with details

Alternatively, you can open a **private security advisory** by:
- Creating a draft security advisory in the repository
- Or opening a private issue (if you have maintainer access)

Include the following information:
- Description of the vulnerability
- Steps to reproduce
- Potential impact
- Suggested fix (if you have one)
- Your contact information

### 3. Response Timeline

- **Initial Response**: Within 48 hours
- **Status Update**: Within 7 days
- **Fix Timeline**: Depends on severity, typically 30-90 days

### 4. Disclosure Policy

- We will acknowledge receipt of your report
- We will keep you informed of our progress
- We will credit you in security advisories (unless you prefer to remain anonymous)
- We will coordinate public disclosure after a fix is available

## Security Best Practices

### For Users

- Always use the latest stable version
- Review and understand the security implications of zero-knowledge proofs
- Use `RISC0_DEV_MODE=1` only for development/testing, never in production
- Verify proofs before trusting compliance claims
- Keep your RISC Zero toolchain updated

### For Developers

- Follow secure coding practices
- Review all dependencies for known vulnerabilities (`cargo audit`)
- Run security linters (`cargo clippy`)
- Never commit secrets or private keys
- Use constant-time operations for cryptographic code

## Known Security Considerations

### Zero-Knowledge Proofs

- **Dev Mode**: `RISC0_DEV_MODE=1` generates non-cryptographic proofs for testing only
- **Real Proofs**: Production use requires real zkVM proofs (10-20+ minutes generation time)
- **Verification**: Always verify proofs cryptographically before trusting results

### C2PA Integration

- C2PA signature verification is performed in the zkVM
- Tampered manifests will fail verification
- Invalid signatures are detected and reported

### Guest Program

- The guest program runs in an isolated zkVM environment
- Guest code is deterministic and verifiable
- No network access or side effects from guest execution

## Security Updates

Security advisories will be published:
- In GitHub Security Advisories (automatically visible in the repository's Security tab)
- In release notes
- Via GitHub notifications to repository watchers

## Thank You

We appreciate the security research community's efforts to keep Project FUSE secure. Responsible disclosure helps protect all users.
