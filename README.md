# Infrastructure Pipeline Documentation

This repository contains a comprehensive CI/CD pipeline for infrastructure code validation, security scanning, and cost estimation. The pipeline is designed to ensure code quality, security compliance, and cost awareness for infrastructure-as-code projects.

## 📋 Table of Contents

- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Pipeline Components](#pipeline-components)
- [Local Development](#local-development)
- [GitHub Actions Workflow](#github-actions-workflow)
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

**TFSec**

   - Infrastructure security best practices
   - Custom rule support
   - SARIF report generation

**Detect-secrets**

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

```bass
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
