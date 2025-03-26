#!/bin/bash

# Ensure this script is running on macOS
if [[ "$(uname -s)" != "Darwin" ]]; then
    echo "[✘] This script is designed for macOS only"
    exit 1
fi

# Ensure pipelines return non-zero if any command fails
set -euo pipefail

# Check for required dependencies
check_dependencies() {
    # List of required command-line tools
    local dependencies=("curl" "git")
    for dep in "${dependencies[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            warn "Dependency not found: $dep"
            return 1
        fi
    done
}

# Check for Xcode Command Line Tools
check_xcode_tools() {
    if ! command -v xcode-select &> /dev/null; then
        log "Installing Xcode Command Line Tools"
        xcode-select --install
    else
        log "Xcode Command Line Tools already installed"
    fi
}

# Install Homebrew
install_homebrew() {
    if ! command -v brew &> /dev/null; then
        log "Installing Homebrew"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        # Add Homebrew to PATH
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        log "Homebrew already installed"
    fi
    
    # Update Homebrew
    brew update --quiet && brew upgrade --quiet
}

# Calls functions 
check_dependencies
check_xcode_tools
install_homebrew
