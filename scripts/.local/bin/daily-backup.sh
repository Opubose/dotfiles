#!/bin/bash

SOURCE_DIRS=("$HOME/Documents" "$HOME/.config")
BASE_DEST="/mnt/gyatt/Backups"
CURRENT_DEST="$BASE_DEST/Current"
SNAPSHOT_DIR="$BASE_DEST/History"
EXCLUDE_FILE="$HOME/.local/bin/backup-excludes.txt"
DATE=$(date +%Y-%m-%d_%H-%M-%S)
PKG_LIST_DIR="$CURRENT_DEST/pkg_lists"

if ! mountpoint -q /mnt/gyatt; then
    echo "Error: Backup drive not mounted. Aborting."
    notify-send "Backup Failed" "Drive Gyatt is not mounted." -u critical
    exit 1
fi

mkdir -p "$SNAPSHOT_DIR"
mkdir -p "$CURRENT_DEST"

echo "Starting backup for $DATE..."

for DIR in "${SOURCE_DIRS[@]}"; do
    rsync -av --delete --exclude-from="$EXCLUDE_FILE" "$DIR" "$CURRENT_DEST/"
done

mkdir -p "$PKG_LIST_DIR"
echo "Generating package lists..."
pacman -Qqen > "$PKG_LIST_DIR/arch_packages.txt"
pacman -Qqem > "$PKG_LIST_DIR/aur_packages.txt"

echo "Taking Btrfs Snapshot..."
btrfs subvolume snapshot "$CURRENT_DEST" "$SNAPSHOT_DIR/$DATE"

# --- Cleanup (Optional) ---
# Delete snapshots older than 30 days to save space (requires logic, simple version below)
# find "$SNAPSHOT_DIR" -maxdepth 1 -type d -mtime +30 -exec btrfs subvolume delete {} \;

echo "Backup finished successfully."
notify-send "Backup Complete" "Documents and Config synced to Gyatt." -u low
