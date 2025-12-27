#!/bin/bash
# TEAM_002: Environment configuration module
[[ -n "$TANZANITE_BUILD" ]] || { echo "Must be sourced from build.sh"; exit 1; }

section "Part 6: Environment Configuration"

subsection "Setting up PATH for all users"
cat > /etc/profile.d/tanzanite-dev.sh << 'EOF'
# Go
export PATH=$PATH:/usr/local/go/bin

# Rust
export RUSTUP_HOME=/usr/local/rustup
export CARGO_HOME=/usr/local/cargo
export PATH=$PATH:/usr/local/cargo/bin

# Bun
export BUN_INSTALL=/usr/local/bun
export PATH=$PATH:/usr/local/bun/bin

# Android SDK
export ANDROID_SDK_ROOT=/usr/local/android-sdk
export ANDROID_HOME=$ANDROID_SDK_ROOT
export PATH=$PATH:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin
export PATH=$PATH:$ANDROID_SDK_ROOT/platform-tools
export PATH=$PATH:$ANDROID_SDK_ROOT/build-tools/35.0.0
export PATH=$PATH:$ANDROID_SDK_ROOT/ndk/27.2.12479018
EOF
chmod +x /etc/profile.d/tanzanite-dev.sh
echo "Environment variables configured in /etc/profile.d/tanzanite-dev.sh"
