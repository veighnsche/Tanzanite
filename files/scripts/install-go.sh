#!/usr/bin/env bash
# TEAM_006: Install Go toolchain and pre-cache tools
#
# TEAM_011 WARNING: ALWAYS VERIFY ASSUMPTIONS BEFORE CHANGING THIS FILE!
# TEAM_011 WARNING: ALWAYS VERIFY ASSUMPTIONS BEFORE CHANGING THIS FILE!
# TEAM_011 WARNING: ALWAYS VERIFY ASSUMPTIONS BEFORE CHANGING THIS FILE!
# TEAM_011 WARNING: ALWAYS VERIFY ASSUMPTIONS BEFORE CHANGING THIS FILE!
# TEAM_011 WARNING: ALWAYS VERIFY ASSUMPTIONS BEFORE CHANGING THIS FILE!
# - Check go.dev/dl API for current versions
# - Read previous team files before modifying
# - Test changes don't break existing functionality
# - DO NOT assume based on training data - VERIFY with live sources
# TEAM_011 WARNING: ALWAYS VERIFY ASSUMPTIONS BEFORE CHANGING THIS FILE!
# TEAM_011 WARNING: ALWAYS VERIFY ASSUMPTIONS BEFORE CHANGING THIS FILE!
# TEAM_011 WARNING: ALWAYS VERIFY ASSUMPTIONS BEFORE CHANGING THIS FILE!
# TEAM_011 WARNING: ALWAYS VERIFY ASSUMPTIONS BEFORE CHANGING THIS FILE!
# TEAM_011 WARNING: ALWAYS VERIFY ASSUMPTIONS BEFORE CHANGING THIS FILE!
#
set -euo pipefail

echo "=== Installing Go ==="

GO_VERSION="1.25.5"

echo "Downloading Go ${GO_VERSION}..."
curl -fSL --connect-timeout 30 --max-time 300 \
    "https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz" \
    -o /tmp/go.tar.gz
rm -rf /usr/local/go
tar -C /usr/local -xz --no-same-owner -f /tmp/go.tar.gz
rm /tmp/go.tar.gz
echo "Go installed: $(/usr/local/go/bin/go version)"

# Pre-cache Go modules and tools
echo "Pre-caching Go tools..."
export GOPATH=/var/cache/go
export GOMODCACHE=/var/cache/go/pkg/mod
export GOCACHE=/var/cache/go/cache
mkdir -p "$GOPATH" "$GOMODCACHE" "$GOCACHE"
export PATH="/usr/local/go/bin:$GOPATH/bin:$PATH"

echo "Installing Go tools at @latest..."
/usr/local/go/bin/go install golang.org/x/tools/gopls@latest
/usr/local/go/bin/go install github.com/go-delve/delve/cmd/dlv@latest
/usr/local/go/bin/go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
/usr/local/go/bin/go install github.com/air-verse/air@latest

chmod -R a+rX "$GOPATH"
echo "Go cache: $GOMODCACHE"

echo "=== Go Complete ==="
