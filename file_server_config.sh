#!/bin/bash

# Detect the current username
USERNAME=$(whoami)

# Install required packages
echo "Installing required packages..."
sudo apt-get update
sudo apt-get install -y samba dos2unix
echo "Packages installed successfully."

# Constants
MOUNT_DIR="/media/$USERNAME"

# Get the device name of the inserted block device
DEVICE_NAME=$(lsblk -o NAME,MOUNTPOINT | grep "$MOUNT_DIR" | awk '{print $1}')

# Check if the device is a removable disk (USB drive)
if [ -b "/dev/$DEVICE_NAME" ] && [ -w "/dev/$DEVICE_NAME" ] && [ "$(cat /sys/block/$DEVICE_NAME/removable)" == "1" ]; then
    # Create Samba Share Configuration
    SHARE_NAME="PortableDiskShared_$DEVICE_NAME"
    SHARE_PATH="$MOUNT_DIR/PortableDisk_$DEVICE_NAME/Shared"

    echo "Creating Samba share configuration for $DEVICE_NAME..."
    sudo mkdir -p "$SHARE_PATH"
    sudo chmod -R 777 "$SHARE_PATH"

    # Append Samba Share Configuration to smb.conf
    echo -e "\n[$SHARE_NAME]" | sudo tee -a /etc/samba/smb.conf
    echo "   comment = Shared Folder on Portable Disk $DEVICE_NAME" | sudo tee -a /etc/samba/smb.conf
    echo "   path = $SHARE_PATH" | sudo tee -a /etc/samba/smb.conf
    echo "   browseable = yes" | sudo tee -a /etc/samba/smb.conf
    echo "   read only = no" | sudo tee -a /etc/samba/smb.conf
    echo "   guest ok = yes" | sudo tee -a /etc/samba/smb.conf
    echo "   create mask = 0777" | sudo tee -a /etc/samba/smb.conf
    echo "   directory mask = 0777" | sudo tee -a /etc/samba/smb.conf

    # Restart Samba service
    echo "Restarting Samba service..."
    sudo service smbd restart
    echo "Samba service restarted successfully."
else
    echo "No removable disk found in $MOUNT_DIR."
fi
