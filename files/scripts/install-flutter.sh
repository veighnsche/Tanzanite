#!/usr/bin/env bash
# TEAM_006: Install Flutter SDK
# Note: Flutter warns about running as root, but this is expected in container builds
set -euo pipefail

echo "=== Installing Flutter ==="

FLUTTER_DIR="/usr/share/flutter"

echo "Cloning Flutter SDK..."
git clone --depth 1 --branch stable https://github.com/flutter/flutter.git "$FLUTTER_DIR"
git config --system --add safe.directory "$FLUTTER_DIR"

ln -sf "$FLUTTER_DIR/bin/flutter" /usr/bin/flutter
ln -sf "$FLUTTER_DIR/bin/dart" /usr/bin/dart

# Set pub cache location
export PUB_CACHE=/usr/share/flutter/.pub-cache
export PATH="$FLUTTER_DIR/bin:$PATH"
export HOME=/root

# Precache ALL platform binaries during build (filesystem is read-only at runtime)
echo "Pre-caching Flutter binaries..."
flutter precache --android --linux --web

# Disable analytics (Q1 resolution: use --no-analytics and ignore root warning)
flutter config --no-analytics
dart --disable-analytics

# Pre-cache Dart pub global packages
echo "Pre-caching Dart pub packages..."
export PUB_CACHE=/usr/share/pub-cache
mkdir -p "$PUB_CACHE"
dart pub global activate devtools
dart pub global activate dart_style

chmod -R a+rX "$PUB_CACHE" "$FLUTTER_DIR"
echo "Pub cache: $PUB_CACHE"
echo "Flutter installed: $(flutter --version --machine | head -1)"

echo "=== Flutter Complete ==="
