#!/usr/bin/env bash
#
# Authors: aslamcodes
# Created on: 08/12/2025
# Last updated on: 08/12/2025

set -euo pipefail

echo "Running Terraform pre-commit checks..."

# Check if terraform is installed
if ! command -v terraform &> /dev/null; then
    echo "Error: terraform command not found. Please install Terraform."
    exit 1
fi

# Get list of staged .tf files
STAGED_TF_FILES=$(git diff --cached --name-only --diff-filter=ACM | grep '\.tf$' || true)

if [ -z "$STAGED_TF_FILES" ]; then
    echo "No Terraform files staged for commit."
    exit 0
fi

echo "Checking Terraform files: $STAGED_TF_FILES"

# Format check
echo "Checking Terraform formatting..."
if ! terraform fmt -check -diff -recursive .; then
    echo "Terraform files are not properly formatted."
    echo "Run 'terraform fmt -recursive .' to fix formatting issues."
    exit 1
fi

# Validate syntax
echo "Validating Terraform syntax..."
if ! terraform validate; then
    echo "Terraform validation failed."
    exit 1
fi

echo "All Terraform checks passed!"
exit 0
