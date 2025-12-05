#!/bin/bash

# PostgreSQL Environment Status Check
# This script checks the current state of PostgreSQL installation before cleanup

set -e

INVENTORY_FILE="${1:-hosts.ini}"
TARGET_GROUP="${2:-postgresql_servers}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== PostgreSQL Environment Status Check ===${NC}"
echo "Inventory: $INVENTORY_FILE"
echo "Target Group: $TARGET_GROUP"
echo "=============================================="

# Check connectivity
echo -e "${GREEN}Testing connectivity...${NC}"
if ! ansible "$TARGET_GROUP" -i "$INVENTORY_FILE" -m ping > /dev/null 2>&1; then
    echo -e "${RED}✗ Cannot connect to target hosts${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Connectivity OK${NC}"

echo ""
echo -e "${YELLOW}=== PostgreSQL Installation Status ===${NC}"

# Check PostgreSQL packages
echo "PostgreSQL Packages:"
ansible "$TARGET_GROUP" -i "$INVENTORY_FILE" -m shell -a 'dpkg -l | grep postgresql' 2>/dev/null || echo "No PostgreSQL packages found"

echo ""
echo "PostgreSQL Processes:"
ansible "$TARGET_GROUP" -i "$INVENTORY_FILE" -m shell -a 'ps aux | grep postgres | grep -v grep' 2>/dev/null || echo "No PostgreSQL processes running"

echo ""
echo "PostgreSQL Service Status:"
ansible "$TARGET_GROUP" -i "$INVENTORY_FILE" -m shell -a 'systemctl is-active postgresql' 2>/dev/null || echo "PostgreSQL service not active"

echo ""
echo -e "${YELLOW}=== Storage and Mount Points ===${NC}"

# Check common mount points
for mount_point in "/srv/postgres" "/data" "/mnt/postgresql" "/opt/postgresql"; do
    echo "Mount point $mount_point:"
    ansible "$TARGET_GROUP" -i "$INVENTORY_FILE" -m shell -a "mount | grep '$mount_point'" 2>/dev/null || echo "Not mounted"
done

echo ""
echo "Current mount points:"
ansible "$TARGET_GROUP" -i "$INVENTORY_FILE" -m shell -a 'mount | grep -E "(srv|data|postgresql)" || echo "No relevant mount points"' 2>/dev/null

echo ""
echo -e "${YELLOW}=== Storage Devices ===${NC}"

# Check common storage devices
for device in "/dev/nvme2n1" "/dev/sdb" "/dev/vdb" "/dev/xvdb"; do
    echo "Device $device:"
    ansible "$TARGET_GROUP" -i "$INVENTORY_FILE" -m shell -a "lsblk '$device' 2>/dev/null || echo 'Device not found'" 2>/dev/null
done

echo ""
echo -e "${YELLOW}=== Configuration Files ===${NC}"

# Check configuration directories
for config_dir in "/etc/postgresql" "/var/lib/postgresql"; do
    echo "Directory $config_dir:"
    ansible "$TARGET_GROUP" -i "$INVENTORY_FILE" -m shell -a "ls -la '$config_dir' 2>/dev/null || echo 'Directory not found'" 2>/dev/null
done

echo ""
echo -e "${YELLOW}=== Data Directories ===${NC}"

# Check data directories
for data_dir in "/srv/postgres/postgresql" "/data/postgresql" "/var/lib/postgresql" "/mnt/postgresql"; do
    echo "Data directory $data_dir:"
    ansible "$TARGET_GROUP" -i "$INVENTORY_FILE" -m shell -a "ls -la '$data_dir' 2>/dev/null || echo 'Directory not found'" 2>/dev/null
done

echo ""
echo -e "${YELLOW}=== Network Configuration ===${NC}"

echo "PostgreSQL listening ports:"
ansible "$TARGET_GROUP" -i "$INVENTORY_FILE" -m shell -a 'netstat -tlnp | grep postgres || echo "No PostgreSQL ports listening"' 2>/dev/null

echo ""
echo -e "${YELLOW}=== Users and Groups ===${NC}"

echo "PostgreSQL user:"
ansible "$TARGET_GROUP" -i "$INVENTORY_FILE" -m shell -a 'id postgres 2>/dev/null || echo "User postgres not found"' 2>/dev/null

echo ""
echo -e "${GREEN}=== Status Summary ===${NC}"

# Create a summary
ansible "$TARGET_GROUP" -i "$INVENTORY_FILE" -m shell -a '
echo "=== PostgreSQL Environment Summary ==="
echo "Hostname: $(hostname)"
echo "Date: $(date)"
echo ""
echo "PostgreSQL packages: $(dpkg -l | grep postgresql | wc -l) found"
echo "PostgreSQL processes: $(ps aux | grep postgres | grep -v grep | wc -l) running"
echo "PostgreSQL config dirs: $(find /etc -name "*postgresql*" -type d 2>/dev/null | wc -l) found"
echo "PostgreSQL data dirs: $(find /var/lib -name "*postgresql*" -type d 2>/dev/null | wc -l) found"
echo "Relevant mount points: $(mount | grep -E "(srv|data|postgresql)" | wc -l) found"
echo ""
if systemctl is-active postgresql >/dev/null 2>&1; then
    echo "PostgreSQL service: ACTIVE"
else
    echo "PostgreSQL service: INACTIVE"
fi
' 2>/dev/null

echo ""
echo -e "${BLUE}=== Cleanup Options ===${NC}"
echo "Based on the current state, you can use:"
echo ""
echo "• Quick cleanup (no backups):    ./cleanup-postgresql.sh --quick"
echo "• Safe cleanup (with backups):   ./cleanup-postgresql.sh --safe"
echo "• Complete cleanup (wipe all):   ./cleanup-postgresql.sh --complete"
echo ""
echo "For custom cleanup options, see: ./cleanup-postgresql.sh --help"
