#!/bin/bash
# TEAM_002: Base packages module
[[ -n "$TANZANITE_BUILD" ]] || { echo "Must be sourced from build.sh"; exit 1; }

section "Part 2: Base Packages"

# TEAM_003: Update all system packages to latest versions
subsection "Updating system packages"
dnf5 upgrade --refresh -y
echo "System packages updated to latest versions"

subsection "Installing basic packages"
dnf5 install -y tmux mosh

# Kernel CachyOS - DISABLED for bootc builds
# Custom kernel installation fails in container builds because dracut cannot
# generate initramfs properly (modules.dep missing, no /dev/log, etc.)
# 
# To install CachyOS kernel on the LIVE system after booting, run:
#   sudo dnf copr enable bieszczaders/kernel-cachyos
#   sudo rpm-ostree install kernel-cachyos kernel-cachyos-devel-matched
#   sudo setsebool -P domain_kernel_load_modules on
#   systemctl reboot

subsection "Installing Windsurf IDE"
retry 3 rpm --import https://windsurf-stable.codeiumdata.com/wVxQEIWkwPUEAGf3/yum/RPM-GPG-KEY-windsurf
cat > /etc/yum.repos.d/windsurf.repo << 'EOF'
[windsurf]
name=Windsurf Repository
baseurl=https://windsurf-stable.codeiumdata.com/wVxQEIWkwPUEAGf3/yum/repo/
enabled=0
autorefresh=1
gpgcheck=1
gpgkey=https://windsurf-stable.codeiumdata.com/wVxQEIWkwPUEAGf3/yum/RPM-GPG-KEY-windsurf
EOF
dnf5 install -y --enablerepo=windsurf windsurf

subsection "Setting hostname"
echo "tanzanite" > /etc/hostname
echo "Hostname set to: tanzanite"

subsection "Verifying base packages"
verify_command tmux && \
verify_command mosh && \
verify_command windsurf "Windsurf IDE" || exit 1
