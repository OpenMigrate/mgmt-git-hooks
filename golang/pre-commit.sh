#!/usr/bin/env bash
#
# Authors: OpenMigrate Team
# Created on: 08/12/2025
set -euo pipefail

if ! command -v go >/dev/null 2>&1; then
  echo "Go toolchain not found."; exit 1
fi

go fmt ./...
git add -A

go mod tidy
git add -A

go build ./...
