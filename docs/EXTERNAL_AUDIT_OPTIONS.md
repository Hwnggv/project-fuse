# External Audit Options

This document tracks opportunities for external security audits and community help for Project FUSE.

**Last Updated**: 2025-12-30  
**Status**: Research phase

## Grant Opportunities

### Polkadot Assurance Legion (PAL)

- **Status**: Active in 2025 (Q3 reports show ongoing funding)
- **Coverage**: Up to 80% audit coverage for OSS projects
- **Application**: Apply via [dotpal.io](https://dotpal.io)
- **Timeline**: TBD (application pending)
- **Notes**: Strong fit for ZK/crypto OSS projects

### ZK-Focused Grants

#### Optimism Season 8 Audits
- **Status**: Opens October 2025
- **Focus**: ZK and L2 security
- **Application**: TBD
- **Notes**: May be competitive, but FUSE aligns with ZK focus

#### BuidlGuidl
- **Status**: Ongoing
- **Focus**: Rust/ZK projects
- **Application**: TBD
- **Notes**: Good fit for Rust-based ZK projects

#### Ethereum Foundation ZK Rounds
- **Status**: Ongoing
- **Focus**: Zero-knowledge proof systems
- **Application**: TBD
- **Notes**: FUSE uses ZK proofs, may qualify

### Discounted Audits

#### Nethermind
- **Status**: Available
- **Offer**: Discounted audits for open projects
- **Contact**: TBD
- **Notes**: Well-known ZK audit firm

#### Veridise
- **Status**: Available
- **Offer**: Discounted audits for open projects
- **Contact**: TBD
- **Notes**: Specializes in formal verification and ZK

## Free Security Tools

### OSS-Fuzz

- **Status**: Eligible
- **Eligibility**: 
  - Google supports Rust since 2019
  - Open-source crypto projects qualify
  - Apply if 1M+ users or critical infrastructure
- **Application**: [OSS-Fuzz application](https://google.github.io/oss-fuzz/getting-started/new-project-guide/)
- **Timeline**: TBD (application pending)
- **Priority**: High (free, automated fuzzing)

### Cyberscan

- **Status**: Available
- **Focus**: Basic crypto scans
- **Priority**: Low (niche tool, lower priority than PAL/OSS-Fuzz)
- **Notes**: May provide basic checks, but less comprehensive

## Community Outreach

### Outreach Template

**Short Version** (for Reddit/Twitter):
```
OSS ZK+C2PA verifier: Seeking fuzz/audit volunteers (bounty avail). 
Repo: https://github.com/Mikebrown0409/project-fuse
```

**Detailed Version** (for forums/Discord):
```
Project FUSE is an open-source zero-knowledge proof system for verifiable 
compliance envelopes. We're seeking volunteer security researchers or auditors 
to review our codebase, particularly:

- Ed25519 signature verification in zkVM
- C2PA manifest parsing and selective disclosure
- RISC Zero zkVM integration
- Proof generation and verification

We offer bounties ($100-500 in ETH) for significant findings.
Repository: https://github.com/Mikebrown0409/project-fuse
```

### Target Communities

1. **r/cryptography** (Reddit)
   - Post: Security review request
   - Focus: ZK proof security

2. **r/rust** (Reddit)
   - Post: Rust security review
   - Focus: Memory safety, crypto implementations

3. **C2PA Discord/GitHub Discussions**
   - Post: C2PA + ZK integration
   - Focus: C2PA parsing security

4. **ZK Community Forums**
   - ZK Research Discord
   - ZK Hack forums
   - RISC Zero community

5. **Security Research Communities**
   - HackerOne (if applicable)
   - Bug bounty platforms

## Application Status

| Opportunity | Status | Priority | Next Steps |
|------------|--------|----------|------------|
| PAL (Polkadot Assurance Legion) | Research | High | Apply via dotpal.io |
| OSS-Fuzz | Research | High | Submit application |
| Optimism Season 8 | Research | Medium | Monitor for Oct 2025 opening |
| BuidlGuidl | Research | Medium | Contact for Rust/ZK programs |
| Ethereum Foundation ZK | Research | Medium | Check application process |
| Nethermind | Research | Low | Contact for discounted audit |
| Veridise | Research | Low | Contact for discounted audit |
| Community Outreach | Pending | High | Post to Reddit/forums |

## Action Items

- [ ] Apply to PAL (dotpal.io) - 1-2 hours
- [ ] Apply to OSS-Fuzz - 1-2 hours
- [ ] Post community outreach messages - 1 hour
- [ ] Monitor Optimism Season 8 - Opens Oct 2025
- [ ] Contact BuidlGuidl for Rust/ZK programs
- [ ] Research Ethereum Foundation ZK application process

## Timeline

- **Week 1**: Apply to PAL and OSS-Fuzz
- **Week 1**: Post community outreach
- **Ongoing**: Monitor grant opportunities
- **Q4 2025**: Optimism Season 8 opens

## Success Criteria

- ✅ At least one external audit lead identified
- ✅ Community outreach posted
- ✅ Free tool applications submitted
- ✅ If no leads, proceed with internal review + disclaimer

## Notes

- If external audit not available, proceed with internal review + "Pre-audit dev version" disclaimer
- Pilots can proceed with appropriate disclaimers
- Revenue from pilots can fund deeper audits
- Focus on zero-cost options first (PAL, OSS-Fuzz, community)
