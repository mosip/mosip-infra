#!/bin/bash

# PostgreSQL Cleanup Script - Complete Environment Restoration
# This script provides various cleanup options for PostgreSQL installations

set -e

# Default values
INVENTORY_FILE="hosts.ini"
CLEANUP_PLAYBOOK="postgresql-cleanup.yml"
TARGET_GROUP="postgresql_servers"
POSTGRESQL_VERSION="15"
STORAGE_DEVICE="/dev/nvme2n1"
MOUNT_POINT="/srv/postgres"
CREATE_BACKUP=false
WIPE_DEVICE=false
AUTO_CONFIRM=false

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
    echo "  -i, --inventory FILE      Inventory file (default: hosts.ini)"
    echo "  -c, --cleanup FILE        Cleanup playbook (default: postgresql-cleanup.yml)"
    echo "  -v, --version VERSION     PostgreSQL version (default: 15)"
    echo "  -d, --device DEVICE       Storage device (default: /dev/nvme2n1)"
    echo "  -m, --mount PATH          Mount point (default: /srv/postgres)"
    echo "  -g, --group GROUP         Target group (default: postgresql_servers)"
    echo "  -b, --backup              Create safety backup before cleanup"
    echo "  -w, --wipe-device         Wipe storage device completely (DANGEROUS!)"
    echo "  -y, --yes                 Auto-confirm (skip prompts)"
    echo "  --quick                   Quick cleanup (no backups, no device wipe)"
    echo "  --safe                    Safe cleanup (with backups, no device wipe)"
    echo "  --complete                Complete cleanup (with backups and device wipe)"
    echo "  -t, --test                Test connectivity only"
    echo "  -h, --help                Show this help message"
    echo ""
    echo "Cleanup Modes:"
    echo "  Quick:    Fast cleanup, no backups, preserves device data"
    echo "  Safe:     Creates backups, removes PostgreSQL, preserves device"
    echo "  Complete: Creates backups, removes PostgreSQL, wipes device clean"
    echo ""
    echo "Examples:"
    echo "  $0 --safe                             # Safe cleanup with backups"
    echo "  $0 --quick -y                        # Quick cleanup, auto-confirm"
    echo "  $0 --complete                        # Complete cleanup with device wipe"
    echo "  $0 -b -d /dev/vdb -m /opt/postgresql    # Custom device and mount with backup"
    echo "  $0 -t                                # Test connectivity only"
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -i|--inventory)
            INVENTORY_FILE="$2"
            shift 2
            ;;
        -c|--cleanup)
            CLEANUP_PLAYBOOK="$2"
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
        -b|--backup)
            CREATE_BACKUP=true
            shift
            ;;
        -w|--wipe-device)
            WIPE_DEVICE=true
            shift
            ;;
        -y|--yes)
            AUTO_CONFIRM=true
            shift
            ;;
        --quick)
            CREATE_BACKUP=false
            WIPE_DEVICE=false
            shift
            ;;
        --safe)
            CREATE_BACKUP=true
            WIPE_DEVICE=false
            shift
            ;;
        --complete)
            CREATE_BACKUP=true
            WIPE_DEVICE=true
            shift
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

echo -e "${RED}=== PostgreSQL Cleanup Script ===${NC}"
echo -e "${YELLOW}WARNING: This will PERMANENTLY DELETE PostgreSQL and its data!${NC}"
echo ""
echo "Configuration:"
echo "  Inventory: $INVENTORY_FILE"
echo "  Playbook: $CLEANUP_PLAYBOOK"
echo "  Target Group: $TARGET_GROUP"
echo "  PostgreSQL Version: $POSTGRESQL_VERSION"
echo "  Storage Device: $STORAGE_DEVICE"
echo "  Mount Point: $MOUNT_POINT"
echo "  Create Backup: $CREATE_BACKUP"
echo "  Wipe Device: $WIPE_DEVICE"
echo "  Auto Confirm: $AUTO_CONFIRM"
echo "=============================================="

# Check if required files exist
if [[ ! -f "$INVENTORY_FILE" ]]; then
    echo -e "${RED}Error: Inventory file '$INVENTORY_FILE' not found!${NC}"
    exit 1
fi

if [[ ! -f "$CLEANUP_PLAYBOOK" ]]; then
    echo -e "${RED}Error: Cleanup playbook '$CLEANUP_PLAYBOOK' not found!${NC}"
    exit 1
fi

# Check if Ansible is installed
if ! command -v ansible &> /dev/null; then
    echo -e "${RED}Error: Ansible not found. Please install Ansible first.${NC}"
    exit 1
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

# Show what will be cleaned up
echo -e "${YELLOW}=== Cleanup Preview ===${NC}"
echo "The following will be PERMANENTLY DELETED:"
echo "• PostgreSQL $POSTGRESQL_VERSION service and packages"
echo "• All PostgreSQL configuration files"
echo "• All PostgreSQL data directories"
echo "• Mount point $MOUNT_POINT"
if [[ "$WIPE_DEVICE" == "true" ]]; then
    echo -e "${RED}• ALL DATA on storage device $STORAGE_DEVICE (COMPLETE WIPE!)${NC}"
fi
echo ""

if [[ "$CREATE_BACKUP" == "true" ]]; then
    echo -e "${GREEN}Safety measures enabled:${NC}"
    echo "• Configuration files will be backed up"
    echo "• Data will be backed up before deletion"
fi
echo ""

# Final confirmation
if [[ "$AUTO_CONFIRM" != "true" ]]; then
    if [[ "$WIPE_DEVICE" == "true" ]]; then
        echo -e "${RED}⚠️  DANGER: Device wipe is enabled! This will destroy ALL data on $STORAGE_DEVICE${NC}"
        echo -e "${RED}⚠️  This action is IRREVERSIBLE!${NC}"
        read -p "Type 'DELETE EVERYTHING' to confirm device wipe: " device_confirm
        if [[ "$device_confirm" != "DELETE EVERYTHING" ]]; then
            echo "Device wipe cancelled."
            exit 1
        fi
    fi
    
    read -p "Are you sure you want to proceed with PostgreSQL cleanup? (y/N): " confirm
    if [[ $confirm != [yY] && $confirm != [yY][eE][sS] ]]; then
        echo "Cleanup cancelled."
        exit 0
    fi
fi

# Show the actual ansible-playbook command
echo -e "${YELLOW}Executing cleanup command:${NC}"
echo "ansible-playbook -i $INVENTORY_FILE $CLEANUP_PLAYBOOK \\"
echo "    --limit $TARGET_GROUP \\"
echo "    --extra-vars \"postgresql_version=$POSTGRESQL_VERSION\" \\"
echo "    --extra-vars \"storage_device=$STORAGE_DEVICE\" \\"
echo "    --extra-vars \"mount_point=$MOUNT_POINT\" \\"
echo "    --extra-vars \"create_backup=$CREATE_BACKUP\" \\"
echo "    --extra-vars \"wipe_device=$WIPE_DEVICE\" \\"
echo "    --extra-vars \"auto_confirm=$AUTO_CONFIRM\" \\"
echo "    -v"
echo ""

# Execute the cleanup
echo -e "${RED}Starting PostgreSQL cleanup...${NC}"
ansible-playbook -i "$INVENTORY_FILE" "$CLEANUP_PLAYBOOK" \
    --limit "$TARGET_GROUP" \
    --extra-vars "postgresql_version=$POSTGRESQL_VERSION" \
    --extra-vars "storage_device=$STORAGE_DEVICE" \
    --extra-vars "mount_point=$MOUNT_POINT" \
    --extra-vars "create_backup=$CREATE_BACKUP" \
    --extra-vars "wipe_device=$WIPE_DEVICE" \
    --extra-vars "auto_confirm=$AUTO_CONFIRM" \
    -v

echo -e "${GREEN}PostgreSQL cleanup completed successfully!${NC}"
echo ""
echo -e "${BLUE}=== Post-Cleanup Verification ===${NC}"
echo "You can verify the cleanup with these commands:"
echo "ansible $TARGET_GROUP -i $INVENTORY_FILE -m shell -a 'dpkg -l | grep postgresql'"
echo "ansible $TARGET_GROUP -i $INVENTORY_FILE -m shell -a 'ps aux | grep postgres'"
echo "ansible $TARGET_GROUP -i $INVENTORY_FILE -m shell -a 'mount | grep $MOUNT_POINT'"
echo "ansible $TARGET_GROUP -i $INVENTORY_FILE -m shell -a 'lsblk $STORAGE_DEVICE'"
