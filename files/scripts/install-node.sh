#!/usr/bin/env bash
# TEAM_006: Install Node.js and pre-cache packages
set -euo pipefail

echo "=== Installing Node.js ==="

NODE_VERSION="v24.12.0"

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
export NPM_CONFIG_CACHE=/var/cache/npm-cache
export PNPM_HOME=/var/cache/pnpm
export COREPACK_HOME=/var/cache/corepack
mkdir -p "$NPM_CONFIG_CACHE" "$PNPM_HOME" "$COREPACK_HOME"
export PATH="$PNPM_HOME:$PATH"

# Update npm and pnpm to latest
echo "Updating npm and pnpm..."
npm install -g --force npm@latest
corepack prepare pnpm@latest --activate

echo "Installing global Node.js tools..."
npm install -g --force typescript@latest ts-node@latest eslint@latest prettier@latest @biomejs/biome@latest turbo@latest nx@latest

# Verify pnpm works
pnpm --version

chmod -R a+rX "$NPM_CONFIG_CACHE" "$PNPM_HOME" "$COREPACK_HOME" /usr/local/lib/node_modules
echo "npm cache: $NPM_CONFIG_CACHE"
echo "pnpm home: $PNPM_HOME"

echo "=== Node.js Complete ==="
