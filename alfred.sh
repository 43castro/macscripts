#!/bin/bash

alfred_settings() {
  # Open Alfred
  open -a "Alfred 5"

  # Wait for Alfred to launch (adjust the delay if necessary)
  sleep 2

  # Use AppleScript to simulate the button click
  osascript -e '
  tell application "System Events"
      tell process "Alfred"
          -- Wait for Alfred window to appear
          delay 1
          -- Click the "Skip setup" button (adjust if necessary)
          click button "Skip setup" of window 1
      end tell
  end tell'

  # Base Alfred preferences path
  ALFRED_PREFS_BASE="$HOME/Library/Application Support/Alfred/Alfred.alfredpreferences/preferences"

  # Check if the base directory exists
  if [ ! -d "$ALFRED_PREFS_BASE" ]; then
    echo "Alfred preferences directory does not exist: $ALFRED_PREFS_BASE"
    exit 1
  fi

  # Find the local hash directory
  LOCAL_HASH_DIR=$(find "$ALFRED_PREFS_BASE/local" -type d -maxdepth 1 | grep -v '/local$' | head -n 1)

  # Validate the local hash directory
  if [ -z "$LOCAL_HASH_DIR" ]; then
    echo "Local hash directory not found."
    exit 1
  fi

  # Paths for the two plist files
  APPEARANCE_GLOBAL_PLIST="$ALFRED_PREFS_BASE/appearance/options/prefs.plist"
  APPEARANCE_LOCAL_PLIST="$LOCAL_HASH_DIR/appearance/prefs.plist"

  # Ensure the appearance directories exist
  mkdir -p "$(dirname "$APPEARANCE_GLOBAL_PLIST")"
  mkdir -p "$(dirname "$APPEARANCE_LOCAL_PLIST")"

  # Create global appearance options plist
  cat > "$APPEARANCE_GLOBAL_PLIST" <<- EOF
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
    <key>hidehat</key>
    <true/>
    <key>hidemenu</key>
    <true/>
    <key>hideshortcuts</key>
    <true/>
    </dict>
    </plist>
EOF

  # Create local appearance options plist
  cat > "$APPEARANCE_LOCAL_PLIST" <<- EOF
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>darkthemeuid</key>
        <string>theme.bundled.osxdark</string>
      </dict>
      </plist>
EOF

  # Ensure correct permissions
  chmod 644 "$APPEARANCE_GLOBAL_PLIST"
  chmod 644 "$APPEARANCE_LOCAL_PLIST"

  # Restart Alfred using AppleScript
  osascript -e 'tell application "Alfred 5" to quit'
  osascript -e 'tell application "Alfred 5" to activate'
}


