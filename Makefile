# Default target
.DEFAULT_GOAL := help

# Variables
DOCKER_IMAGE = infra-checks:latest
MOUNT_PATH = $(shell pwd)
DOCKER_RUN = docker run --rm -v $(MOUNT_PATH):/workspace

# Mark all targets as phony
.PHONY: help build test local-check security-scan cost-estimate clean all

# Help target
help:
	@echo "Available targets:"
	@echo "  build          - Build Docker image for infrastructure checks"
	@echo "  local-check    - Run pre-commit checks locally"
	@echo "  security-scan  - Run security checks (Gitleaks)"
	@echo "  test          - Run Terraform validation tests"
	@echo "  cost-estimate  - Generate cost estimation (requires INFRACOST_API_KEY)"
	@echo "  clean         - Remove Docker image and temporary files"
	@echo "  all           - Run all checks (build, security, test, local-check)"

# Build the Docker image
build:
	docker build -t $(DOCKER_IMAGE) .

# Run local pre-commit checks
local-check: build
	$(DOCKER_RUN) $(DOCKER_IMAGE)

# Run security scan with Gitleaks
security-scan: build
	$(DOCKER_RUN) $(DOCKER_IMAGE) gitleaks detect --source=/workspace --verbose

# Run all Terraform validation tests
test: build
	@for dir in $$(find . -type f -name "*.tf" -exec dirname {} \; | sort -u); do \
		echo "Testing Terraform in $$dir"; \
		$(DOCKER_RUN) -w /workspace/$$dir $(DOCKER_IMAGE) terraform init -backend=false; \
		$(DOCKER_RUN) -w /workspace/$$dir $(DOCKER_IMAGE) terraform validate; \
	done

# Generate cost estimation
cost-estimate: build
	@if [ -z "$$INFRACOST_API_KEY" ]; then \
		echo "Error: INFRACOST_API_KEY environment variable is not set"; \
		exit 1; \
	fi
	$(DOCKER_RUN) -e INFRACOST_API_KEY=$(INFRACOST_API_KEY) $(DOCKER_IMAGE) \
		infracost breakdown --path . --format table

# Clean up
clean:
	docker rmi $(DOCKER_IMAGE) 2>/dev/null || true
	find . -type f -name ".terraform.lock.hcl" -delete
	find . -type d -name ".terraform" -exec rm -rf {} + 2>/dev/null || true

# Run all checks
all: build security-scan test local-check
	@echo "All checks completed successfully!"