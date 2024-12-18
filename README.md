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
- Infracost API key (for cost estimation)

### Environment Setup

1. Register for an Infracost API key at [Infracost.io](https://www.infracost.io)
2. Add the following secrets to your GitHub repository:

   ```
   INFRACOST_API_KEY=your_api_key
   ```

## Quick Start

1. Clone the repository:

   ```bash
   git clone git@github.com:cloudon-one/pre-commits-pipelines.git
   cd pre-commits-pipelines

2. Install pre-commit hooks:

   ```bash
   pip install pre-commit
   pre-commit install
   ```

3. Run all checks locally:

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

### Cost Analysis

- Monthly cost estimation
- Cost change detection
- Resource-wise breakdown
- Usage-based estimates

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

# Generate cost estimate
make cost-estimate

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
  - repo: https://github.com/bridgecrewio/checkov
  - repo: https://github.com/zricethezav/gitleaks
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
# AWS credentials
[[rules]]
id = "terraform-aws-access-key"
description = "AWS Access Key"
regex = '''(?i)aws_access_key_id.*=.*'''

# Terraform state backend
[[rules]]
id = "terraform-state-backend"
description = "Terraform State Backend Configuration"
regex = '''(?i)(backend\s*".*")\s*{'''
```

### TFSec Integration

Security checks include:
- Access management
- Network security
- Encryption
- Logging & monitoring

## Cost Analysis

### Setup

1. Export your Infracost API key:

   ```bash
   export INFRACOST_API_KEY=your_api_key
   ```

2. Run cost estimation:

   ```bash
   make cost-estimate
   ```

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