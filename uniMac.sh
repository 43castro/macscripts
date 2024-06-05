#!/bin/bash

set -e

apps=("Firefox" "DaVinci Resolve")

# Removes all pinned apps from the dock
defaults write com.apple.dock persistent-apps -array

# Makes the dock automatically hide
defaults write com.apple.dock "autohide" -bool "true"

# Disables the recent apps inside the dock
defaults write com.apple.dock show-recents -bool false

# Cycles through the apps in the array
for app in "${apps[@]}"; do
	#Pinning apps to the dock from the previous array
	defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/${app}.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"
done

# Kills the dock for the changes to apply
killall Dock

# To hide the menu bar. Change it to false if you want to revert the changes
defaults write NSGlobalDomain _HIHideMenuBar -bool true && killall Finder
