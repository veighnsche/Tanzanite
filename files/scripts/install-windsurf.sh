#!/usr/bin/env bash
# TEAM_006: Install Windsurf IDE
set -euo pipefail

echo "=== Installing Windsurf IDE ==="

# Import GPG key with retry
echo "Importing Windsurf GPG key..."
for attempt in 1 2 3; do
    echo "  Attempt $attempt/3..."
    if rpm --import https://windsurf-stable.codeiumdata.com/wVxQEIWkwPUEAGf3/yum/RPM-GPG-KEY-windsurf; then
        break
    fi
    if (( attempt >= 3 )); then
        echo "  ERROR: Failed to import GPG key after 3 attempts"
        exit 1
    fi
    sleep 5
done

# Create repo file
echo "Creating Windsurf repository..."
cat > /etc/yum.repos.d/windsurf.repo << 'EOF'
[windsurf]
name=Windsurf Repository
baseurl=https://windsurf-stable.codeiumdata.com/wVxQEIWkwPUEAGf3/yum/repo/
enabled=0
autorefresh=1
gpgcheck=1
gpgkey=https://windsurf-stable.codeiumdata.com/wVxQEIWkwPUEAGf3/yum/RPM-GPG-KEY-windsurf
EOF

# Install Windsurf
echo "Installing Windsurf..."
dnf5 install -y --enablerepo=windsurf windsurf

echo "=== Windsurf IDE Complete ==="
