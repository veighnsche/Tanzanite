#!/bin/bash
# TEAM_002: Development tools module
[[ -n "$TANZANITE_BUILD" ]] || { echo "Must be sourced from build.sh"; exit 1; }

section "Part 4: Development Tools & Build Dependencies"

subsection "Installing C/C++ build tools"
dnf5 install -y \
    gcc \
    gcc-c++ \
    make \
    automake \
    autoconf \
    libtool \
    flex \
    bison \
    patch
echo "C/C++ build tools installed"

subsection "Installing AOSP build dependencies"
dnf5 install -y \
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
echo "AOSP build dependencies installed"
echo "Java version: $(java -version 2>&1 | head -1)"

# TEAM_003: Gradle build system
subsection "Installing Gradle"
GRADLE_VERSION="8.12"
download_file "https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip" /tmp/gradle.zip
unzip -q /tmp/gradle.zip -d /usr/local
ln -sf /usr/local/gradle-${GRADLE_VERSION}/bin/gradle /usr/bin/gradle
rm /tmp/gradle.zip
echo "Gradle installed: $(gradle --version | head -3)"

# Pre-download common Gradle wrapper versions (baked into image for offline use)
subsection "Pre-caching Gradle wrapper distributions"
GRADLE_USER_HOME="/usr/share/gradle"
mkdir -p "$GRADLE_USER_HOME/wrapper/dists"
for WRAPPER_VER in "8.12" "8.11.1" "8.10.2" "8.9"; do
    echo "  Downloading Gradle wrapper ${WRAPPER_VER}..."
    WRAPPER_DIR="$GRADLE_USER_HOME/wrapper/dists/gradle-${WRAPPER_VER}-bin"
    mkdir -p "$WRAPPER_DIR"
    download_file "https://services.gradle.org/distributions/gradle-${WRAPPER_VER}-bin.zip" "$WRAPPER_DIR/gradle-${WRAPPER_VER}-bin.zip"
done
chmod -R a+rX "$GRADLE_USER_HOME"
echo "Gradle wrappers pre-cached to $GRADLE_USER_HOME"

subsection "Verifying development tools"
verify_command gcc && \
verify_command g++ "g++" && \
verify_command make && \
verify_command java "Java 21" && \
verify_command gradle "Gradle" && \
verify_path "$GRADLE_USER_HOME/wrapper/dists" "Gradle wrapper cache" || exit 1
