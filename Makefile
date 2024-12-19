.DEFAULT_GOAL := help

# Variables
DOCKER_IMAGE = infra-checks:latest
MOUNT_PATH = $(shell pwd)
DOCKER_RUN = docker run --rm -v $(MOUNT_PATH):/workspace

.PHONY: help build test local-check security-scan clean all

help:
	@echo "Available targets:"
	@echo "  build          - Build Docker image for infrastructure checks"
	@echo "  local-check    - Run pre-commit checks locally"
	@echo "  security-scan  - Run security checks (Gitleaks)"
	@echo "  test          - Run Terraform validation tests"
	@echo "  clean         - Remove Docker image and temporary files"
	@echo "  all           - Run all checks (build, security, test, local-check)"

build:
	docker build -t $(DOCKER_IMAGE) .

local-check: build
	$(DOCKER_RUN) $(DOCKER_IMAGE)

security-scan: build
	$(DOCKER_RUN) $(DOCKER_IMAGE) gitleaks detect --source=/workspace --verbose

test: build
	@for dir in $$(find . -type f -name "*.tf" -exec dirname {} \; | sort -u); do \
		echo "Testing Terraform in $$dir"; \
		$(DOCKER_RUN) -w /workspace/$$dir $(DOCKER_IMAGE) terraform init -backend=false; \
		$(DOCKER_RUN) -w /workspace/$$dir $(DOCKER_IMAGE) terraform validate; \
	done

clean:
	docker rmi $(DOCKER_IMAGE) 2>/dev/null || true
	find . -type f -name ".terraform.lock.hcl" -delete
	find . -type d -name ".terraform" -exec rm -rf {} + 2>/dev/null || true

all: build security-scan test local-check
	@echo "All checks completed successfully!"
