#!/bin/bash

# -----------------------------
# Configuration
# -----------------------------
DRY_RUN=true    # set to false to actually perform sync
PROPAGATE_DELETIONS=false  # set true to propagate deletions
HOME_DIR="$HOME"
DATA_DIR="$HOME/DataVault"
DIRS_FILE="$HOME/.offline_sync_dirs"
RSYNC_OPTS="-avu"
[ "$DRY_RUN" = false ] && RSYNC_OPTS+=" -n"

# -----------------------------
# Check if DataVault is mounted
# -----------------------------
if ! mountpoint -q "$DATA_DIR"; then
    kdialog --msgbox "DataVault is NOT mounted! Sync aborted."
    echo "ERROR: DataVault is not mounted. Exiting."
    exit 1
fi

# -----------------------------
# Read directories from per-user config
# -----------------------------
if [ ! -f "$DIRS_FILE" ]; then
    echo "No directory config found at $DIRS_FILE. Exiting."
    exit 1
fi

DIRS=()
while IFS= read -r line || [ -n "$line" ]; do
    DIRS+=("$line")
done < "$DIRS_FILE"

# -----------------------------
# Sync loop
# -----------------------------
for DIR in "${DIRS[@]}"; do
    echo "============================"
    echo "Syncing $DIR..."
    echo "============================"

    mkdir -p "$DATA_DIR/$DIR"

    # Home -> DataVault
    rsync $RSYNC_OPTS --exclude='.directory' "$HOME_DIR/$DIR/" "$DATA_DIR/$DIR/"

    # DataVault -> Home for existing files only
    rsync $RSYNC_OPTS --existing --exclude='.directory' "$DATA_DIR/$DIR/" "$HOME_DIR/$DIR/"

    # Optional deletions
    if [ "$PROPAGATE_DELETIONS" = true ]; then
        rsync $RSYNC_OPTS --existing --delete --exclude='.directory' "$DATA_DIR/$DIR/" "$HOME_DIR/$DIR/"
    fi
done

echo "Dry-run complete. If DRY_RUN=false, changes would be applied."
kdialog --msgbox "Offline sync dry-run complete. Check terminal or logs for details."
