#!/usr/bin/env bash
# TEAM_006: Final system update and cleanup
set -euo pipefail

echo "=== Finalizing Build ==="

# Update all packages to latest versions
echo "Running final dnf update..."
dnf5 upgrade --refresh -y

echo "Cleaning dnf cache..."
dnf5 clean all

echo ""
echo "========================================"
echo "  TANZANITE BUILD FINISHED SUCCESSFULLY"
echo "========================================"
echo ""

echo "=== Finalize Complete ==="
