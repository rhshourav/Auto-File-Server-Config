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

