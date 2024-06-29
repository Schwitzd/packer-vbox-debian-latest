#!/bin/bash

cat << "EOF"
______          _                     _                     _      _     _               _       _            _   
| ___ \        | |                   | |                   | |    | |   (_)             | |     | |          | |  
| |_/ /_ _  ___| | _____ _ __  __   _| |__   _____  __   __| | ___| |__  _  __ _ _ __   | | __ _| |_ ___  ___| |_ 
|  __/ _` |/ __| |/ / _ \ '__| \ \ / / '_ \ / _ \ \/ /  / _` |/ _ \ '_ \| |/ _` | '_ \  | |/ _` | __/ _ \/ __| __|
| | | (_| | (__|   <  __/ |     \ V /| |_) | (_) >  <  | (_| |  __/ |_) | | (_| | | | | | | (_| | ||  __/\__ \ |_ 
\_|  \__,_|\___|_|\_\___|_|      \_/ |_.__/ \___/_/\_\  \__,_|\___|_.__/|_|\__,_|_| |_| |_|\__,_|\__\___||___/\__|

EOF

read -p "VM Name (e.g. debian-web): " VM_NAME
read -p "VM User (e.g. liam): " VM_USER
read -p "CPUs (e.g. 4): " VM_CPUS
read -p "RAM (MB, e.g. 4096): " VM_RAM
read -p "Disk Size (MB, e.g. 5000): " VM_DISK_SIZE

# Define the file paths
KEY_NAME="vbox-${VM_NAME}_ed25519"
PRIVATE_KEY_PATH="$HOME/.ssh/$KEY_NAME"
PUBLIC_KEY_PATH="$HOME/.ssh/${KEY_NAME}.pub"
DESTINATION_PUBLIC_KEY="/$(pwd)/http"
DEBIAN_MIRROR="https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/"
VARIABLE_FILE="config/values.pkrvars.hcl"
PRESEED_FILE="http/preseed.cfg"

# Generate the ED25519 key pair
ssh-keygen -t ed25519 -f "$PRIVATE_KEY_PATH" -N ''  > /dev/null 2>&1

# Copy the public key to the specified destination folder
cp "$PUBLIC_KEY_PATH" "$DESTINATION_PUBLIC_KEY/key.pub"

# Create preseed.cfg
cp preseed_template.cfg $PRESEED_FILE
sed -i "s/{VM_NAME}/$VM_NAME/g" $PRESEED_FILE
sed -i "s/{VM_USER}/$VM_USER/g" $PRESEED_FILE

# Get Latest Debian .iso url & hash
ISO_NAME=$(curl -sL "$DEBIAN_MIRROR" | grep -oP 'debian-\d+(\.\d+)*-amd64-netinst\.iso' | head -n1)
SHA256_HASH=$(curl -s "$DEBIAN_MIRROR/SHA256SUMS" | grep "$ISO_NAME" | awk '{print $1}')

# Construct the variables.pkrvars.hcl content
hlc_content=$(cat <<EOF
vm_name         = "$VM_NAME"
vm_cpus         = $VM_CPUS
vm_ram          = $VM_RAM
vm_disk_size    = $VM_DISK_SIZE
vm_user         = "$VM_USER"
ssh_private_key = "$PRIVATE_KEY_PATH"
iso_url         = "$DEBIAN_MIRROR$ISO_NAME"
iso_checksum    = "$SHA256_HASH"
EOF
)

# Write variables.hcl
echo "$hlc_content" > "$VARIABLE_FILE"

## Start provisioning
# for debuging add PACKER_LOG=1 at beginning of the command 
PACKER_LOG=1 packer build -var-file="$VARIABLE_FILE" .