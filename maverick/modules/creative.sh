#!/bin/bash

# Essentials Installation Module
install_creative() {
    log "Installing creative tools"
    
    # Productivity
    brew install --cask --quiet \
        blender \
        rive \
        imageoptim \

    brew cleanup
    log "Creative tools installed"
}

# Run the essentials installation
install_creative
