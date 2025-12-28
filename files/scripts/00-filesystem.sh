#!/usr/bin/env bash
# TEAM_006: Filesystem setup for BlueBuild
# CRITICAL: This script MUST run FIRST before any package installation
set -euo pipefail

echo "=== Filesystem Setup ==="

# Fix /root - some base images have it as symlink or file
echo "Fixing /root directory..."
if [[ -L /root ]]; then
    echo "  Removing /root symlink..."
    rm -f /root
elif [[ -f /root ]]; then
    echo "  Removing /root file..."
    rm -f /root
elif [[ -d /root ]]; then
    echo "  /root is already a directory"
fi

# Create full directory structure for all tools
mkdir -p /root/.cache/node/corepack \
         /root/.local/share/uv \
         /root/.local/bin \
         /root/.cargo \
         /root/.rustup \
         /root/.config
chmod 700 /root
export HOME=/root
echo "  /root directory structure created"

# Fix /opt symlink
echo "Fixing /opt directory..."
if [[ -L /opt ]]; then
    echo "  Converting /opt from symlink to directory..."
    rm /opt && mkdir /opt
else
    echo "  /opt is already a directory"
fi

# Fix /usr/local symlink
echo "Fixing /usr/local directory..."
if [[ -L /usr/local ]]; then
    echo "  Converting /usr/local from symlink to directory..."
    rm -rf /usr/local
else
    echo "  /usr/local is already a directory"
fi
mkdir -p /usr/local/bin /usr/local/go /usr/local/rustup /usr/local/cargo /usr/local/bun
echo "  Created /usr/local subdirectories"

# Verify setup
echo "Verifying filesystem setup..."
for path in /root /root/.cache /opt /usr/local /usr/local/bin; do
    if [[ -d "$path" ]]; then
        echo "  ✓ $path"
    else
        echo "  ✗ FAILED: $path"
        exit 1
    fi
done

echo "=== Filesystem Setup Complete ==="
