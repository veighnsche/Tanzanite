#!/bin/bash
# TEAM_002: Modular Tanzanite build orchestrator

set -ouex pipefail

#===============================================================================
#                           TANZANITE BUILD SCRIPT
#===============================================================================

# Guard variable - modules check this to ensure they're sourced properly
export TANZANITE_BUILD=1

# BASE_NAME is passed from Containerfile (aurora, bluefin, bazzite)
export BASE_NAME="${BASE_NAME:-aurora}"

# Get the directory where this script lives
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

#-------------------------------------------------------------------------------
# Source common functions
#-------------------------------------------------------------------------------
source "$SCRIPT_DIR/lib/common.sh"

section "Tanzanite Build Starting"
echo "Building for base: ${BASE_NAME}"
echo "Date: $(date)"

#-------------------------------------------------------------------------------
# Execute modules in order
#-------------------------------------------------------------------------------
source "$SCRIPT_DIR/modules/01-filesystem.sh"
source "$SCRIPT_DIR/modules/02-packages.sh"
source "$SCRIPT_DIR/modules/03-languages.sh"
source "$SCRIPT_DIR/modules/04-devtools.sh"
source "$SCRIPT_DIR/modules/05-android.sh"
source "$SCRIPT_DIR/modules/06-environment.sh"
source "$SCRIPT_DIR/modules/07-containers.sh"
