# TEAM_006: Tanzanite development environment variables
# This file is sourced by /etc/profile for all users

# Python/uv
export UV_CACHE_DIR=/var/cache/uv-cache
export UV_TOOL_DIR=/var/cache/uv-tools
export UV_TOOL_BIN_DIR=/usr/local/bin

# Go
export GOPATH=/var/cache/go
export GOMODCACHE=/var/cache/go/pkg/mod
export GOCACHE=/var/cache/go/cache
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:/var/cache/go/bin

# Rust
export RUSTUP_HOME=/usr/local/rustup
export CARGO_HOME=/usr/local/cargo
export PATH=$PATH:/usr/local/cargo/bin

# Node.js/npm/pnpm
export NPM_CONFIG_CACHE=/var/cache/npm-cache
export PNPM_HOME=/var/cache/pnpm
export COREPACK_HOME=/var/cache/corepack
export PATH=$PATH:$PNPM_HOME

# Bun
export BUN_INSTALL=/usr/local/bun
export BUN_INSTALL_CACHE_DIR=/var/cache/bun-cache
export PATH=$PATH:/usr/local/bun/bin

# Android SDK
export ANDROID_SDK_ROOT=/usr/local/android-sdk
export ANDROID_HOME=$ANDROID_SDK_ROOT
export PATH=$PATH:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin
export PATH=$PATH:$ANDROID_SDK_ROOT/platform-tools
export PATH=$PATH:$ANDROID_SDK_ROOT/build-tools/35.0.0
export PATH=$PATH:$ANDROID_SDK_ROOT/ndk/27.2.12479018

# Gradle
export GRADLE_USER_HOME=/var/cache/gradle

# Flutter/Dart
export FLUTTER_ROOT=/usr/share/flutter
export PUB_CACHE=/var/cache/pub-cache
export PATH=$PATH:/var/cache/pub-cache/bin
