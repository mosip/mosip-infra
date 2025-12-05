#!/bin/bash

# VM Inventory Setup Script
# This script helps you create or update the Ansible inventory file for PostgreSQL setup

set -e

# Default values
INVENTORY_FILE="hosts.ini"
DEFAULT_USER="ubuntu"
DEFAULT_PORT="22"
DEFAULT_PG_VERSION="15"
DEFAULT_DEVICE="/dev/nvme2n1"
DEFAULT_MOUNT_POINT="/srv/postgres"
DEFAULT_NETWORK="10.1.0.0/16"
DEFAULT_PG_PORT="5432"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -f, --file FILE       Inventory file name (default: hosts.ini)"
    echo "  -h, --help            Show this help message"
    echo ""
    echo "This script will guide you through setting up your VM inventory."
    echo ""
    echo "Examples:"
    echo "  $0                    # Interactive setup with default inventory file"
    echo "  $0 -f my-hosts.ini   # Use custom inventory file name"
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -f|--file)
            INVENTORY_FILE="$2"
            shift 2
            ;;
        -h|--help)
            print_usage
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            print_usage
            exit 1
            ;;
    esac
done

echo -e "${GREEN}=== VM Inventory Setup ===${NC}"
echo "This script will help you create the inventory file for PostgreSQL automation."
echo ""

# Check if inventory file already exists
if [[ -f "$INVENTORY_FILE" ]]; then
    echo -e "${YELLOW}Warning: Inventory file '$INVENTORY_FILE' already exists.${NC}"
    echo "Current content:"
    echo "----------------------------------------"
    cat "$INVENTORY_FILE"
    echo "----------------------------------------"
    echo ""
    read -p "Do you want to overwrite it? (y/N): " overwrite
    if [[ $overwrite != [yY] && $overwrite != [yY][eE][sS] ]]; then
        echo "Setup cancelled."
        exit 0
    fi
fi

# Collect VM information
echo -e "${BLUE}=== VM Connection Details ===${NC}"
echo ""

# VM IP Address
while true; do
    read -p "Enter your VM IP address: " vm_ip
    if [[ -n "$vm_ip" ]]; then
        break
    else
        echo -e "${RED}IP address cannot be empty.${NC}"
    fi
done

# SSH User
read -p "Enter SSH username (default: $DEFAULT_USER): " ssh_user
ssh_user="${ssh_user:-$DEFAULT_USER}"

# SSH Key Path
echo ""
echo "SSH Key Configuration:"
echo "Please provide the path to your SSH private key file."
echo "Common locations:"
echo "  • ~/.ssh/id_rsa"
echo "  • ~/.ssh/your-key.pem"
echo "  • ~/Downloads/your-aws-key.pem"
echo ""

while true; do
    read -p "Enter SSH private key file path: " ssh_key
    if [[ -n "$ssh_key" ]]; then
        # Expand tilde to home directory
        ssh_key="${ssh_key/#\~/$HOME}"
        
        if [[ -f "$ssh_key" ]]; then
            break
        else
            echo -e "${RED}File not found: $ssh_key${NC}"
            echo "Please check the path and try again."
        fi
    else
        echo -e "${RED}SSH key path cannot be empty.${NC}"
    fi
done

# SSH Port (optional)
read -p "Enter SSH port (default: $DEFAULT_PORT): " ssh_port
ssh_port="${ssh_port:-$DEFAULT_PORT}"

# Server Name
read -p "Enter server name for inventory (default: vm_server): " server_name
server_name="${server_name:-vm_server}"

echo ""
echo -e "${BLUE}=== PostgreSQL Configuration ===${NC}"
echo "These parameters will be used for PostgreSQL installation:"
echo ""

# PostgreSQL Version
read -p "Enter PostgreSQL version (default: $DEFAULT_PG_VERSION): " pg_version
pg_version="${pg_version:-$DEFAULT_PG_VERSION}"

# Storage Device
echo ""
echo "Storage Device Configuration:"
echo "This is the block device where PostgreSQL data will be stored."
echo "Common devices: /dev/sdb, /dev/nvme2n1, /dev/xvdf"
echo ""
read -p "Enter storage device path (default: $DEFAULT_DEVICE): " storage_device
storage_device="${storage_device:-$DEFAULT_DEVICE}"

# Mount Point
echo ""
echo "Mount Point Configuration:"
echo "This is where the storage device will be mounted for PostgreSQL data."
echo ""
read -p "Enter mount point (default: $DEFAULT_MOUNT_POINT): " mount_point
mount_point="${mount_point:-$DEFAULT_MOUNT_POINT}"

# Network CIDR
echo ""
echo "Network Configuration:"
echo "This is the network CIDR for PostgreSQL access control."
echo "Examples: 10.1.0.0/16, 192.168.1.0/24, 172.16.0.0/12"
echo ""
read -p "Enter network CIDR (default: $DEFAULT_NETWORK): " network_cidr
network_cidr="${network_cidr:-$DEFAULT_NETWORK}"


# PostgreSQL Port
echo ""
echo "PostgreSQL Port Configuration:"
echo "This is the port PostgreSQL will listen on."
echo "Default is 5432, but you might want to use a different port for security."
echo ""
read -p "Enter PostgreSQL port (default: $DEFAULT_PG_PORT): " pg_port
pg_port="${pg_port:-$DEFAULT_PG_PORT}"
echo ""
echo -e "${BLUE}=== Configuration Summary ===${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "VM Connection:"
echo "  Server Name: $server_name"
echo "  IP Address: $vm_ip"
echo "  SSH User: $ssh_user"
echo "  SSH Key: $ssh_key"
echo "  SSH Port: $ssh_port"
echo ""
echo "PostgreSQL Configuration:"
echo "  Version: $pg_version"
echo "  Storage Device: $storage_device"
echo "  Mount Point: $mount_point"
echo "  Network CIDR: $network_cidr"
echo "  PostgreSQL Port: $pg_port"
echo ""
echo "Inventory File: $INVENTORY_FILE"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

read -p "Create inventory file with these settings? (y/N): " confirm
if [[ $confirm != [yY] && $confirm != [yY][eE][sS] ]]; then
    echo "Setup cancelled."
    exit 0
fi

# Create the inventory file
echo -e "${GREEN}Creating inventory file...${NC}"

cat > "$INVENTORY_FILE" << INVENTORY_EOF
# Ansible Inventory for PostgreSQL Setup on Virtual Machine
# Generated by setup-vm-inventory.sh on $(date)
#
# Configuration Summary:
# - PostgreSQL Version: $pg_version
# - Storage Device: $storage_device
# - Mount Point: $mount_point
# - Network CIDR: $network_cidr
# - PostgreSQL Port: $pg_port

[postgresql_servers]
$server_name ansible_host=$vm_ip ansible_user=$ssh_user ansible_ssh_private_key_file=$ssh_key ansible_port=$ssh_port

[postgresql_servers:vars]
# SSH and Ansible Configuration
ansible_become=yes
ansible_become_method=sudo
ansible_ssh_common_args='-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'
ansible_python_interpreter=/usr/bin/python3
ansible_ssh_timeout=30
ansible_connect_timeout=30

# PostgreSQL Configuration Variables
postgresql_version=$pg_version
storage_device=$storage_device
mount_point=$mount_point
network_cidr=$network_cidr

# Additional PostgreSQL Variables
postgresql_port=$pg_port

# For local testing (if needed)
[local]
localhost ansible_connection=local
INVENTORY_EOF

echo -e "${GREEN}✓ Inventory file '$INVENTORY_FILE' created successfully!${NC}"
echo ""

# Test connectivity
echo -e "${BLUE}=== Testing Connectivity ===${NC}"
echo "Testing SSH connection to your VM..."

if command -v ansible &> /dev/null; then
    if ansible postgresql_servers -i "$INVENTORY_FILE" -m ping; then
        echo -e "${GREEN}✓ Connection test successful!${NC}"
        echo ""
        echo -e "${GREEN}=== Setup Complete ===${NC}"
        echo "Your inventory is ready with the following configuration:"
        echo "  • PostgreSQL Version: $pg_version"
        echo "  • Storage Device: $storage_device"
        echo "  • Mount Point: $mount_point"
        echo "  • Network CIDR: $network_cidr"
echo "  • PostgreSQL Port: $pg_port"
        echo ""
        echo "You can now run your PostgreSQL automation scripts:"
        echo "  ./ansible-postgresql.sh"
        echo ""
        echo "Or test with manual commands like:"
        echo "  ansible-playbook -i $INVENTORY_FILE your-playbook.yml"
        echo ""
    else
        echo -e "${RED}✗ Connection test failed${NC}"
        echo ""
        echo -e "${YELLOW}=== Troubleshooting Tips ===${NC}"
        echo "1. Check if your VM is running and accessible"
        echo "2. Verify the IP address is correct"
        echo "3. Ensure SSH key has correct permissions (600)"
        echo "4. Check if the SSH user has sudo privileges"
        echo "5. Verify firewall/security groups allow SSH access"
        echo "6. Make sure the storage device exists on the target VM"
        echo ""
        echo "You can test manually with:"
        echo "  ssh -i $ssh_key $ssh_user@$vm_ip"
        echo ""
        echo "The inventory file has been created, but please fix connectivity issues before proceeding."
    fi
else
    echo -e "${YELLOW}⚠ Ansible not found - skipping connectivity test${NC}"
    echo "Install Ansible to test connectivity: sudo apt install ansible"
    echo ""
    echo -e "${GREEN}=== Setup Complete ===${NC}"
    echo "Inventory file created with your configuration."
fi

echo ""
echo -e "${BLUE}=== Inventory File Created ===${NC}"
echo "File: $INVENTORY_FILE"
echo "Location: $(pwd)/$INVENTORY_FILE"
echo ""
echo "You can review the inventory file with:"
echo "  cat $INVENTORY_FILE"
