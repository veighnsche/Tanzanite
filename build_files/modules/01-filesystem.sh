#!/bin/bash
# TEAM_002: Filesystem setup module
[[ -n "$TANZANITE_BUILD" ]] || { echo "Must be sourced from build.sh"; exit 1; }

section "Part 1: Filesystem Setup"

# Both Fedora Atomic and uBlue bases may have /opt and /usr/local as symlinks
# We need them to be real directories for packages and dev tools

subsection "Fixing /opt symlink"
# Fedora has /opt symlinked to /var/opt, making it mutable.
# Some packages (google-chrome, docker-desktop) write to /opt,
# which gets wiped on bootc deploy. Make it immutable.
if [[ -L /opt ]]; then
    echo "Converting /opt from symlink to directory..."
    rm /opt && mkdir /opt
else
    echo "/opt is already a directory, skipping"
fi

subsection "Fixing /usr/local symlink"
# /usr/local may be symlinked to /var/usrlocal in ostree-based systems
# We need it immutable for Go, Rust, Node.js, etc.
if [[ -L /usr/local ]]; then
    echo "Converting /usr/local from symlink to directory..."
    rm -rf /usr/local
else
    echo "/usr/local is already a directory, skipping"
fi
mkdir -p /usr/local/bin /usr/local/go /usr/local/rustup /usr/local/cargo /usr/local/bun
echo "Created /usr/local subdirectories"
