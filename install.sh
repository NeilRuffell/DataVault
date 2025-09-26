#!/bin/bash
# offline_sync_installer.sh
# Safe system-wide installer for offline_sync.sh

set -e

SCRIPT_NAME="offline_sync.sh"
EXAMPLE_FILE="example_dirs.txt"
INSTALL_PATH="/usr/local/bin"

# Check required files exist
if [[ ! -f "$SCRIPT_NAME" ]]; then
    echo "Error: $SCRIPT_NAME not found in current directory."
    exit 1
fi

if [[ ! -f "$EXAMPLE_FILE" ]]; then
    echo "Error: $EXAMPLE_FILE not found in current directory."
    exit 1
fi

echo "Installing $SCRIPT_NAME to $INSTALL_PATH..."
sudo cp "$SCRIPT_NAME" "$INSTALL_PATH/"
sudo chmod 755 "$INSTALL_PATH/$SCRIPT_NAME"
echo "Done."

echo "Setting up per-user configs..."

# Loop over /home/* and only process real users
for userdir in /home/*; do
    user=$(basename "$userdir")

    if id "$user" &>/dev/null; then
        CONFIG_FILE="$userdir/.offline_sync_dirs"
        if [[ -f "$CONFIG_FILE" ]]; then
            echo "Config already exists for $user, skipping."
        else
            cp "$EXAMPLE_FILE" "$CONFIG_FILE"
            chown "$user:$user" "$CONFIG_FILE"
            chmod 600 "$CONFIG_FILE"
            echo "Created config for $user at $CONFIG_FILE"
        fi
    fi
done

echo ""
echo "Installation complete!"
echo "Each user can edit ~/.offline_sync_dirs to list directories they want synced."
echo "Run $INSTALL_PATH/$SCRIPT_NAME to perform dry-run sync."
