#!/bin/bash
# TEAM_002: Environment configuration module
[[ -n "$TANZANITE_BUILD" ]] || { echo "Must be sourced from build.sh"; exit 1; }

section "Part 6: Environment Configuration"

subsection "Setting up PATH for all users"
cat > /etc/profile.d/tanzanite-dev.sh << 'EOF'
# TEAM_003: Python/uv
export UV_CACHE_DIR=/usr/share/uv-cache
export UV_TOOL_DIR=/usr/share/uv-tools
export UV_TOOL_BIN_DIR=/usr/local/bin

# Go
export GOPATH=/usr/share/go
export GOMODCACHE=/usr/share/go/pkg/mod
export GOCACHE=/usr/share/go/cache
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:/usr/share/go/bin

# Rust
export RUSTUP_HOME=/usr/local/rustup
export CARGO_HOME=/usr/local/cargo
export PATH=$PATH:/usr/local/cargo/bin

# Node.js/npm/pnpm
export NPM_CONFIG_CACHE=/usr/share/npm-cache
export PNPM_HOME=/usr/share/pnpm
export PATH=$PATH:$PNPM_HOME

# Bun
export BUN_INSTALL=/usr/local/bun
export BUN_INSTALL_CACHE_DIR=/usr/share/bun-cache
export PATH=$PATH:/usr/local/bun/bin

# Android SDK
export ANDROID_SDK_ROOT=/usr/local/android-sdk
export ANDROID_HOME=$ANDROID_SDK_ROOT
export PATH=$PATH:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin
export PATH=$PATH:$ANDROID_SDK_ROOT/platform-tools
export PATH=$PATH:$ANDROID_SDK_ROOT/build-tools/35.0.0
export PATH=$PATH:$ANDROID_SDK_ROOT/ndk/27.2.12479018

# Gradle
export GRADLE_USER_HOME=/usr/share/gradle

# Flutter/Dart
export FLUTTER_ROOT=/usr/share/flutter
export PUB_CACHE=/usr/share/pub-cache
export PATH=$PATH:/usr/share/pub-cache/bin
EOF
chmod +x /etc/profile.d/tanzanite-dev.sh
echo "Environment variables configured in /etc/profile.d/tanzanite-dev.sh"

subsection "Verifying environment configuration"
verify_path /etc/profile.d/tanzanite-dev.sh "tanzanite-dev.sh profile" || exit 1
