#!/usr/bin/env bash
# TEAM_006: Install Android SDK and components
set -euo pipefail

echo "=== Installing Android SDK ==="

ANDROID_SDK_ROOT=/usr/local/android-sdk

# Install repo tool
echo "Installing Android repo tool..."
mkdir -p /usr/local/bin
curl -fSL --connect-timeout 30 --max-time 300 \
    "https://storage.googleapis.com/git-repo-downloads/repo" \
    -o /usr/local/bin/repo
chmod a+rx /usr/local/bin/repo
echo "repo tool installed"

# Install Android SDK Command-line Tools
echo "Installing Android SDK Command-line Tools..."
mkdir -p "$ANDROID_SDK_ROOT/cmdline-tools"

CMDLINE_TOOLS_URL="https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip"
curl -fSL --connect-timeout 30 --max-time 300 "$CMDLINE_TOOLS_URL" -o /tmp/cmdline-tools.zip
unzip -q /tmp/cmdline-tools.zip -d "$ANDROID_SDK_ROOT/cmdline-tools"
mv "$ANDROID_SDK_ROOT/cmdline-tools/cmdline-tools" "$ANDROID_SDK_ROOT/cmdline-tools/latest"
rm /tmp/cmdline-tools.zip
echo "Android cmdline-tools installed"

# Accept licenses
echo "Accepting Android SDK licenses..."
yes 2>/dev/null | "$ANDROID_SDK_ROOT/cmdline-tools/latest/bin/sdkmanager" --licenses || true

# Install SDK components
echo "Installing Android SDK components..."
"$ANDROID_SDK_ROOT/cmdline-tools/latest/bin/sdkmanager" \
    "platform-tools" \
    "build-tools;35.0.0" \
    "platforms;android-35" \
    "ndk;27.2.12479018" \
    "cmake;3.22.1"

chmod -R a+rX "$ANDROID_SDK_ROOT"
echo "Android SDK components installed:"
echo "  - platform-tools (adb, fastboot)"
echo "  - build-tools;35.0.0"
echo "  - platforms;android-35"
echo "  - ndk;27.2.12479018"
echo "  - cmake;3.22.1"

echo "=== Android SDK Complete ==="
