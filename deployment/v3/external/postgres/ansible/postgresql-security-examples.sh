#!/bin/bash

# Example: PostgreSQL Setup with Network Security
# This script demonstrates secure PostgreSQL deployment with VPC CIDR restrictions

echo "=== PostgreSQL Setup Examples ==="
echo ""

echo "1. Interactive setup (prompts for network CIDR):"
echo "   ./ansible-postgresql.sh"
echo ""

echo "2. AWS VPC specific setup:"
echo "   ./ansible-postgresql.sh -n 10.0.0.0/16"
echo ""

echo "3. Local development setup:"
echo "   ./ansible-postgresql.sh -n 192.168.0.0/16"
echo ""

echo "4. Private network setup:"
echo "   ./ansible-postgresql.sh -n 172.16.0.0/12"
echo ""

echo "5. Custom storage with specific VPC:"
echo "   ./ansible-postgresql.sh -d /dev/nvme2n1 -n 10.0.0.0/16 -v 15"
echo ""

echo "=== Direct Ansible Command Examples ==="
echo ""

echo "1. Using specific VPC CIDR:"
echo "   ansible-playbook -i hosts.ini postgresql-setup.yml \\"
echo "       --extra-vars \"allowed_networks=10.0.0.0/16\" \\"
echo "       --extra-vars \"postgresql_version=15\" \\"
echo "       --extra-vars \"storage_device=/dev/nvme2n1\""
echo ""

echo "2. Using private network range:"
echo "   ansible-playbook -i hosts.ini postgresql-setup.yml \\"
echo "       --extra-vars \"allowed_networks=172.16.0.0/12\""
echo ""

echo "=== Security Recommendations ==="
echo ""
echo "• Use specific VPC CIDR instead of broad ranges"
echo "• Never use 0.0.0.0/0 in production"
echo "• Combine with firewall/security group rules"
echo "• Use strong passwords for PostgreSQL users"
echo "• Consider SSL/TLS for database connections"
echo ""
