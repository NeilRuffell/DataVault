#!/bin/bash
# -----------------------------
# Offline Sync Installer
# -----------------------------
# Copies offline_sync.sh to /usr/local/bin
# Creates per-user ~/.offline_sync_dirs if missing
# Sets permissions
# Optionally creates a KDE launcher
# -----------------------------

SCRIPT_NAME="offline_sync.sh"
DESKTOP_FILE_NAME="offline-sync.desktop"
TEMPLATE_DIRS="example_dirs.txt"

# -----------------------------
# Helper function
# -----------------------------

# -----------------------------
# 1. Copy script to /usr/local/bin
# -----------------------------
echo "Installing $SCRIPT_NAME to /usr/local/bin..."
sudo cp "$SCRIPT_NAME" /usr/local/bin/
sudo chmod 755 /usr/local/bin/$SCRIPT_NAME
echo "Done."

# -----------------------------
# 2. Create per-user config
# -----------------------------
echo "Setting up per-user configs..."
for user_home in /home/*; do
    # skip if not a directory
    [ ! -d "$user_home" ] && continue

    config_file="$user_home/.offline_sync_dirs"
    if [ ! -f "$config_file" ]; then
        cp "$TEMPLATE_DIRS" "$config_file"
        chown "$(basename $user_home):$(basename $user_home)" "$config_file"
        chmod 644 "$config_file"
        echo "Created config for $(basename $user_home) at $config_file"
    else
        echo "Config already exists for $(basename $user_home), skipping."
    fi


done

echo "Installation complete!"
echo "Each user should edit ~/.offline_sync_dirs to list directories they want synced."
echo "Run /usr/local/bin/$SCRIPT_NAME to perform dry-run sync."
