#!/bin/bash
# TEAM_002: Android development tools module
[[ -n "$TANZANITE_BUILD" ]] || { echo "Must be sourced from build.sh"; exit 1; }

section "Part 5: Android Development Tools"

subsection "Installing Android repo tool"
mkdir -p /usr/local/bin
download_file "https://storage.googleapis.com/git-repo-downloads/repo" /usr/local/bin/repo
chmod a+rx /usr/local/bin/repo
echo "repo tool installed"

subsection "Installing Android SDK Command-line Tools"
ANDROID_SDK_ROOT=/usr/local/android-sdk
mkdir -p "$ANDROID_SDK_ROOT/cmdline-tools"

CMDLINE_TOOLS_URL="https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip"
download_file "$CMDLINE_TOOLS_URL" /tmp/cmdline-tools.zip
unzip -q /tmp/cmdline-tools.zip -d "$ANDROID_SDK_ROOT/cmdline-tools"
mv "$ANDROID_SDK_ROOT/cmdline-tools/cmdline-tools" "$ANDROID_SDK_ROOT/cmdline-tools/latest"
rm /tmp/cmdline-tools.zip
echo "Android cmdline-tools installed"

subsection "Accepting Android SDK licenses"
# Accept licenses (ignore SIGPIPE from yes command)
yes 2>/dev/null | "$ANDROID_SDK_ROOT/cmdline-tools/latest/bin/sdkmanager" --licenses || true

subsection "Installing Android SDK components (platform-tools, build-tools, NDK)"
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

subsection "Installing scrcpy (screen mirroring)"
# NOTE: Do NOT use dnf scrcpy - it's outdated and broken
SCRCPY_VERSION="3.3.4"
download_file "https://github.com/Genymobile/scrcpy/releases/download/v${SCRCPY_VERSION}/scrcpy-linux-x86_64-v${SCRCPY_VERSION}.tar.gz" /tmp/scrcpy.tar.gz
mkdir -p /opt/scrcpy
tar -xz -C /opt/scrcpy --strip-components=1 -f /tmp/scrcpy.tar.gz
rm /tmp/scrcpy.tar.gz
# Symlink to PATH
ln -sf /opt/scrcpy/scrcpy /usr/local/bin/scrcpy
chmod +x /opt/scrcpy/scrcpy /usr/local/bin/scrcpy
echo "scrcpy v${SCRCPY_VERSION} installed to /opt/scrcpy"

subsection "Creating scrcpy desktop entry"
mkdir -p /usr/share/applications /usr/share/icons/hicolor/256x256/apps
cat > /usr/share/applications/scrcpy.desktop << 'EOF'
[Desktop Entry]
Name=scrcpy
Comment=Display and control Android devices
Exec=/opt/scrcpy/scrcpy
Icon=scrcpy
Terminal=false
Type=Application
Categories=Development;Utility;
Keywords=android;mirror;screen;adb;
EOF
# Download scrcpy icon
download_file "https://raw.githubusercontent.com/Genymobile/scrcpy/master/app/data/icon.png" /usr/share/icons/hicolor/256x256/apps/scrcpy.png
echo "scrcpy desktop entry created"
