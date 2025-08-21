#!/bin/bash

# PostgreSQL Ansible Playbook Runner
# This script runs the PostgreSQL setup playbook with the generated inventory

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default values
INVENTORY_FILE="hosts.ini"
PLAYBOOK_FILE="postgresql-setup.yml"

print_usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -i, --inventory FILE  Inventory file (default: hosts.ini)"
    echo "  -p, --playbook FILE   Playbook file (default: postgresql-setup.yml)"
    echo "  -v, --verbose         Verbose output"
    echo "  -h, --help            Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0                    # Run with default files"
    echo "  $0 -i my-hosts.ini   # Use custom inventory"
    echo "  $0 -v                 # Verbose output"
}

# Parse command line arguments
VERBOSE=""
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
        -v|--verbose)
            VERBOSE="-v"
            shift
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

echo -e "${GREEN}=== PostgreSQL Playbook Runner ===${NC}"
echo ""

# Check if inventory file exists
if [[ ! -f "$INVENTORY_FILE" ]]; then
    echo -e "${RED}✗ Inventory file '$INVENTORY_FILE' not found!${NC}"
    echo ""
    echo "Please create an inventory file first:"
    echo "  ./setup-vm-inventory.sh"
    echo ""
    exit 1
fi

# Check if playbook file exists
if [[ ! -f "$PLAYBOOK_FILE" ]]; then
    echo -e "${RED}✗ Playbook file '$PLAYBOOK_FILE' not found!${NC}"
    echo "Available playbooks:"
    ls -la *.yml 2>/dev/null || echo "No .yml files found"
    exit 1
fi

# Check if ansible is installed
if ! command -v ansible-playbook &> /dev/null; then
    echo -e "${RED}✗ ansible-playbook command not found!${NC}"
    echo ""
    echo "Please install Ansible:"
    echo "  sudo apt update && sudo apt install ansible"
    echo ""
    exit 1
fi

echo -e "${BLUE}=== Configuration ===${NC}"
echo "Inventory: $INVENTORY_FILE"
echo "Playbook: $PLAYBOOK_FILE"
echo "Verbose: ${VERBOSE:-disabled}"
echo ""

# Show inventory content
echo -e "${BLUE}=== Inventory Content ===${NC}"
echo "----------------------------------------"
cat "$INVENTORY_FILE"
echo "----------------------------------------"
echo ""

# Test connectivity first
echo -e "${BLUE}=== Testing Connectivity ===${NC}"
echo "Testing connection to hosts..."

if ansible postgresql_servers -i "$INVENTORY_FILE" -m ping; then
    echo -e "${GREEN}✓ Connectivity test passed${NC}"
    echo ""
else
    echo -e "${RED}✗ Connectivity test failed${NC}"
    echo ""
    echo -e "${YELLOW}Would you like to continue anyway? (y/N): ${NC}"
    read -r continue_anyway
    if [[ $continue_anyway != [yY] && $continue_anyway != [yY][eE][sS] ]]; then
        echo "Playbook execution cancelled."
        exit 1
    fi
    echo ""
fi

# Run the playbook
echo -e "${GREEN}=== Running PostgreSQL Playbook ===${NC}"
echo "Command: ansible-playbook -i $INVENTORY_FILE $VERBOSE $PLAYBOOK_FILE"
echo ""

if ansible-playbook -i "$INVENTORY_FILE" $VERBOSE "$PLAYBOOK_FILE"; then
    echo ""
    echo -e "${GREEN}✅ PostgreSQL Playbook completed successfully!${NC}"
    echo ""
    echo "Next steps:"
    echo "• Check PostgreSQL service status"
    echo "• Verify database connectivity"
    echo "• Review configuration files"
    echo ""
else
    echo ""
    echo -e "${RED}❌ PostgreSQL Playbook failed!${NC}"
    echo ""
    echo "Troubleshooting tips:"
    echo "• Check the error messages above"
    echo "• Verify SSH connectivity to the target host"
    echo "• Ensure the user has sudo privileges"
    echo "• Check if the storage device exists"
    echo "• Review the inventory configuration"
    echo ""
    exit 1
fi
