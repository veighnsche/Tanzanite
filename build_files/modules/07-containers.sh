#!/bin/bash
# TEAM_002: Container runtimes module
[[ -n "$TANZANITE_BUILD" ]] || { echo "Must be sourced from build.sh"; exit 1; }

section "Part 7: Container Runtimes"

subsection "Installing Podman and Docker compatibility"
dnf5 install -y podman podman-docker docker-compose
echo "Container runtimes installed"

subsection "Enabling system services"
systemctl enable podman.socket
echo "podman.socket enabled"

section "Build Complete"
echo ""
echo "========================================"
echo "  TANZANITE BUILD FINISHED SUCCESSFULLY"
echo "========================================"
echo ""
echo "Installed components:"
echo "  - Python $(python3 --version 2>&1 | cut -d' ' -f2) + uv"
echo "  - Go $(/usr/local/go/bin/go version 2>&1 | cut -d' ' -f3)"
echo "  - Rust $(/usr/local/cargo/bin/rustc --version 2>&1 | cut -d' ' -f2)"
echo "  - Node.js $(node --version)"
echo "  - Bun $(/usr/local/bun/bin/bun --version)"
echo "  - Android SDK (API 35, NDK 27.2)"
echo "  - scrcpy"
echo "  - Podman + Docker compatibility"
echo ""
