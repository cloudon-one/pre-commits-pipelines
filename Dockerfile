FROM hashicorp/terraform:1.7.0 as terraform
FROM infracost/infracost:ci-0.10 as infracost
FROM aquasec/tfsec:v1.28 as tfsec
FROM zricethezav/gitleaks:v8.18.4 as gitleaks
FROM python:3.10-slim

# Copy tools from their respective images
COPY --from=terraform /bin/terraform /usr/local/bin/
COPY --from=infracost /usr/local/bin/infracost /usr/local/bin/
COPY --from=tfsec /usr/bin/tfsec /usr/local/bin/
COPY --from=gitleaks /usr/bin/gitleaks /usr/local/bin/

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    make \
    gcc \
    jq \
    wget \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Install Python packages
RUN pip install --no-cache-dir \
    pre-commit \
    checkov \
    tflint \
    terraform-docs \
    detect-secrets

# Install additional tools
RUN curl -sSfL https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | sh

WORKDIR /workspace
CMD ["pre-commit", "run", "--all-files"]
