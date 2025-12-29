#!/usr/bin/env bash
# TEAM_012: Install Apache Maven for JVM/Android builds
set -euo pipefail

echo "=== Installing Maven ==="

MAVEN_VERSION="3.9.12"

echo "Downloading Maven ${MAVEN_VERSION}..."
curl -fSL --connect-timeout 30 --max-time 300 \
    "https://dlcdn.apache.org/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz" \
    -o /tmp/maven.tar.gz

tar -xzf /tmp/maven.tar.gz -C /usr/local
ln -sf /usr/local/apache-maven-${MAVEN_VERSION}/bin/mvn /usr/bin/mvn
ln -sf /usr/local/apache-maven-${MAVEN_VERSION}/bin/mvnDebug /usr/bin/mvnDebug
rm /tmp/maven.tar.gz

echo "Maven installed: $(mvn --version | head -1)"

echo "=== Maven Complete ==="
