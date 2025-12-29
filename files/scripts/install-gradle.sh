#!/usr/bin/env bash
# TEAM_006: Install Gradle and pre-cache wrapper distributions
#
# TEAM_011 WARNING: ALWAYS VERIFY ASSUMPTIONS BEFORE CHANGING THIS FILE!
# TEAM_011 WARNING: ALWAYS VERIFY ASSUMPTIONS BEFORE CHANGING THIS FILE!
# TEAM_011 WARNING: ALWAYS VERIFY ASSUMPTIONS BEFORE CHANGING THIS FILE!
# TEAM_011 WARNING: ALWAYS VERIFY ASSUMPTIONS BEFORE CHANGING THIS FILE!
# TEAM_011 WARNING: ALWAYS VERIFY ASSUMPTIONS BEFORE CHANGING THIS FILE!
# - Read previous team files before modifying
# - Test changes don't break existing functionality
# - DO NOT assume based on training data - VERIFY with live sources
# - /var/cache does NOT persist from build on ostree
# TEAM_011 WARNING: ALWAYS VERIFY ASSUMPTIONS BEFORE CHANGING THIS FILE!
# TEAM_011 WARNING: ALWAYS VERIFY ASSUMPTIONS BEFORE CHANGING THIS FILE!
# TEAM_011 WARNING: ALWAYS VERIFY ASSUMPTIONS BEFORE CHANGING THIS FILE!
# TEAM_011 WARNING: ALWAYS VERIFY ASSUMPTIONS BEFORE CHANGING THIS FILE!
# TEAM_011 WARNING: ALWAYS VERIFY ASSUMPTIONS BEFORE CHANGING THIS FILE!
#
set -euo pipefail

echo "=== Installing Gradle ==="

GRADLE_VERSION="9.2.1"

echo "Downloading Gradle ${GRADLE_VERSION}..."
curl -fSL --connect-timeout 30 --max-time 300 \
    "https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip" \
    -o /tmp/gradle.zip
unzip -q /tmp/gradle.zip -d /usr/local
ln -sf /usr/local/gradle-${GRADLE_VERSION}/bin/gradle /usr/bin/gradle
rm /tmp/gradle.zip
echo "Gradle installed: $(gradle --version | head -3)"

# Note: Gradle wrapper pre-caching removed.
# On ostree systems, /var/cache is not persisted from build time.
# Users will download wrappers on first use (normal Gradle behavior).
echo "Gradle wrapper caching skipped (ostree: /var not persisted from build)"

echo "=== Gradle Complete ==="
