#!/usr/bin/env bash
# TEAM_012: Install Scala and sbt for JVM/Android development
set -euo pipefail

echo "=== Installing Scala ==="

SCALA_VERSION="3.3.7"
SBT_VERSION="1.10.7"

# Install Scala
echo "Downloading Scala ${SCALA_VERSION}..."
curl -fSL --connect-timeout 30 --max-time 300 \
    "https://github.com/scala/scala3/releases/download/${SCALA_VERSION}/scala3-${SCALA_VERSION}.tar.gz" \
    -o /tmp/scala.tar.gz

tar -xzf /tmp/scala.tar.gz -C /usr/local
ln -sf /usr/local/scala3-${SCALA_VERSION}/bin/scala /usr/bin/scala
ln -sf /usr/local/scala3-${SCALA_VERSION}/bin/scalac /usr/bin/scalac
ln -sf /usr/local/scala3-${SCALA_VERSION}/bin/scaladoc /usr/bin/scaladoc
rm /tmp/scala.tar.gz

echo "Scala installed: $(scala -version 2>&1 | head -1 || echo "v${SCALA_VERSION}")"

# Install sbt
echo "Downloading sbt ${SBT_VERSION}..."
curl -fSL --connect-timeout 30 --max-time 300 \
    "https://github.com/sbt/sbt/releases/download/v${SBT_VERSION}/sbt-${SBT_VERSION}.tgz" \
    -o /tmp/sbt.tgz

tar -xzf /tmp/sbt.tgz -C /usr/local
ln -sf /usr/local/sbt/bin/sbt /usr/bin/sbt
rm /tmp/sbt.tgz

echo "sbt installed: v${SBT_VERSION}"

echo "=== Scala Complete ==="
