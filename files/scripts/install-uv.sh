#!/usr/bin/env bash
# TEAM_006: Install Python uv package manager and pre-cache tools
set -euo pipefail

echo "=== Installing Python + uv ==="

# uv binary
echo "Downloading uv..."
curl -fSL --connect-timeout 30 --max-time 300 \
    "https://github.com/astral-sh/uv/releases/latest/download/uv-x86_64-unknown-linux-gnu.tar.gz" \
    -o /tmp/uv.tar.gz
tar -xz -C /usr/local/bin --strip-components=1 --no-same-owner -f /tmp/uv.tar.gz
chmod +x /usr/local/bin/uv /usr/local/bin/uvx
rm /tmp/uv.tar.gz
echo "uv installed: $(uv --version)"

# Pre-cache common Python tools
echo "Pre-caching Python tools..."
export UV_CACHE_DIR=/var/cache/uv-cache
export UV_TOOL_DIR=/var/cache/uv-tools
export UV_TOOL_BIN_DIR=/usr/local/bin
mkdir -p "$UV_CACHE_DIR" "$UV_TOOL_DIR"

# Ensure pip is latest
python3 -m pip install --upgrade --root-user-action=ignore pip setuptools wheel

# Use uv to install latest versions of tools
uv tool install ruff@latest
uv tool install black@latest
uv tool install mypy@latest
uv tool install pytest@latest
uv tool install ipython@latest

chmod -R a+rX "$UV_CACHE_DIR" "$UV_TOOL_DIR"
echo "Python/uv cache: $UV_CACHE_DIR"
echo "Python/uv tools: $UV_TOOL_DIR"

echo "=== Python + uv Complete ==="
