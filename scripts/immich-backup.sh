#!/usr/bin/env bash
# Nightly encrypted backup of an Immich library with restic.
# Settings come from /etc/immich-backup/env (see guide/11-backups.md).
set -euo pipefail

# The folders to back up: your upload location and your External Library folder(s).
FOLDERS=(
  /mnt/photos/immich_upload
  /mnt/photos/immich-demo
)

source /etc/immich-backup/env

# Refuse to back up an empty or unmounted drive (that would look like "everything was deleted").
for f in "${FOLDERS[@]}"; do
  if [ ! -d "$f" ] || [ -z "$(ls -A "$f")" ]; then
    echo "$(date -Is) ERROR: $f is missing or empty; is the drive mounted? Nothing backed up." >&2
    exit 1
  fi
done

echo "$(date -Is) backup starting"
restic backup "${FOLDERS[@]}" --tag immich
restic forget --tag immich --keep-daily 7 --keep-weekly 4 --keep-monthly 12 --prune
restic check
echo "$(date -Is) backup done"
