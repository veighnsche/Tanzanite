#!/bin/bash
# TEAM_002: Programming languages module
[[ -n "$TANZANITE_BUILD" ]] || { echo "Must be sourced from build.sh"; exit 1; }

section "Part 3: Programming Languages"

# TEAM_003: Install C compiler early - needed for compiling language tooling (Rust crates, etc.)
subsection "Installing build essentials for language tooling"
dnf5 install -y gcc gcc-c++ make pkg-config openssl-devel

# HOME=/root is already set in 01-filesystem.sh with full directory structure

subsection "Installing Python + uv package manager"
dnf5 install -y python3 python3-pip python3-devel
mkdir -p /usr/local/bin
download_file "https://github.com/astral-sh/uv/releases/latest/download/uv-x86_64-unknown-linux-gnu.tar.gz" /tmp/uv.tar.gz
tar -xz -C /usr/local/bin --strip-components=1 -f /tmp/uv.tar.gz
chmod +x /usr/local/bin/uv /usr/local/bin/uvx
rm /tmp/uv.tar.gz
echo "uv installed: $(uv --version)"

# TEAM_003: Pre-cache common Python packages
subsection "Pre-caching Python/uv packages"
export UV_CACHE_DIR=/usr/share/uv-cache
export UV_TOOL_DIR=/usr/share/uv-tools
export UV_TOOL_BIN_DIR=/usr/local/bin
mkdir -p "$UV_CACHE_DIR" "$UV_TOOL_DIR"
# Pre-install common dev tools into system locations
uv tool install ruff
uv tool install black
uv tool install mypy
uv tool install pytest
uv tool install ipython
chmod -R a+rX "$UV_CACHE_DIR" "$UV_TOOL_DIR"
echo "Python/uv cache: $UV_CACHE_DIR"
echo "Python/uv tools: $UV_TOOL_DIR"

subsection "Installing Go toolchain"
GO_VERSION="1.23.5"
download_file "https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz" /tmp/go.tar.gz
rm -rf /usr/local/go
tar -C /usr/local -xzf /tmp/go.tar.gz
rm /tmp/go.tar.gz
echo "Go installed: $(/usr/local/go/bin/go version)"

# TEAM_003: Pre-cache Go modules and common tools
subsection "Pre-caching Go modules and tools"
export GOPATH=/usr/share/go
export GOMODCACHE=/usr/share/go/pkg/mod
export GOCACHE=/usr/share/go/cache
mkdir -p "$GOPATH" "$GOMODCACHE" "$GOCACHE"
export PATH="/usr/local/go/bin:$GOPATH/bin:$PATH"
# Install common Go tools
go install golang.org/x/tools/gopls@latest
go install github.com/go-delve/delve/cmd/dlv@latest
go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
go install github.com/air-verse/air@latest
chmod -R a+rX "$GOPATH"
echo "Go cache: $GOMODCACHE"

subsection "Installing Rust toolchain"
export RUSTUP_HOME=/usr/local/rustup
export CARGO_HOME=/usr/local/cargo
download_file "https://sh.rustup.rs" /tmp/rustup-init.sh
chmod +x /tmp/rustup-init.sh
/tmp/rustup-init.sh -y --no-modify-path
rm /tmp/rustup-init.sh
echo "Rust installed: $(/usr/local/cargo/bin/rustc --version)"

# TEAM_003: Pre-cache Rust components and common tools
subsection "Pre-caching Rust components and crates"
export PATH="/usr/local/cargo/bin:$PATH"
# Add common components
rustup component add rust-analyzer rustfmt clippy rust-src
# Install common cargo tools
cargo install cargo-watch cargo-edit cargo-expand sccache
chmod -R a+rX /usr/local/rustup /usr/local/cargo
echo "Rust cache: $CARGO_HOME"

subsection "Installing Node.js"
NODE_VERSION="v24.1.0"
download_file "https://nodejs.org/dist/${NODE_VERSION}/node-${NODE_VERSION}-linux-x64.tar.xz" /tmp/node.tar.xz
tar -xJ -C /usr/local --strip-components=1 -f /tmp/node.tar.xz
rm /tmp/node.tar.xz
corepack enable pnpm
echo "Node.js installed: $(node --version)"

# TEAM_003: Pre-cache Node.js/npm/pnpm packages
subsection "Pre-caching Node.js global packages"
export NPM_CONFIG_CACHE=/usr/share/npm-cache
export PNPM_HOME=/usr/share/pnpm
export COREPACK_HOME=/usr/share/corepack
mkdir -p "$NPM_CONFIG_CACHE" "$PNPM_HOME" "$COREPACK_HOME"
# /root/.cache/node/corepack already created in 01-filesystem.sh
export PATH="$PNPM_HOME:$PATH"
# Install common global packages
npm install -g typescript ts-node eslint prettier @biomejs/biome turbo nx
# pnpm is already enabled via corepack, just verify it works
pnpm --version
chmod -R a+rX "$NPM_CONFIG_CACHE" "$PNPM_HOME" "$COREPACK_HOME" /usr/local/lib/node_modules
echo "npm cache: $NPM_CONFIG_CACHE"
echo "pnpm home: $PNPM_HOME"

subsection "Installing Bun runtime"
download_file "https://bun.sh/install" /tmp/bun-install.sh
chmod +x /tmp/bun-install.sh
BUN_INSTALL=/usr/local/bun /tmp/bun-install.sh
rm /tmp/bun-install.sh
echo "Bun installed: $(/usr/local/bun/bin/bun --version)"

# TEAM_003: Pre-cache Bun global packages
subsection "Pre-caching Bun packages"
export BUN_INSTALL_CACHE_DIR=/usr/share/bun-cache
mkdir -p "$BUN_INSTALL_CACHE_DIR"
export PATH="/usr/local/bun/bin:$PATH"
# Bun shares many packages with npm, just ensure cache dir exists
chmod -R a+rX "$BUN_INSTALL_CACHE_DIR" /usr/local/bun
echo "Bun cache: $BUN_INSTALL_CACHE_DIR"

# TEAM_003: Flutter/Dart SDK installation
subsection "Installing Flutter SDK (includes Dart)"
FLUTTER_DIR="/usr/share/flutter"
dnf5 install -y git clang cmake ninja-build gtk3-devel  # Flutter dependencies
git clone --depth 1 --branch stable https://github.com/flutter/flutter.git "$FLUTTER_DIR"
git config --system --add safe.directory "$FLUTTER_DIR"
ln -sf "$FLUTTER_DIR/bin/flutter" /usr/bin/flutter
ln -sf "$FLUTTER_DIR/bin/dart" /usr/bin/dart

# Set pub cache location (HOME=/root already set at module start)
export PUB_CACHE=/usr/share/flutter/.pub-cache

# Precache ALL platform binaries during build (filesystem is read-only at runtime)
export PATH="$FLUTTER_DIR/bin:$PATH"
flutter precache --android --linux --web
flutter config --no-analytics
dart --disable-analytics

# Pre-cache pub packages for Flutter tool itself
subsection "Pre-caching Dart pub global packages"
export PUB_CACHE=/usr/share/pub-cache
mkdir -p "$PUB_CACHE"
dart pub global activate devtools
dart pub global activate dart_style
chmod -R a+rX "$PUB_CACHE"
echo "Pub cache: $PUB_CACHE"

echo "Flutter installed: $(flutter --version --machine | head -1)"

subsection "Verifying programming languages and caches"
verify_command python3 "Python" && \
verify_command uv "uv package manager" && \
verify_path /usr/share/uv-cache "uv cache" && \
verify_runs "Go version" /usr/local/go/bin/go version && \
verify_path /usr/share/go/pkg/mod "Go module cache" && \
verify_command gopls "gopls (Go LSP)" && \
verify_runs "Rust version" /usr/local/cargo/bin/rustc --version && \
verify_command rust-analyzer "rust-analyzer" && \
verify_command node "Node.js" && \
verify_path /usr/share/npm-cache "npm cache" && \
verify_path /usr/share/pnpm "pnpm home" && \
verify_runs "Bun version" /usr/local/bun/bin/bun --version && \
verify_path /usr/share/bun-cache "Bun cache" && \
verify_command flutter "Flutter SDK" && \
verify_command dart "Dart SDK" && \
verify_path /usr/share/pub-cache "Dart pub cache" || exit 1
