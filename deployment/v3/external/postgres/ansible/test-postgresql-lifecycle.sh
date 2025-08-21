#!/bin/bash

# PostgreSQL Lifecycle Management
# Complete setup, verification, and cleanup workflow for testing reproducibility

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

INVENTORY_FILE="${1:-hosts.ini}"
TARGET_GROUP="${2:-postgresql_servers}"

print_usage() {
    echo "PostgreSQL Lifecycle Management"
    echo "Usage: $0 [inventory_file] [target_group]"
    echo ""
    echo "This script demonstrates complete PostgreSQL lifecycle:"
    echo "1. Status check"
    echo "2. Fresh installation"
    echo "3. Verification"
    echo "4. Cleanup"
    echo "5. Final verification"
    echo ""
    echo "Examples:"
    echo "  $0                           # Use defaults (hosts.ini, postgresql_servers)"
    echo "  $0 my-hosts.ini vm_servers   # Custom inventory and group"
}

if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    print_usage
    exit 0
fi

echo -e "${BLUE}╔══════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║                PostgreSQL Lifecycle Test                        ║${NC}"
echo -e "${BLUE}║            Complete Setup and Cleanup Workflow                  ║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo "Inventory File: $INVENTORY_FILE"
echo "Target Group: $TARGET_GROUP"
echo ""

# Check if files exist
if [[ ! -f "$INVENTORY_FILE" ]]; then
    echo -e "${RED}Error: Inventory file '$INVENTORY_FILE' not found!${NC}"
    exit 1
fi

echo -e "${YELLOW}Press ENTER to start the lifecycle test, or Ctrl+C to abort...${NC}"
read

echo ""
echo -e "${BLUE}[1/5] Initial Status Check${NC}"
echo "=========================================="
./check-postgresql-status.sh "$INVENTORY_FILE" "$TARGET_GROUP"

echo ""
echo -e "${YELLOW}Do you want to proceed with PostgreSQL installation? (y/N):${NC}"
read -r install_confirm
if [[ $install_confirm != [yY] && $install_confirm != [yY][eE][sS] ]]; then
    echo "Installation skipped."
    exit 0
fi

echo ""
echo -e "${BLUE}[2/5] PostgreSQL Installation${NC}"
echo "=========================================="
./ansible-postgresql.sh -i "$INVENTORY_FILE" -g "$TARGET_GROUP" -n "10.0.0.0/8" -y

echo ""
echo -e "${BLUE}[3/5] Installation Verification${NC}"
echo "=========================================="
./verify-postgresql.sh "$INVENTORY_FILE" "$TARGET_GROUP"

echo ""
echo -e "${YELLOW}Installation completed. Do you want to test cleanup? (y/N):${NC}"
read -r cleanup_confirm
if [[ $cleanup_confirm != [yY] && $cleanup_confirm != [yY][eE][sS] ]]; then
    echo "Cleanup test skipped. PostgreSQL remains installed."
    exit 0
fi

echo ""
echo -e "${BLUE}[4/5] PostgreSQL Cleanup${NC}"
echo "=========================================="
./cleanup-postgresql.sh -i "$INVENTORY_FILE" -g "$TARGET_GROUP" --safe -y

echo ""
echo -e "${BLUE}[5/5] Final Status Check${NC}"
echo "=========================================="
./check-postgresql-status.sh "$INVENTORY_FILE" "$TARGET_GROUP"

echo ""
echo -e "${GREEN}╔══════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║                    Lifecycle Test Complete                      ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${GREEN}✓ Status Check: Completed${NC}"
echo -e "${GREEN}✓ Installation: Completed${NC}"
echo -e "${GREEN}✓ Verification: Completed${NC}"
echo -e "${GREEN}✓ Cleanup: Completed${NC}"
echo -e "${GREEN}✓ Final Check: Completed${NC}"
echo ""
echo -e "${BLUE}The environment has been tested for complete reproducibility!${NC}"
echo ""
echo -e "${YELLOW}Available commands for future use:${NC}"
echo "• Install: ./ansible-postgresql.sh"
echo "• Verify:  ./verify-postgresql.sh"
echo "• Status:  ./check-postgresql-status.sh"
echo "• Cleanup: ./cleanup-postgresql.sh"
