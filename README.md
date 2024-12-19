# Infrastructure Pipeline Documentation

This repository contains a comprehensive CI/CD pipeline for infrastructure code validation, security scanning, and cost estimation. The pipeline is designed to ensure code quality, security compliance, and cost awareness for infrastructure-as-code projects.

## 📋 Table of Contents

- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Pipeline Components](#pipeline-components)
- [Local Development](#local-development)
- [GitHub Actions Workflow](#github-actions-workflow)
- [Security Scanning](#security-scanning)
- [Cost Analysis](#cost-analysis)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)

## Prerequisites

### Required Tools

- Docker 20.10.0 or higher
- Git 2.28.0 or higher
- Make
- GitHub account with repository access

## Quick Start

1. Clone the repository:

   ```bash
   git clone git@github.com:cloudon-one/pre-commits-pipelines.git
   cd pre-commits-pipelines

2. Run all checks locally:

   ```bash
   make all
   ```

## Pipeline Components

### Pre-commit Checks

- Terraform formatting
- Terraform documentation
- YAML/JSON formatting
- File size limits
- EOF fixes
- Secret detection

### Security Scanning

1. **Gitleaks**
   - Scans for secrets in code
   - Custom rules for Terraform
   - Historical commit scanning

2. **TFSec**
   - Infrastructure security best practices
   - Custom rule support
   - SARIF report generation

3. **Detect-secrets**
   - Additional secret scanning
   - Custom pattern support

## Local Development

### Make Commands

```bash
# Show available commands
make help

# Build Docker image
make build

# Run pre-commit checks
make local-check

# Run security scan
make security-scan

# Run Terraform validation
make test

# Clean up resources
make clean

# Run all checks
make all
```

### Pre-commit Configuration

The `.pre-commit-config.yaml` file includes:

```yaml
repos:
  - repo: https://github.com/pre-commit/pre-commit-hooks
  - repo: https://github.com/antonbabenko/pre-commit-terraform
  - repo: https://github.com/zricethezav/gitleaks
  - repo: https://github.com/asottile/add-trailing-comma
  - repo: https://github.com/hhatto/autopep8
```

## GitHub Actions Workflow

### Workflow Triggers

- Pull requests targeting main/master
- Push to main/master
- File paths:
  - `.tf`
  - `.tfvars`
  - `.hcl`
  - Workflow files
  - Pre-commit config

### PR Checks

1. **Compliance**
   - Semantic PR titles
   - Size limits
   - Required files

2. **Security**
   - Secret scanning
   - Infrastructure security
   - Compliance checks

3. **Infrastructure**
   - Terraform validation
   - Provider verification
   - Documentation checks

4. **Cost**
   - Change estimation
   - Baseline comparison
   - Monthly projections

## Security Scanning

### Gitleaks Configuration

Custom rules in `.gitleaks.toml`:

```toml
[[rules]]
id = "terraform-state"
description = "Terraform state files may contain secrets"
regex = '''(?i)[\w-]*\.tfstate[\w-]*'''
tags = ["terraform", "config"]

[[rules]]
id = "aws-access-key"
description = "AWS Access Key"
regex = '''(A3T[A-Z0-9]|AKIA|AGPA|AIDA|AROA|AIPA|ANPA|ANVA|ASIA)[A-Z0-9]{16}'''
tags = ["aws", "credentials"]

[[rules]]
id = "aws-secret-key"
description = "AWS Secret Key"
regex = '''(?i)aws_secret_access_key\s*=\s*[\'\"]*[A-Za-z0-9/+=]{40}[\'\"]*'''
tags = ["aws", "credentials"]

[[rules]]
id = "bitbucket-client-id"
description = "Bitbucket Client ID"
regex = '''bitbucket(?:_client|_secret)?(?:_key|_id)?[\'\"=\s]*(?:([A-Za-z0-9]{32})|([0-9a-zA-Z]{32}))'''
tags = ["bitbucket", "credentials"]

[[rules]]
id = "private-key"
description = "Private Key"
regex = '''(?i)-----BEGIN[ A-Z]*PRIVATE KEY'''
tags = ["key", "private"]

[[rules]]
id = "password-in-url"
description = "Password in URL"
regex = '''[a-zA-Z]{3,10}://[^/\s:@]*?:[^/\s:@]*?@[^/\s:@]*'''
tags = ["password", "url"]

[[rules]]
id = "ip-addr"
description = "IP Address"
regex = '''(?:^|[^0-9])(?:(?:25[0-5]|2[0-4][0-9]|[0-1]?[0-9]{1,2})[.](?:25[0-5]|2[0-4][0-9]|[0-1]?[0-9]{1,2})[.](?:25[0-5]|2[0-4][0-9]|[0-1]?[0-9]{1,2})[.](?:25[0-5]|2[0-4][0-9]|[0-1]?[0-9]{1,2}))(?:[^0-9]|$)'''
tags = ["networking", "ip"]
[rules.ip-addr.allowlist]
regexes = [
    '''(127\.0\.0\.1)''',
    '''(10\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3})''',
    '''(172\.(1[6-9]|2[0-9]|3[0-1])\.[0-9]{1,3}\.[0-9]{1,3})''',
    '''(192\.168\.[0-9]{1,3}\.[0-9]{1,3})'''
]

[[rules]]
id = "high-entropy"
description = "High entropy string"
regex = '''[0-9a-zA-Z-_!@#$%^&*()]{16,}'''
entropy = 4.5
tags = ["entropy", "secret"]
[rules.high-entropy.allowlist]
regexes = [
    '''[A-Za-z0-9+/]{64}''',    # Base64 encoded strings
    '''[0-9a-f]{32}''',         # MD5 hashes
    '''[0-9a-f]{40}''',         # SHA1 hashes
    '''[0-9a-f]{64}'''          # SHA256 hashes
]

[[rules]]
id = "confluence-token"
description = "Confluence API tokens"
regex = '''(?i)(confluence[a-z0-9_ .\-,]{0,25})(=|>|:=|\|\|:|<=|=>|:).{0,5}['\"]([a-z0-9=_\-]{32,45})['\"]'''
tags = ["confluence", "api", "token"]
```

### TFSec Integration

Security checks include:
- Access management
- Network security
- Encryption
- Logging & monitoring

### PR Comments

Cost analysis appears in PR comments showing:

- Monthly cost changes
- Resource breakdown
- Usage estimates
- Historical comparison

## Troubleshooting

### Common Issues

1. **Docker Build Fails**

   ```bash
   # Clean Docker cache
   docker system prune -a
   make build
   ```

2. **Pre-commit Hooks Fail**

   ```bash
   # Update hooks
   pre-commit clean
   pre-commit autoupdate
   ```

3. **Terraform Validation Issues**

   ```bash
   # Clean Terraform cache
   make clean
   make test
   ```

### Debug Mode

Enable verbose output:

```bash
# For security scan
make security-scan ARGS="--verbose"

# For Terraform
TF_LOG=DEBUG make test
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run all checks:

   ```bash
   make all
   ```

5. Submit a pull request

### PR Guidelines

- Follow semantic commit messages
- Include test cases
- Update documentation
- Keep changes focused

### Code Style

- Follow HashiCorp's Terraform style guide
- Use consistent naming conventions
- Include comments for complex logic
- Update README for new features
