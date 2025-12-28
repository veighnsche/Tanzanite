#!/usr/bin/env bash
# TEAM_006: Install Bun runtime
set -euo pipefail

echo "=== Installing Bun ==="

echo "Downloading Bun installer..."
curl -fSL --connect-timeout 30 --max-time 300 \
    "https://bun.sh/install" \
    -o /tmp/bun-install.sh
chmod +x /tmp/bun-install.sh
BUN_INSTALL=/usr/local/bun /tmp/bun-install.sh
rm /tmp/bun-install.sh
echo "Bun installed: $(/usr/local/bun/bin/bun --version)"

# Pre-cache Bun
echo "Setting up Bun cache..."
export BUN_INSTALL_CACHE_DIR=/usr/share/bun-cache
mkdir -p "$BUN_INSTALL_CACHE_DIR"
export PATH="/usr/local/bun/bin:$PATH"

chmod -R a+rX "$BUN_INSTALL_CACHE_DIR" /usr/local/bun
echo "Bun cache: $BUN_INSTALL_CACHE_DIR"

echo "=== Bun Complete ==="
