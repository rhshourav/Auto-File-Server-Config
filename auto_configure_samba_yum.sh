#!/bin/bash

# Install Samba and enable the necessary services
sudo yum install -y samba
sudo systemctl enable smb nmb
sudo systemctl start smb nmb

# Enable and start the firewall (firewalld)
sudo systemctl enable firewalld
sudo systemctl start firewalld

# Allow Samba traffic in the firewall
sudo firewall-cmd --add-service=samba --permanent
sudo firewall-cmd --reload

# Convert line endings to Unix format
dos2unix auto_configure_samba_centos.sh

# Constants
MOUNT_DIR="/media/$(whoami)"

# Get the device name of the inserted block device
DEVICE_NAME=$(lsblk -o NAME,MOUNTPOINT | grep "$MOUNT_DIR" | awk '{print $1}')

# Check if the device is a removable disk (USB drive)
if [ -b "/dev/$DEVICE_NAME" ] && [ -w "/dev/$DEVICE_NAME" ] && [ "$(cat /sys/block/$DEVICE_NAME/removable)" == "1" ]; then
    # Create Samba Share Configuration
    SHARE_NAME="PortableDiskShared_$DEVICE_NAME"
    SHARE_PATH="$MOUNT_DIR/PortableDisk_$DEVICE_NAME/Shared"

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
    sudo systemctl restart smb nmb
    echo "Samba service restarted successfully."
else
    echo "No removable disk found in $MOUNT_DIR."
fi

echo "Samba auto-configuration completed successfully."
