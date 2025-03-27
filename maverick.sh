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

# Function to install Oh My Zsh and set Zsh as the default shell
install_oh_my_zsh() {
  # Check if Zsh is installed
  if ! command -v zsh &> /dev/null; then
    log "Zsh is not installed. Installing Zsh"
    # Install Zsh using Homebrew
    brew install zsh
  else
    log "Zsh is already installed."
  fi

  # Check if Oh My Zsh is already installed
  if [ -d "$HOME/.oh-my-zsh" ]; then
    log "Oh My Zsh is already installed."
  else
    log "Installing Oh My Zsh"
    # Install Oh My Zsh using the official installation script
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  fi

  # Change the default shell to Zsh
  log "Changing the default shell to Zsh"
  chsh -s "$(command -v zsh)"

  log "Oh My Zsh installation and default shell change complete."
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
        iina \
        syncthing \
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
        zsh-syntax-highlighting \
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


# Clone and stow dotfiles
clone_dotfiles(){
  local DOTFILES_REPO="https://github.com/43castro/.dotfiles"
  local DOTFILES_DIR="$HOME/.dotfiles"

    # Check if dotfiles directory already exists
    if [ -d "$DOTFILES_DIR" ]; then
        log "Dotfiles directory already exists. Pulling latest changes."
        cd "$DOTFILES_DIR" && git pull origin main
    else
        log "Cloning dotfiles repository"
        git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
    fi

    # Change to dotfiles directory
    cd "$DOTFILES_DIR"

    # Check if stow is installed
    if ! command -v stow &> /dev/null; then
        warn "Stow is not installed. Please install stow first."
        return 1
    fi

    # List of directories to stow (common dotfile directories)
    local STOW_DIRS=(
        "zsh"
        "git"
        "nvim"
        "skhd"
        "ghostty"
    )

    # Remove .zshrc if it exists
    if [ -f ~/.zshrc ]; then
        rm ~/.zshrc
        log ".zshrc file removed"
    else
        log ".zshrc file not found, stowing"
    fi

    # Stow each directory
    for dir in "${STOW_DIRS[@]}"; do
        if [ -d "$dir" ]; then
            log "Stowing $dir configuration"
            stow -v "$dir"
        else
            warn "Dotfile directory $dir not found. Skipping."
        fi
    done

    log "Dotfiles cloned and stowed successfully"
}

# Symlink creation function
create_symlink() {
    local DOTFILES_DIR="$HOME/.dotfiles"
    local source_file="$DOTFILES_DIR/castro.zsh-theme"
    local target_file="$HOME/.oh-my-zsh/themes/castro.zsh-theme"

    if [ ! -f "$source_file" ]; then
        warn "Source file $source_file does not exist. Skipping symlink creation."
        return 1
    fi

    if [ -e "$target_file" ]; then
        warn "Target file $target_file already exists. Skipping symlink creation."
        return 0
    fi

    mkdir -p "$(dirname "$target_file")"
    ln -s "$source_file" "$target_file"
    log "Created symlink: $source_file -> $target_file"
}

# MacOS Configuration Function
configure_macos() {
    # Array of apps to pin (full paths)
    local DOCK_APPS=(
        "/Applications/Obsidian.app"
        "/Applications/Zen.app"
        "/Applications/Ghostty.app"
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

    # Hide color tags in Finder
    defaults write com.apple.finder ShowRecentTags -bool false

    # Add the home folder as the default for a new window
    defaults write com.apple.finder NewWindowTarget -string "PfHm"
    defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}"

    # Hide external drives, internal drives, mounted servers, and removable media
    defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false
    defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
    defaults write com.apple.finder ShowMountedServersOnDesktop -bool false
    defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false

    # Enable reduce motion
    defaults write -g NSReduceMotionEnabled -bool TRUE

    # Disable natural scroll
    defaults write -g com.apple.swipescrolldirection -bool FALSE

    # Restart Dock and Finder
    killall Dock
    killall Finder

    log "macOS settings configured correctly"

    # Start skhd service
    skhd --start-service
    # Define the target directory path
    TARGET_DIR="$HOME/Development"

    # Check if the directory exists
    if [ ! -d "$TARGET_DIR" ]; then
    # Directory does not exist, create it
        mkdir -p "$TARGET_DIR"
        log "Directory '$TARGET_DIR' has been created."
    else
        log "Directory '$TARGET_DIR' already exists."
    fi
    log "macOS settings configured correctly"
}

open_urls() {
  local urls=(
    "https://www.torrentmac.net/?s=affinity"
    "https://www.torrentmac.net/?s=davinci"
    "https://www.torrentmac.net/?s=logic"
    "https://www.torrentmac.net/?s=transmit"
    "https://www.torrentmac.net/?s=capture+one"
    "https://www.torrentmac.net/?s=things+"
  )

  for url in "${urls[@]}"; do
    if command -v xdg-open &> /dev/null; then
      xdg-open "$url"
    elif command -v open &> /dev/null; then
      open "$url"
    else
      echo "No suitable command found to open URLs."
      return 1
    fi
  done
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
    install_oh_my_zsh
    install_essentials
    install_utilities
    install_creative
    clone_dotfiles
    create_symlink
    configure_macos
    open_urls
    log "MacBook Setup Complete! Make sure to reeboot now. :) Have fun!"
    clear
}

main
