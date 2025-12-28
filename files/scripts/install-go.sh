#!/usr/bin/env bash
# TEAM_006: Install Go toolchain and pre-cache tools
set -euo pipefail

echo "=== Installing Go ==="

GO_VERSION="1.23.5"

echo "Downloading Go ${GO_VERSION}..."
curl -fSL --connect-timeout 30 --max-time 300 \
    "https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz" \
    -o /tmp/go.tar.gz
rm -rf /usr/local/go
tar -C /usr/local -xzf /tmp/go.tar.gz
rm /tmp/go.tar.gz
echo "Go installed: $(/usr/local/go/bin/go version)"

# Pre-cache Go modules and tools
echo "Pre-caching Go tools..."
export GOPATH=/usr/share/go
export GOMODCACHE=/usr/share/go/pkg/mod
export GOCACHE=/usr/share/go/cache
mkdir -p "$GOPATH" "$GOMODCACHE" "$GOCACHE"
export PATH="/usr/local/go/bin:$GOPATH/bin:$PATH"

/usr/local/go/bin/go install golang.org/x/tools/gopls@latest
/usr/local/go/bin/go install github.com/go-delve/delve/cmd/dlv@latest
/usr/local/go/bin/go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
/usr/local/go/bin/go install github.com/air-verse/air@latest

chmod -R a+rX "$GOPATH"
echo "Go cache: $GOMODCACHE"

echo "=== Go Complete ==="
