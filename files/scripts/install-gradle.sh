#!/usr/bin/env bash
# TEAM_006: Install Gradle and pre-cache wrapper distributions
set -euo pipefail

echo "=== Installing Gradle ==="

GRADLE_VERSION="8.12"

echo "Downloading Gradle ${GRADLE_VERSION}..."
curl -fSL --connect-timeout 30 --max-time 300 \
    "https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip" \
    -o /tmp/gradle.zip
unzip -q /tmp/gradle.zip -d /usr/local
ln -sf /usr/local/gradle-${GRADLE_VERSION}/bin/gradle /usr/bin/gradle
rm /tmp/gradle.zip
echo "Gradle installed: $(gradle --version | head -3)"

# Pre-download common Gradle wrapper versions
echo "Pre-caching Gradle wrapper distributions..."
GRADLE_USER_HOME="/usr/share/gradle"
mkdir -p "$GRADLE_USER_HOME/wrapper/dists"

for WRAPPER_VER in "8.12" "8.11.1" "8.10.2" "8.9"; do
    echo "  Downloading Gradle wrapper ${WRAPPER_VER}..."
    WRAPPER_DIR="$GRADLE_USER_HOME/wrapper/dists/gradle-${WRAPPER_VER}-bin"
    mkdir -p "$WRAPPER_DIR"
    curl -fSL --connect-timeout 30 --max-time 300 \
        "https://services.gradle.org/distributions/gradle-${WRAPPER_VER}-bin.zip" \
        -o "$WRAPPER_DIR/gradle-${WRAPPER_VER}-bin.zip"
done

chmod -R a+rX "$GRADLE_USER_HOME"
echo "Gradle wrappers pre-cached to $GRADLE_USER_HOME"

echo "=== Gradle Complete ==="
