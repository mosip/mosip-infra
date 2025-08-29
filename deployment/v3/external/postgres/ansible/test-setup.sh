#!/bin/bash
# Mock VM Test Setup Script for PostgreSQL Ansible Testing
# This script prepares a test environment on Ubuntu 22.04/24.04

echo "🧪 Setting up Mock VM for PostgreSQL Testing..."

# Create a loop device to simulate /dev/nvme2n1 for testing
create_test_storage() {
    echo "📦 Creating test storage device..."
    
    # Create a 10GB file to simulate a disk
    sudo dd if=/dev/zero of=/opt/test-postgres-disk.img bs=1G count=10 status=progress
    
    # Create loop device
    sudo losetup /dev/loop7 /opt/test-postgres-disk.img
    
    # Create symlink to simulate nvme device
    sudo ln -sf /dev/loop7 /dev/test-nvme2n1
    
    echo "✅ Test storage device created at /dev/test-nvme2n1"
    echo "📝 Update your hosts.ini to use: storage_device=/dev/test-nvme2n1"
}

# Install basic requirements
install_requirements() {
    echo "📦 Installing basic requirements..."
    sudo apt update
    sudo apt install -y python3 python3-pip openssh-server
    
    # Ensure SSH is running
    sudo systemctl enable ssh
    sudo systemctl start ssh
    
    echo "✅ Basic requirements installed"
}

# Create test user and SSH key (if needed)
setup_test_user() {
    echo "👤 Setting up test user..."
    
    # Create test SSH key if it doesn't exist
    if [ ! -f ~/.ssh/id_rsa ]; then
        ssh-keygen -t rsa -b 2048 -f ~/.ssh/id_rsa -N ""
        echo "🔑 SSH key generated"
    fi
    
    # Add public key to authorized_keys for passwordless access
    mkdir -p ~/.ssh
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
    chmod 600 ~/.ssh/authorized_keys
    chmod 700 ~/.ssh
    
    echo "✅ Test user SSH access configured"
}

# Display test configuration
show_test_config() {
    echo ""
    echo "🎯 Mock VM Test Configuration:"
    echo "=================================="
    echo "OS: $(lsb_release -d | cut -f2)"
    echo "IP: $(ip route get 1 | awk '{print $7; exit}')"
    echo "User: $(whoami)"
    echo "SSH Key: ~/.ssh/id_rsa"
    echo "Test Storage: /dev/test-nvme2n1 (10GB)"
    echo ""
    echo "📝 Update your ansible/hosts.ini with:"
    echo "[postgresql_servers]"
    echo "test-vm ansible_host=$(ip route get 1 | awk '{print $7; exit}') ansible_user=$(whoami) ansible_ssh_private_key_file=~/.ssh/id_rsa"
    echo ""
    echo "[postgresql_servers:vars]"
    echo "storage_device=/dev/test-nvme2n1"
    echo "mount_point=/srv/postgres"
    echo "postgresql_version=15"
    echo "postgresql_port=5433"
    echo ""
}

# Main execution
main() {
    echo "🚀 Starting Mock VM Test Setup..."
    install_requirements
    create_test_storage
    setup_test_user
    show_test_config
    echo "✅ Mock VM setup complete! Ready for PostgreSQL testing."
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
