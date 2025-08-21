#!/bin/bash

# Test script to verify PostgreSQL setup playbook configuration
# This script tests if the playbook will run against the correct hosts

set -e

INVENTORY_FILE="hosts.ini"
PLAYBOOK_FILE="postgresql-setup.yml"
TARGET_GROUP="postgresql_servers"

echo "=== PostgreSQL Playbook Test ==="
echo "Inventory: $INVENTORY_FILE"
echo "Playbook: $PLAYBOOK_FILE"
echo "Target Group: $TARGET_GROUP"
echo "================================="

# Check if files exist
if [[ ! -f "$INVENTORY_FILE" ]]; then
    echo "❌ Error: Inventory file '$INVENTORY_FILE' not found!"
    exit 1
fi

if [[ ! -f "$PLAYBOOK_FILE" ]]; then
    echo "❌ Error: Playbook file '$PLAYBOOK_FILE' not found!"
    exit 1
fi

# Test inventory parsing
echo "📋 Testing inventory parsing..."
if ansible-inventory -i "$INVENTORY_FILE" --list > /dev/null 2>&1; then
    echo "✅ Inventory file is valid"
else
    echo "❌ Inventory file has syntax errors"
    exit 1
fi

# Show available hosts
echo ""
echo "📋 Available hosts in inventory:"
ansible-inventory -i "$INVENTORY_FILE" --list | jq -r '.._meta.hostvars | keys[]' 2>/dev/null || \
ansible-inventory -i "$INVENTORY_FILE" --list | grep -E '"[^"]*":' | sed 's/.*"\([^"]*\)".*/\1/' | grep -v _meta

# Test connectivity
echo ""
echo "🔗 Testing connectivity to target group '$TARGET_GROUP'..."
if ansible "$TARGET_GROUP" -i "$INVENTORY_FILE" -m ping; then
    echo "✅ Connectivity test passed"
else
    echo "❌ Connectivity test failed"
    exit 1
fi

# Test playbook syntax
echo ""
echo "📝 Testing playbook syntax..."
if ansible-playbook -i "$INVENTORY_FILE" "$PLAYBOOK_FILE" --syntax-check; then
    echo "✅ Playbook syntax is valid"
else
    echo "❌ Playbook has syntax errors"
    exit 1
fi

# Show what hosts the playbook will target
echo ""
echo "🎯 Testing playbook host matching..."
echo "Hosts that will be targeted by the playbook:"
ansible-playbook -i "$INVENTORY_FILE" "$PLAYBOOK_FILE" --list-hosts --limit "$TARGET_GROUP"

echo ""
echo "✅ All tests passed! The playbook should run successfully."
echo ""
echo "To run the actual PostgreSQL setup:"
echo "./run-postgresql-remote.sh hosts.ini postgresql_servers 15 /dev/nvme2n1"
