# Auto-Configurable Samba Share Setup

## Overview

Automatically configure a Samba share on a Linux machine for a portable HDD, designed for removable devices like USB pen drives.

## Prerequisites

- Linux machine with Samba installed.
- Portable HDD mounted under `/media/your_username`.
- Basic understanding of the Linux command line.

## Steps

### Script and Conversion

```

# Install required packages and enable firewall
sudo apt-get update
sudo apt-get install -y samba dos2unix
sudo ufw allow 139/tcp
sudo ufw allow 445/tcp
sudo ufw enable

# Convert line endings to Unix format
dos2unix auto_configure_samba.sh

# Execution
chmod +x auto_configure_samba.sh
./auto_configure_samba.sh
```
# Access from Windows
```
\\<Linux-IP-Address>   or   \\<Linux-Hostname>
```

# Removing Samba Configuration

## Overview

This guide outlines the steps to execute the `remove_samba_config.sh` script to remove the Samba share configuration and related changes made by the `auto_configure_samba.sh` script.

## Steps

### 1. Download the Script

Save the `remove_samba_config.sh` script to your Linux machine. You can download it directly or copy the content into a file using a text editor.

### 2. Make it Executable

Open a terminal and navigate to the directory where the script is located. Run the following command to make it executable:

```bash
chmod +x remove_samba_config.sh
./remove_samba_config.sh
```

