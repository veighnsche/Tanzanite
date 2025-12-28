#!/usr/bin/env bash
# TEAM_006: System setup (hostname, services)
set -euo pipefail

echo "=== System Setup ==="

# Set hostname
echo "Setting hostname..."
echo "tanzanite" > /etc/hostname
echo "Hostname set to: tanzanite"

# Enable podman socket
echo "Enabling podman.socket..."
systemctl enable podman.socket
echo "podman.socket enabled"

echo "=== System Setup Complete ==="
