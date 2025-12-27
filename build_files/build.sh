#!/bin/bash

set -ouex pipefail

# BASE_NAME is passed from Containerfile (cosmic, aurora, bluefin, bazzite)
BASE_NAME="${BASE_NAME:-cosmic}"
echo "Building for base: ${BASE_NAME}"

# Helper function to check if we're on a uBlue base
is_ublue() {
    [[ "$BASE_NAME" == "aurora" || "$BASE_NAME" == "bluefin" || "$BASE_NAME" == "bazzite" ]]
}

# Helper function to check if we're on vanilla Fedora Atomic
is_fedora_atomic() {
    [[ "$BASE_NAME" == "cosmic" ]]
}

### Filesystem fixes
# Both Fedora Atomic and uBlue bases may have /opt and /usr/local as symlinks
# We need them to be real directories for packages and dev tools

# [IM]MUTABLE /opt
# Fedora has /opt symlinked to /var/opt, making it mutable.
# Some packages (google-chrome, docker-desktop) write to /opt,
# which gets wiped on bootc deploy. Make it immutable.
if [[ -L /opt ]]; then
    echo "Fixing /opt symlink..."
    rm /opt && mkdir /opt
fi

# [IM]MUTABLE /usr/local
# /usr/local may be symlinked to /var/usrlocal in ostree-based systems
# We need it immutable for Go, Rust, Node.js, etc.
if [[ -L /usr/local ]]; then
    echo "Fixing /usr/local symlink..."
    rm -rf /usr/local
fi
mkdir -p /usr/local/bin /usr/local/go /usr/local/rustup /usr/local/cargo /usr/local/bun

### Install packages

# Packages can be installed from any enabled yum repo on the image.

# Basic packages
dnf5 install -y tmux mosh

### Kernel CachyOS - DISABLED for bootc builds
# Custom kernel installation fails in container builds because dracut cannot
# generate initramfs properly (modules.dep missing, no /dev/log, etc.)
# 
# To install CachyOS kernel on the LIVE system after booting, run:
#   sudo dnf copr enable bieszczaders/kernel-cachyos
#   sudo rpm-ostree install kernel-cachyos kernel-cachyos-devel-matched
#   sudo setsebool -P domain_kernel_load_modules on
#   systemctl reboot
#
# The base Fedora COSMIC Atomic image includes a working kernel.

### Windsurf IDE
rpm --import https://windsurf-stable.codeiumdata.com/wVxQEIWkwPUEAGf3/yum/RPM-GPG-KEY-windsurf
cat > /etc/yum.repos.d/windsurf.repo << 'EOF'
[windsurf]
name=Windsurf Repository
baseurl=https://windsurf-stable.codeiumdata.com/wVxQEIWkwPUEAGf3/yum/repo/
enabled=0
autorefresh=1
gpgcheck=1
gpgkey=https://windsurf-stable.codeiumdata.com/wVxQEIWkwPUEAGf3/yum/RPM-GPG-KEY-windsurf
EOF
dnf5 install -y --enablerepo=windsurf windsurf

### Set hostname
echo "tanzanite" > /etc/hostname

### Python (ensure available) + uv package manager
dnf5 install -y python3 python3-pip python3-devel
# Install uv directly (installer script has issues with ostree filesystem)
mkdir -p /usr/local/bin
curl -LsSf https://github.com/astral-sh/uv/releases/latest/download/uv-x86_64-unknown-linux-gnu.tar.gz | tar -xz -C /usr/local/bin --strip-components=1
chmod +x /usr/local/bin/uv /usr/local/bin/uvx

### Go toolchain
curl -L https://go.dev/dl/go1.23.5.linux-amd64.tar.gz -o /tmp/go.tar.gz
rm -rf /usr/local/go
tar -C /usr/local -xzf /tmp/go.tar.gz
rm /tmp/go.tar.gz

### Rust toolchain (system-wide via rustup)
export RUSTUP_HOME=/usr/local/rustup
export CARGO_HOME=/usr/local/cargo
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
chmod -R a+rX /usr/local/rustup /usr/local/cargo

### Node.js (direct install - fnm has issues in container builds)
NODE_VERSION="v24.1.0"
curl -fsSL "https://nodejs.org/dist/${NODE_VERSION}/node-${NODE_VERSION}-linux-x64.tar.xz" | tar -xJ -C /usr/local --strip-components=1
corepack enable pnpm


### Bun runtime (system-wide)
curl -fsSL https://bun.sh/install | BUN_INSTALL=/usr/local/bun bash

### Development tools and AOSP packages
# Note: "Development Tools" group doesn't exist in F43, installing packages directly
dnf5 install -y \
    gcc \
    gcc-c++ \
    make \
    automake \
    autoconf \
    libtool \
    flex \
    bison \
    patch \
    zlib-devel \
    glibc-devel.i686 \
    libstdc++-devel.i686 \
    zlib-ng-compat-devel.i686 \
    xorg-x11-proto-devel \
    libX11-devel \
    mesa-libGL-devel \
    ncurses-devel \
    readline-devel \
    java-21-openjdk-devel

### Android repo tool
mkdir -p /usr/local/bin
curl -L https://storage.googleapis.com/git-repo-downloads/repo -o /usr/local/bin/repo
chmod a+rx /usr/local/bin/repo

### Android SDK Command-line Tools & NDK
ANDROID_SDK_ROOT=/usr/local/android-sdk
mkdir -p "$ANDROID_SDK_ROOT/cmdline-tools"

# Download command-line tools
CMDLINE_TOOLS_URL="https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip"
curl -L "$CMDLINE_TOOLS_URL" -o /tmp/cmdline-tools.zip
unzip -q /tmp/cmdline-tools.zip -d "$ANDROID_SDK_ROOT/cmdline-tools"
mv "$ANDROID_SDK_ROOT/cmdline-tools/cmdline-tools" "$ANDROID_SDK_ROOT/cmdline-tools/latest"
rm /tmp/cmdline-tools.zip

# Accept licenses and install platform-tools, build-tools, NDK
yes | "$ANDROID_SDK_ROOT/cmdline-tools/latest/bin/sdkmanager" --licenses
"$ANDROID_SDK_ROOT/cmdline-tools/latest/bin/sdkmanager" \
    "platform-tools" \
    "build-tools;35.0.0" \
    "platforms;android-35" \
    "ndk;27.2.12479018" \
    "cmake;3.22.1"

chmod -R a+rX "$ANDROID_SDK_ROOT"

### scrcpy (Android screen mirroring) - from GitHub, repo version is outdated
SCRCPY_VERSION="3.3.4"
curl -L "https://github.com/Genymobile/scrcpy/releases/download/v${SCRCPY_VERSION}/scrcpy-linux-x86_64-v${SCRCPY_VERSION}.tar.gz" | tar -xz -C /usr/local --strip-components=1

### Set up PATH for all users via profile.d
cat > /etc/profile.d/tanzanite-dev.sh << 'EOF'
# Go
export PATH=$PATH:/usr/local/go/bin

# Rust
export RUSTUP_HOME=/usr/local/rustup
export CARGO_HOME=/usr/local/cargo
export PATH=$PATH:/usr/local/cargo/bin

# fnm (Node.js)
export PATH="/usr/local/fnm:$PATH"
eval "$(/usr/local/fnm/fnm env 2>/dev/null)" || true

# Bun
export BUN_INSTALL=/usr/local/bun
export PATH=$PATH:/usr/local/bun/bin

# Android repo
export PATH=$PATH:/usr/local/bin

# Android SDK
export ANDROID_SDK_ROOT=/usr/local/android-sdk
export ANDROID_HOME=$ANDROID_SDK_ROOT
export PATH=$PATH:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin
export PATH=$PATH:$ANDROID_SDK_ROOT/platform-tools
export PATH=$PATH:$ANDROID_SDK_ROOT/build-tools/35.0.0
export PATH=$PATH:$ANDROID_SDK_ROOT/ndk/27.2.12479018
EOF
chmod +x /etc/profile.d/tanzanite-dev.sh

### Container runtimes
dnf5 install -y podman podman-docker docker-compose

#### Enable System Services

systemctl enable podman.socket
