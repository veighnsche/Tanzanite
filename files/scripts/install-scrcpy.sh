#!/usr/bin/env bash
# TEAM_006: Install scrcpy for Android screen mirroring
set -euo pipefail

echo "=== Installing scrcpy ==="

SCRCPY_VERSION="3.3.4"

# NOTE: Do NOT use dnf scrcpy - it's outdated and broken
echo "Downloading scrcpy v${SCRCPY_VERSION}..."
curl -fSL --connect-timeout 30 --max-time 300 \
    "https://github.com/Genymobile/scrcpy/releases/download/v${SCRCPY_VERSION}/scrcpy-linux-x86_64-v${SCRCPY_VERSION}.tar.gz" \
    -o /tmp/scrcpy.tar.gz
mkdir -p /opt/scrcpy
tar -xz -C /opt/scrcpy --strip-components=1 --no-same-owner -f /tmp/scrcpy.tar.gz
rm /tmp/scrcpy.tar.gz

# Find the actual binary (it's inside the extracted folder)
SCRCPY_BIN="/opt/scrcpy/scrcpy"
if [[ ! -f "$SCRCPY_BIN" ]]; then
    echo "ERROR: scrcpy binary not found at $SCRCPY_BIN"
    ls -R /opt/scrcpy
    exit 1
fi

ln -sf "$SCRCPY_BIN" /usr/local/bin/scrcpy
chmod +x "$SCRCPY_BIN" /usr/local/bin/scrcpy
echo "scrcpy v${SCRCPY_VERSION} installed to /opt/scrcpy"

# Create desktop entry
echo "Creating scrcpy desktop entry..."
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
curl -fSL --connect-timeout 30 --max-time 60 \
    "https://raw.githubusercontent.com/Genymobile/scrcpy/master/app/data/icon.png" \
    -o /usr/share/icons/hicolor/256x256/apps/scrcpy.png
echo "scrcpy desktop entry created"

echo "=== scrcpy Complete ==="
