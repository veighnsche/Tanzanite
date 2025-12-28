#!/usr/bin/env bash
# TEAM_006: Install Flutter SDK
# Note: Flutter warns about running as root, but this is expected in container builds
# We set BOT=true to suppress these warnings and signal CI environment
export BOT=true
set -euo pipefail

echo "=== Installing Flutter ==="

FLUTTER_DIR="/usr/share/flutter"

echo "Cloning Flutter SDK..."
git clone --depth 1 --branch stable https://github.com/flutter/flutter.git "$FLUTTER_DIR"
git config --system --add safe.directory "$FLUTTER_DIR"

ln -sf "$FLUTTER_DIR/bin/flutter" /usr/bin/flutter
ln -sf "$FLUTTER_DIR/bin/dart" /usr/bin/dart

# Set pub cache location
export PUB_CACHE=/var/cache/pub-cache
mkdir -p "$PUB_CACHE"
export PATH="$FLUTTER_DIR/bin:$PATH"
export HOME=/root

# TEAM_008: Fix tar ownership errors - Flutter downloads tarballs with UIDs that don't exist in container
# Flutter calls tar with absolute path. We must wrap ALL tar binaries.
_wrap_tar() {
    local tar_path="$1"
    if [[ -x "$tar_path" ]] && [[ ! -f "${tar_path}.real" ]]; then
        cp "$tar_path" "${tar_path}.real"
        cat > "$tar_path" << 'TARWRAPPER'
#!/bin/bash
# TEAM_008: Wrapper to add --no-same-owner for container builds
REAL_TAR="${0}.real"
exec "$REAL_TAR" --no-same-owner "$@"
TARWRAPPER
        chmod +x "$tar_path"
        echo "Wrapped $tar_path with --no-same-owner"
    fi
}
_wrap_tar /usr/sbin/tar
_wrap_tar /usr/bin/tar

# Precache ALL platform binaries during build (filesystem is read-only at runtime)
echo "Pre-caching Flutter binaries..."
flutter precache --android --linux --web

# Restore original tar binaries
_restore_tar() {
    local tar_path="$1"
    if [[ -f "${tar_path}.real" ]]; then
        mv "${tar_path}.real" "$tar_path"
        echo "Restored $tar_path"
    fi
}
_restore_tar /usr/sbin/tar
_restore_tar /usr/bin/tar

# Disable analytics (Q1 resolution: use --no-analytics and ignore root warning)
flutter config --no-analytics
dart --disable-analytics

# Note: devtools is bundled with Flutter 3.x, no need to install separately
# dart_style is also included in the Dart SDK

chmod -R a+rX "$PUB_CACHE" "$FLUTTER_DIR"
echo "Pub cache: $PUB_CACHE"
echo "Flutter installed: $(flutter --version --machine | head -1)"

echo "=== Flutter Complete ==="
