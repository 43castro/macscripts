#!/bin/bash

# Essentials Installation Module
install_essentials() {
    log "Installing Essential Applications"
    
    # Productivity
    brew install --cask --quiet \
        zen-browser \
        alfred \
        spotify \
        ghostty \
        obsidian \
        appcleaner \
        obs \
        obsidian \
        appcleaner \
        obs \
        qbittorrent \
        ente-auth \
        plex \
        tailscale \

    brew cleanup
    log "Essential Applications installed"
}

# Run the essentials installation
install_essentials
