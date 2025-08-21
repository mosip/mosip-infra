#!/bin/bash

# Direct Ansible Command Execution for PostgreSQL Setup
# This script shows how to run PostgreSQL setup using direct ansible-playbook commands

set -e

# Default values
INVENTORY_FILE="hosts.ini"
PLAYBOOK_FILE="postgresql-setup.yml"
POSTGRESQL_VERSION="15"
STORAGE_DEVICE="/dev/sdb"
MOUNT_POINT="/srv/postgres"
TARGET_GROUP="postgresql_servers"
ALLOWED_NETWORKS=""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -i, --inventory FILE      Inventory file (default: hosts.ini)"
    echo "  -p, --playbook FILE       Playbook file (default: postgresql-setup.yml)"
    echo "  -v, --version VERSION     PostgreSQL version (default: 15)"
    echo "  -d, --device DEVICE       Storage device (default: /dev/sdb)"
    echo "  -m, --mount PATH          Mount point (default: /data)"
    echo "  -g, --group GROUP         Target group (default: postgresql_servers)"
    echo "  -n, --networks CIDR       Allowed networks (default: prompt user)"
    echo "  -t, --test                Test connectivity only"
    echo "  -h, --help                Show this help message"
    echo ""
    echo "Network Security Examples:"
    echo "  10.0.0.0/8                # AWS/Private networks"
    echo "  172.16.0.0/12             # Docker default networks"
    echo "  192.168.0.0/16            # Local networks"
    echo "  10.0.0.0/16               # Specific VPC CIDR"
    echo ""
    echo "Examples:"
    echo "  $0                                    # Use defaults, prompt for networks"
    echo "  $0 -n 10.0.0.0/16                    # Specific VPC CIDR"
    echo "  $0 -v 14 -d /dev/vdb                 # Custom version and device"
    echo "  $0 -m /opt/postgresql                # Custom mount point"
    echo "  $0 -i my-hosts.ini -g vm_servers     # Custom inventory and group"
    echo "  $0 -t                                # Test connectivity only"
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -i|--inventory)
            INVENTORY_FILE="$2"
            shift 2
            ;;
        -p|--playbook)
            PLAYBOOK_FILE="$2"
            shift 2
            ;;
        -v|--version)
            POSTGRESQL_VERSION="$2"
            shift 2
            ;;
        -d|--device)
            STORAGE_DEVICE="$2"
            shift 2
            ;;
        -m|--mount)
            MOUNT_POINT="$2"
            shift 2
            ;;
        -g|--group)
            TARGET_GROUP="$2"
            shift 2
            ;;
        -n|--networks)
            ALLOWED_NETWORKS="$2"
            shift 2
            ;;
        -t|--test)
            TEST_ONLY=true
            shift
            ;;
        -h|--help)
            print_usage
            exit 0
            ;;
        *)
            echo -e "${RED}Error: Unknown option $1${NC}"
            print_usage
            exit 1
            ;;
    esac
done

# Prompt for allowed networks if not provided
if [[ -z "$ALLOWED_NETWORKS" && "${TEST_ONLY:-false}" != "true" ]]; then
    echo -e "${YELLOW}=== Network Security Configuration ===${NC}"
    echo "For security, PostgreSQL should only allow connections from trusted networks."
    echo ""
    echo "Common network ranges:"
    echo "  • 10.0.0.0/8      - AWS/Private networks (recommended)"
    echo "  • 172.16.0.0/12   - Docker default networks"
    echo "  • 192.168.0.0/16  - Local networks"
    echo "  • 10.0.0.0/16     - Specific VPC CIDR"
    echo "  • 0.0.0.0/0       - Any IP (NOT RECOMMENDED for production)"
    echo ""
    read -p "Enter allowed network CIDR (default: 10.0.0.0/8): " user_networks
    ALLOWED_NETWORKS="${user_networks:-10.0.0.0/8}"
    
    if [[ "$ALLOWED_NETWORKS" == "0.0.0.0/0" ]]; then
        echo -e "${RED}WARNING: You've chosen to allow connections from ANY IP address!${NC}"
        echo -e "${RED}This is a security risk. Ensure your firewall/security groups protect the database.${NC}"
        read -p "Are you sure you want to continue? (y/N): " confirm_open
        if [[ $confirm_open != [yY] && $confirm_open != [yY][eE][sS] ]]; then
            echo "Please choose a more restrictive network range."
            exit 1
        fi
    fi
fi

echo -e "${GREEN}=== PostgreSQL Setup via Direct Ansible Commands ===${NC}"
echo "Inventory: $INVENTORY_FILE"
echo "Playbook: $PLAYBOOK_FILE"
echo "Target Group: $TARGET_GROUP"
echo "PostgreSQL Version: $POSTGRESQL_VERSION"
echo "Storage Device: $STORAGE_DEVICE"
echo "Mount Point: $MOUNT_POINT"
if [[ -n "$ALLOWED_NETWORKS" ]]; then
    echo "Allowed Networks: $ALLOWED_NETWORKS"
fi
echo "=============================================="

# Check if required files exist
if [[ ! -f "$INVENTORY_FILE" ]]; then
    echo -e "${RED}Error: Inventory file '$INVENTORY_FILE' not found!${NC}"
    echo "Create it using: ./setup-vm-inventory.sh"
    exit 1
fi

if [[ ! -f "$PLAYBOOK_FILE" ]]; then
    echo -e "${RED}Error: Playbook file '$PLAYBOOK_FILE' not found!${NC}"
    exit 1
fi

# Check if Ansible is installed
if ! command -v ansible &> /dev/null; then
    echo -e "${YELLOW}Ansible not found. Installing...${NC}"
    sudo apt update
    sudo apt install -y ansible
fi

# Test connectivity
echo -e "${GREEN}Testing connectivity...${NC}"
if ansible "$TARGET_GROUP" -i "$INVENTORY_FILE" -m ping; then
    echo -e "${GREEN}✓ Connectivity test passed${NC}"
else
    echo -e "${RED}✗ Connectivity test failed${NC}"
    echo "Please check your inventory file and SSH configuration"
    exit 1
fi

# If test only, exit here
if [[ "${TEST_ONLY:-false}" == "true" ]]; then
    echo -e "${GREEN}Test completed successfully!${NC}"
    exit 0
fi

# Show the actual ansible-playbook command that will be executed
echo -e "${YELLOW}Executing Ansible playbook command:${NC}"
echo "ansible-playbook -i $INVENTORY_FILE $PLAYBOOK_FILE \\"
echo "    --limit $TARGET_GROUP \\"
echo "    --extra-vars \"postgresql_version=$POSTGRESQL_VERSION\" \\"
echo "    --extra-vars \"storage_device=$STORAGE_DEVICE\" \\"
echo "    --extra-vars \"mount_point=$MOUNT_POINT\" \\"
echo "    --extra-vars \"allowed_networks=$ALLOWED_NETWORKS\" \\"
echo "    -v"
echo ""

read -p "Continue with PostgreSQL setup? (y/N): " confirm
if [[ $confirm != [yY] && $confirm != [yY][eE][sS] ]]; then
    echo "Setup cancelled."
    exit 0
fi

# Execute the PostgreSQL setup
echo -e "${GREEN}Running PostgreSQL setup...${NC}"
ansible-playbook -i "$INVENTORY_FILE" "$PLAYBOOK_FILE" \
    --limit "$TARGET_GROUP" \
    --extra-vars "postgresql_version=$POSTGRESQL_VERSION" \
    --extra-vars "storage_device=$STORAGE_DEVICE" \
    --extra-vars "mount_point=$MOUNT_POINT" \
    --extra-vars "allowed_networks=$ALLOWED_NETWORKS" \
    -v

echo -e "${GREEN}PostgreSQL setup completed successfully!${NC}"
echo ""
echo -e "${YELLOW}Manual verification commands:${NC}"
echo "ansible $TARGET_GROUP -i $INVENTORY_FILE -m shell -a 'sudo systemctl status postgresql'"
echo "ansible $TARGET_GROUP -i $INVENTORY_FILE -m shell -a 'sudo -u postgres psql -c \"SELECT version();\"'"
echo "ansible $TARGET_GROUP -i $INVENTORY_FILE -m shell -a 'df -h $MOUNT_POINT'"

# Note: If you see "Failed to set permissions on temporary files" errors,
# this is a known Ansible ACL issue that has been fixed in the playbook.
# The installation will still complete successfully.

