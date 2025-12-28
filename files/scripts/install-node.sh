#!/usr/bin/env bash
# TEAM_006: Install Node.js and pre-cache packages
set -euo pipefail

echo "=== Installing Node.js ==="

NODE_VERSION="v24.1.0"

echo "Downloading Node.js ${NODE_VERSION}..."
curl -fSL --connect-timeout 30 --max-time 300 \
    "https://nodejs.org/dist/${NODE_VERSION}/node-${NODE_VERSION}-linux-x64.tar.xz" \
    -o /tmp/node.tar.xz
tar -xJ -C /usr/local --strip-components=1 -f /tmp/node.tar.xz
rm /tmp/node.tar.xz

corepack enable pnpm
echo "Node.js installed: $(node --version)"

# Pre-cache Node.js packages
echo "Pre-caching Node.js packages..."
export NPM_CONFIG_CACHE=/usr/share/npm-cache
export PNPM_HOME=/usr/share/pnpm
export COREPACK_HOME=/usr/share/corepack
mkdir -p "$NPM_CONFIG_CACHE" "$PNPM_HOME" "$COREPACK_HOME"
export PATH="$PNPM_HOME:$PATH"

npm install -g typescript ts-node eslint prettier @biomejs/biome turbo nx

# Verify pnpm works
pnpm --version

chmod -R a+rX "$NPM_CONFIG_CACHE" "$PNPM_HOME" "$COREPACK_HOME" /usr/local/lib/node_modules
echo "npm cache: $NPM_CONFIG_CACHE"
echo "pnpm home: $PNPM_HOME"

echo "=== Node.js Complete ==="
