#!/bin/bash
# TEAM_002: Programming languages module
[[ -n "$TANZANITE_BUILD" ]] || { echo "Must be sourced from build.sh"; exit 1; }

section "Part 3: Programming Languages"

subsection "Installing Python + uv package manager"
dnf5 install -y python3 python3-pip python3-devel
mkdir -p /usr/local/bin
download_file "https://github.com/astral-sh/uv/releases/latest/download/uv-x86_64-unknown-linux-gnu.tar.gz" /tmp/uv.tar.gz
tar -xz -C /usr/local/bin --strip-components=1 -f /tmp/uv.tar.gz
chmod +x /usr/local/bin/uv /usr/local/bin/uvx
rm /tmp/uv.tar.gz
echo "uv installed: $(uv --version)"

subsection "Installing Go toolchain"
GO_VERSION="1.23.5"
download_file "https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz" /tmp/go.tar.gz
rm -rf /usr/local/go
tar -C /usr/local -xzf /tmp/go.tar.gz
rm /tmp/go.tar.gz
echo "Go installed: $(/usr/local/go/bin/go version)"

subsection "Installing Rust toolchain"
export RUSTUP_HOME=/usr/local/rustup
export CARGO_HOME=/usr/local/cargo
download_file "https://sh.rustup.rs" /tmp/rustup-init.sh
chmod +x /tmp/rustup-init.sh
/tmp/rustup-init.sh -y --no-modify-path
rm /tmp/rustup-init.sh
chmod -R a+rX /usr/local/rustup /usr/local/cargo
echo "Rust installed: $(/usr/local/cargo/bin/rustc --version)"

subsection "Installing Node.js"
NODE_VERSION="v24.1.0"
download_file "https://nodejs.org/dist/${NODE_VERSION}/node-${NODE_VERSION}-linux-x64.tar.xz" /tmp/node.tar.xz
tar -xJ -C /usr/local --strip-components=1 -f /tmp/node.tar.xz
rm /tmp/node.tar.xz
corepack enable pnpm
echo "Node.js installed: $(node --version)"

subsection "Installing Bun runtime"
download_file "https://bun.sh/install" /tmp/bun-install.sh
chmod +x /tmp/bun-install.sh
BUN_INSTALL=/usr/local/bun /tmp/bun-install.sh
rm /tmp/bun-install.sh
echo "Bun installed: $(/usr/local/bun/bin/bun --version)"
