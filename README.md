# MacScripts

Scripts for setting up macOS to my liking. Especially system settings with the dock, menu bar and hiding options. 

## maverick 
```bash
curl -sSL https://raw.githubusercontent.com/43castro/macscripts/refs/heads/main/maverick.sh | bash
```
## uni
```bash
curl -sSL https://raw.githubusercontent.com/43castro/macscripts/refs/heads/main/uniMac.sh | bash
```
maverick script does the following: 
- Checks if the platform is Apple Silicon
- Checks if git and curl are installed
- Check if xcode-tools are installed 
- Installs and updates homebrew 
- Install oh my zsh + changes the default terminal to zsh
- Installs essential apps: 
    - zen-browser
    - alfred
    - spotify 
    - ghostty 
    - obsidian 
    - appcleaner 
    - obs 
    - qbittorrent 
    - ente-auth 
    - plex 
    - tailscale
- Installs utilities: 
    - neovim 
    - yt-dlp 
    - koekeishiya/formulae/skhd 
    - mas 
    - stow 
    - fzf 
    - zsh-autosuggestions 
    - zsh-syntax-highlighting 
    - switchaudio-osx
- Installs creative apps: 
    - Blender
    - Rive
    - Image Optim
- Clones and stows dotfiles
- Configures macOS setting to my liking
    - Eliminates finder color tags from the sidebar
    - Configure Dock visibility
    - Hide menu bar
    - Add the home folder as the default for a new window
    - Hide external drives, internal drives, mounted servers, and removable media
    - Enable reduce motion
    - Disable natural scroll




