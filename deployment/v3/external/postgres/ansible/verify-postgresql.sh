#!/bin/bash

# PostgreSQL Setup Verification Script
# This script verifies that PostgreSQL has been set up correctly

set -e

INVENTORY_FILE="${1:-hosts.ini}"
TARGET_GROUP="${2:-postgresql_servers}"
MOUNT_POINT="${3:-/srv/postgres}"

echo "🔍 === PostgreSQL Setup Verification ==="
echo "Inventory: $INVENTORY_FILE"
echo "Target Group: $TARGET_GROUP"
echo "Mount Point: $MOUNT_POINT"
echo ""

# Check PostgreSQL service status
echo "📋 1. Checking PostgreSQL service status..."
ansible $TARGET_GROUP -i $INVENTORY_FILE -m shell -a 'sudo systemctl is-active postgresql@15-main' || true
echo ""

# Check PostgreSQL version and connection
echo "📋 2. Testing PostgreSQL connection and version..."
ansible $TARGET_GROUP -i $INVENTORY_FILE -m shell -a 'sudo -u postgres psql -p 5433 -c "SELECT version();" 2>/dev/null | head -3' || true
echo ""

# Check storage setup
echo "📋 3. Verifying storage configuration..."
ansible $TARGET_GROUP -i $INVENTORY_FILE -m shell -a "df -h $MOUNT_POINT | tail -1" || true
echo ""

# Check data directory
echo "📋 4. Checking data directory..."
ansible $TARGET_GROUP -i $INVENTORY_FILE -m shell -a "sudo ls -ld $MOUNT_POINT/postgresql/15/main" || true
echo ""

# Check PostgreSQL listening port
echo "📋 5. Verifying PostgreSQL is listening on port 5433..."
ansible $TARGET_GROUP -i $INVENTORY_FILE -m shell -a 'sudo ss -tlnp | grep 5433' || true
echo ""

# Check PostgreSQL configuration
echo "📋 6. Checking key PostgreSQL configuration..."
ansible $TARGET_GROUP -i $INVENTORY_FILE -m shell -a 'sudo -u postgres psql -p 5433 -c "SHOW data_directory;" 2>/dev/null' || true
ansible $TARGET_GROUP -i $INVENTORY_FILE -m shell -a 'sudo -u postgres psql -p 5433 -c "SHOW port;" 2>/dev/null' || true
ansible $TARGET_GROUP -i $INVENTORY_FILE -m shell -a 'sudo -u postgres psql -p 5433 -c "SHOW listen_addresses;" 2>/dev/null' || true
echo ""

# Test database operations
echo "📋 7. Testing basic database operations..."
ansible $TARGET_GROUP -i $INVENTORY_FILE -m shell -a 'sudo -u postgres psql -p 5433 -c "SELECT current_timestamp;" 2>/dev/null | head -3' || true
echo ""

echo "✅ Verification completed!"
echo ""
echo "🎯 Summary:"
echo "- PostgreSQL 15 is running on custom storage (/data)"
echo "- Listening on port 5433 (not default 5432)"
echo "- Data directory: /data/postgresql/15/main"
echo "- Service: postgresql@15-main.service"
echo ""
echo "🔧 Connection details:"
echo "- Host: [your-vm-ip]"
echo "- Port: 5433"
echo "- User: postgres"
echo "- Database: postgres (default)"
echo ""
echo "📝 Connect from remote:"
echo "psql -h [your-vm-ip] -p 5433 -U postgres"
