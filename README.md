# Offline Sync

This script syncs a user's home directories with a per-user mounted DataVault using rsync.
- Supports dry-run mode
- Skips `.directory` files
- User-independent, uses $HOME
- Popup notifications via kdialog

## Setup

1. Copy `offline_sync.sh` to `/usr/local/bin/` and make it executable:

```bash
sudo cp offline_sync.sh /usr/local/bin/
sudo chmod +x /usr/local/bin/offline_sync.sh
