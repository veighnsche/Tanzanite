#!/bin/bash
# TEAM_002: Filesystem setup module
[[ -n "$TANZANITE_BUILD" ]] || { echo "Must be sourced from build.sh"; exit 1; }

section "Part 1: Filesystem Setup"

# TEAM_003: Fix /root ONCE AND FOR ALL
# Some base images have /root as a symlink (to /var/roothome) or file, not a directory.
# Many tools (Flutter, corepack, uv, cargo, etc.) expect HOME=/root with proper structure.
subsection "Fixing /root directory"
if [[ -L /root ]]; then
    echo "Removing /root symlink..."
    rm -f /root
elif [[ -f /root ]]; then
    echo "Removing /root file..."
    rm -f /root
elif [[ -d /root ]]; then
    echo "/root is already a directory, skipping"
fi
# Create full directory structure for all tools
mkdir -p /root/.cache/node/corepack \
         /root/.local/share/uv \
         /root/.local/bin \
         /root/.cargo \
         /root/.rustup \
         /root/.config
chmod 700 /root
export HOME=/root
echo "/root directory structure created"

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

subsection "Verifying filesystem setup"
verify_path /root "root home directory" && \
verify_path /root/.cache "root cache directory" && \
verify_path /opt "opt directory" && \
verify_path /usr/local "usr/local directory" && \
verify_path /usr/local/bin "usr/local/bin directory" || exit 1
