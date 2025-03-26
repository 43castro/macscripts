#!/bin/bash
# MacOS Configuration Script

# Array of apps to pin (full paths)
DOCK_APPS=(
    "/Applications/Things3.app"
    "/Applications/Obsidian.app"
    "/Applications/Zen.app"
    "/Applications/Ghostty.app"
    "/Applications/Spotify.app"
)

pin_dock_apps() {
    # Reset Dock
    defaults write com.apple.dock persistent-apps -array

    # Pin apps from array
    for app in "${DOCK_APPS[@]}"; do
        defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>$app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"
    done
}

configure_macos() {
    log "Configuring macOS settings"
    
    # Set Dark Mode
    osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to true'
    log "Dark mode configured"
    
    # Pin apps
    pin_dock_apps
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
    log "macOS setting configured correctly"
}

# Run the configuration
configure_macos
