#!/bin/bash

# Essentials Installation Module
install_utilities() {
    log "Installing Utilities"
    
    # Productivity
    brew install --quiet\
        neovim \
        yt-dlp \
        koekeishiya/formulae/skhd \
        mas \
        stow \
        fzf \
        zsh-autosuggestions \
        switchaudio-osx \

    brew cleanup
    log "Utilities installed"
}

# Run the essentials installation
install_utilities

