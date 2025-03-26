#!/bin/bash

# Maverick MacBook Setup Monolith Script

# Exit on any error
set -euo pipefail

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

# Ensure this script is running on macOS
check_platform() {
    if [[ "$(uname -s)" != "Darwin" ]]; then
        echo "[✘] This script is designed for macOS only"
        exit 1
    fi
}

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

# Install Core Essentials
install_essentials() {
    log "Installing Essential Applications"
    
    # Productivity apps
    brew install --cask --quiet \
        zen-browser \
        alfred \
        spotify \
        ghostty \
        obsidian \
        appcleaner \
        obs \
        qbittorrent \
        ente-auth \
        plex \
        tailscale

    brew cleanup --quiet
    log "Essential Applications installed"
}

# Install Utilities
install_utilities() {
    log "Installing Utilities"
    
    # CLI and utility tools
    brew install --quiet \
        neovim \
        yt-dlp \
        koekeishiya/formulae/skhd \
        mas \
        stow \
        fzf \
        zsh-autosuggestions \
        switchaudio-osx

    brew cleanup
    log "Utilities installed"
}

# Install Creative Tools
install_creative() {
    log "Installing creative tools"
    
    # Creative applications
    brew install --cask --quiet \
        blender \
        rive \
        imageoptim

    brew cleanup
    log "Creative tools installed"
}

# MacOS Configuration Function
configure_macos() {
    # Array of apps to pin (full paths)
    local DOCK_APPS=(
        "/Applications/Things3.app"
        "/Applications/Obsidian.app"
        "/Applications/Zen.app"
        "/Applications/Ghostty.app"
        "/Applications/Spotify.app"
    )

    log "Configuring macOS settings"
    
    # Set Dark Mode
    osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to true'
    log "Dark mode configured"
    
    # Pin Dock Apps
    defaults write com.apple.dock persistent-apps -array
    for app in "${DOCK_APPS[@]}"; do
        defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>$app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"
    done
    log "Pinned dock apps"

    # Configure Dock visibility
    defaults write com.apple.dock autohide -bool true
    defaults write com.apple.dock autohide-delay -float 0
    defaults write com.apple.dock autohide-time-modifier -float 0
    defaults write com.apple.dock show-recents -bool false

    # Hide menu bar
    defaults write NSGlobalDomain _HIHideMenuBar -bool true

    # Restart Dock and Finder
    killall Dock
    killall Finder
    log "macOS settings configured correctly"
}

# Main setup function
main() {
    clear
    log "Starting MacBook Setup"
    echo "Press ctrl+c to abort"
    sleep 3

    # Run setup steps
    check_platform
    check_dependencies
    check_xcode_tools
    install_homebrew
    install_essentials
    install_utilities
    install_creative
    configure_macos

    log "MacBook Setup Complete! :) Have fun!"
    clear
}

# Run the main function
main
