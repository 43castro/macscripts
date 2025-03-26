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

# Base URL for the raw module scripts on GitHub
BASE_URL="https://raw.githubusercontent.com/your-username/your-repo/main/modules"

# Main setup function
main() {
    clear
    echo "Starting MacBook Setup"
    echo "Press Ctrl+C to abort"
    sleep 3
    # List of module scripts to source
    modules=("core.sh" "essentials.sh" "utilities.sh" "creative.sh" "macos_config.sh")
    # Source each module script
    for module in "${modules[@]}"; do
        source <(curl -fsSL "${BASE_URL}/${module}") || {
            echo "Error: Failed to source ${module}"
            exit 1
        }
    done
    echo "MacBook Setup Complete! :) Have fun!"
    clear
}

# Run the main function
main
