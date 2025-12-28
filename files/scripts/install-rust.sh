#!/usr/bin/env bash
# TEAM_006: Install Rust toolchain and pre-cache components
set -euo pipefail

echo "=== Installing Rust ==="

export RUSTUP_HOME=/usr/local/rustup
export CARGO_HOME=/usr/local/cargo

echo "Downloading rustup..."
curl -fSL --connect-timeout 30 --max-time 300 \
    "https://sh.rustup.rs" \
    -o /tmp/rustup-init.sh
chmod +x /tmp/rustup-init.sh
/tmp/rustup-init.sh -y --no-modify-path
rm /tmp/rustup-init.sh
echo "Rust installed: $(/usr/local/cargo/bin/rustc --version)"

# Pre-cache Rust components and tools
echo "Pre-caching Rust components..."
export PATH="/usr/local/cargo/bin:$PATH"

# Ensure rustup itself is latest
rustup self update
rustup update stable

echo "Adding rust components..."
rustup component add rust-analyzer rustfmt clippy rust-src

echo "Installing cargo tools..."
# bacon and watchexec are the modern successors to cargo-watch (which is dormant)
cargo install bacon watchexec-cli cargo-watch cargo-edit cargo-expand sccache

chmod -R a+rX /usr/local/rustup /usr/local/cargo
echo "Rust cache: $CARGO_HOME"

echo "=== Rust Complete ==="
