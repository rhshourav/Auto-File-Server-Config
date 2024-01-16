#!/bin/bash

# Detect the current username
USERNAME=$(whoami)

# Remove Samba package and disable firewall
echo "Removing Samba package and disabling firewall..."
sudo apt-get remove -y samba
sudo ufw deny 139/tcp
sudo ufw deny 445/tcp
sudo ufw disable

# Remove Samba share configuration
echo "Removing Samba share configuration..."
DEVICE_NAME=$(lsblk -o NAME,MOUNTPOINT | grep "/media/$USERNAME" | awk '{print $1}')
SHARE_NAME="PortableDiskShared_$DEVICE_NAME"
sudo sed -i "/\[$SHARE_NAME\]/,/^$/d" /etc/samba/smb.conf

# Restart Samba service
echo "Restarting Samba service..."
sudo service smbd restart
echo "Samba service restarted successfully."

# Clean up temporary files
echo "Cleaning up temporary files..."
rm -f remove_samba_config.sh

echo "Samba configuration removed successfully."
