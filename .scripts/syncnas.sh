#!/usr/bin/env bash

SMB_SERVER="//freebox-server.local/NAS"
SMB_CREDS="/home/akitake/.smbcreds"
MOUNT_POINT="/mnt/SMB"
LOCAL_DIR="/mnt/HDD/"
DIRECTION="to_smb"
EXCLUDES=(
  "SteamLibrary/"
  "Games"
  ".Trash-1000"
  ".*"
)

echo "Mounting SMB share..."
sudo mount -t cifs "$SMB_SERVER" "$MOUNT_POINT" -o credentials=$SMB_CREDS,vers=3.0,uid=1000,gid=1000
if [ $? -ne 0 ]; then
  echo "Failed to mount SMB share. Exiting."
  exit 1
fi

RSYNC_EXCLUDES=""
for folder in "${EXCLUDES[@]}"; do
  RSYNC_EXCLUDES+=" --exclude=$folder"
done

echo "Starting rsync..."
if [ "$DIRECTION" == "to_smb" ]; then
  rsync -avh --progress $RSYNC_EXCLUDES "$LOCAL_DIR" "$MOUNT_POINT/"
elif [ "$DIRECTION" == "from_smb" ]; then
  rsync -avh --progress $RSYNC_EXCLUDES "$MOUNT_POINT/" "$LOCAL_DIR"
else
  echo "Invalid DIRECTION: $DIRECTION"
  sudo umount "$MOUNT_POINT"
  exit 1
fi

echo "Unmounting SMB share..."
sudo umount "$MOUNT_POINT"
echo "Done."
