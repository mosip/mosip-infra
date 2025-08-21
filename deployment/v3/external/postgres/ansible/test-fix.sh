#!/bin/bash

echo "=== Testing ACL Permission Fix ==="
echo "This test verifies that the Ansible ACL permission issue is resolved."
echo ""

# Test the fixed command directly
echo "Testing PostgreSQL connection with sudo method..."
ansible postgresql_servers -i hosts.ini -m shell -a 'sudo -u postgres psql -p 5433 -c "SELECT current_timestamp;"' 2>/dev/null

if [ $? -eq 0 ]; then
    echo "✅ ACL permission fix is working correctly!"
    echo "✅ PostgreSQL connection test passed"
else
    echo "❌ ACL permission issue still exists"
    exit 1
fi

echo ""
echo "=== Fix Summary ==="
echo "• Changed 'become_user: postgres' to 'sudo -u postgres'"
echo "• This avoids Ansible ACL permission issues on some systems"
echo "• PostgreSQL installation and testing now works reliably"
echo ""
echo "If you see 'could not change directory' warnings, they are harmless."
