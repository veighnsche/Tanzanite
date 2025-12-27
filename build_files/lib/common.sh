#!/bin/bash
# TEAM_002: Common helper functions for Tanzanite build
# Sourced by build.sh and all modules

#-------------------------------------------------------------------------------
# Output Functions
#-------------------------------------------------------------------------------

# Print section header
section() {
    echo ""
    echo "========================================"
    echo "  $1"
    echo "========================================"
    echo ""
}

# Print subsection
subsection() {
    echo "----------------------------------------"
    echo "  $1"
    echo "----------------------------------------"
}

#-------------------------------------------------------------------------------
# Network Functions
#-------------------------------------------------------------------------------

# Retry a command with exponential backoff
# Usage: retry <max_attempts> <command...>
retry() {
    local max_attempts=$1
    shift
    local attempt=1
    local delay=5

    while true; do
        echo "  Attempt $attempt/$max_attempts: $*"
        if "$@"; then
            return 0
        fi

        if (( attempt >= max_attempts )); then
            echo "  ERROR: Command failed after $max_attempts attempts: $*"
            return 1
        fi

        echo "  Failed. Retrying in ${delay}s..."
        sleep $delay
        attempt=$((attempt + 1))
        delay=$((delay * 2))  # Exponential backoff: 5, 10, 20, 40...
    done
}

# Download with retry (for curl operations)
# Usage: download_file <url> <output_file>
download_file() {
    local url=$1
    local output=$2
    retry 5 curl -fSL --connect-timeout 30 --max-time 300 "$url" -o "$output"
}

# Download and pipe to command with retry
# Usage: download_pipe <url> <command...>
download_pipe() {
    local url=$1
    shift
    local tmpfile
    tmpfile=$(mktemp)
    trap "rm -f '$tmpfile'" RETURN

    if ! retry 5 curl -fSL --connect-timeout 30 --max-time 600 "$url" -o "$tmpfile"; then
        return 1
    fi
    cat "$tmpfile" | "$@"
}

#-------------------------------------------------------------------------------
# Base Detection Functions
#-------------------------------------------------------------------------------

# Check if we're on a uBlue base
is_ublue() {
    [[ "$BASE_NAME" == "aurora" || "$BASE_NAME" == "bluefin" || "$BASE_NAME" == "bazzite" ]]
}

# Check if we're on vanilla Fedora Atomic
is_fedora_atomic() {
    [[ "$BASE_NAME" == "cosmic" ]]
}
