#!/bin/bash

set -e

# Color codes
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Logging function with color
log() {
    local message="$1"
    echo -n -e "${GREEN}[+]${NC} $message "
    
    # Loading animation
    for _ in {1..3}; do
        echo -n "."
        sleep 0.5
    done
    echo ""
}

# Warning function
warn() {
    echo -e "${YELLOW}[!]${NC} $1"
}

# Get the directory of the script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODULES_DIR="$SCRIPT_DIR/modules"

# Main setup function
main() {
    clear
    log "Starting MacBook Setup"
    echo "Press ctrl+c to abort"
    sleep 3
    source "$MODULES_DIR/core.sh"
    source "$MODULES_DIR/essentials.sh"
    source "$MODULES_DIR/utilities.sh"
    source "$MODULES_DIR/creative.sh"
    source "$MODULES_DIR/macos_config.sh"
    log "MacBook Setup Complete! :) Have fun!"
    clear
}

# Run the main function
main
