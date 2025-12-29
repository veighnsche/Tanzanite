#!/usr/bin/env bash
# TEAM_012: Install Kotlin compiler and tools for Android development
set -euo pipefail

echo "=== Installing Kotlin ==="

KOTLIN_VERSION="2.3.0"

echo "Downloading Kotlin Native ${KOTLIN_VERSION}..."
curl -fSL --connect-timeout 30 --max-time 300 \
    "https://github.com/JetBrains/kotlin/releases/download/v${KOTLIN_VERSION}/kotlin-native-prebuilt-linux-x86_64-${KOTLIN_VERSION}.tar.gz" \
    -o /tmp/kotlin.tar.gz

tar -xzf /tmp/kotlin.tar.gz -C /usr/local
ln -sf /usr/local/kotlin-native-prebuilt-linux-x86_64-${KOTLIN_VERSION}/bin/kotlin /usr/bin/kotlin
ln -sf /usr/local/kotlin-native-prebuilt-linux-x86_64-${KOTLIN_VERSION}/bin/kotlinc /usr/bin/kotlinc
ln -sf /usr/local/kotlin-native-prebuilt-linux-x86_64-${KOTLIN_VERSION}/bin/kotlinc-native /usr/bin/kotlinc-native
ln -sf /usr/local/kotlin-native-prebuilt-linux-x86_64-${KOTLIN_VERSION}/bin/cinterop /usr/bin/cinterop
rm /tmp/kotlin.tar.gz

echo "Kotlin installed: $(kotlin -version 2>&1 || echo "v${KOTLIN_VERSION}")"

echo "=== Kotlin Complete ==="
