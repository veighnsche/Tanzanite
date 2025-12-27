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

subsection "Verifying development tools"
verify_command gcc && \
verify_command g++ "g++" && \
verify_command make && \
verify_command java "Java 21" || exit 1
