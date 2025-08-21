# Complete PostgreSQL Automation Guide

## 🎯 What This Does
This tool automatically installs and sets up PostgreSQL database on your server with intelligent inventory setup and complete lifecycle management. It's like having a PostgreSQL expert that does all the hard work for you!

## 🚀 Quick Start (The Easy Way)
```bash
# 1. Go to the directory
cd /deployment/v3/external/postgres/ansible

# 2. Set up your server inventory (NEW!)
./setup-vm-inventory.sh

# 3. Run PostgreSQL installation
./run-postgresql-playbook.sh
```

That's it! The scripts will guide you through everything automatically with smart defaults and validation.

---

## 🆕 Recent Major Updates (August 2025)

### ✅ **Enhanced Inventory Setup**
- **NEW**: `setup-vm-inventory.sh` - Interactive script to create inventory files
- **Prompts for all configurations**: VM details, PostgreSQL settings, network configuration
- **Smart defaults**: Uses `/dev/nvme2n1` to avoid conflicts with existing mounts
- **Connectivity testing**: Verifies SSH access before proceeding
- **User-friendly**: Colored output, clear prompts, configuration summary

### ✅ **Improved Playbook Runner**
- **NEW**: `run-postgresql-playbook.sh` - Enhanced playbook execution
- **Pre-flight checks**: Connectivity and configuration validation
- **Better error handling**: Clear troubleshooting tips
- **Verbose options**: Debugging support when needed

### ✅ **Fixed Critical Issues**
- **Playbook targeting**: Fixed `hosts: all` issue that caused localhost errors
- **Device conflicts**: Default storage changed from `/dev/nvme1n1` to `/dev/nvme2n1`
- **Network CIDR**: Improved validation for proper network format
- **ACL permissions**: Resolved Ansible become_user issues

### ✅ **Complete Cleanup System**
- **Three cleanup modes**: Quick, Safe, Complete
- **Safety backups**: Automatic backup creation before cleanup
- **Device wiping**: Optional complete device sanitization
- **Verification**: Post-cleanup validation and status checks

---

## 📋 What You Need Before Starting

### 1. A Server (VM or Computer)
- Linux server (Ubuntu 20.04+ recommended)
- At least 4GB RAM (8GB+ recommended)
- Internet connection for package downloads

### 2. Storage Configuration
- **Primary device**: `/dev/nvme2n1` (or similar) for PostgreSQL data
- **Size**: At least 100GB recommended (300GB+ for production)
- **Note**: Device will be formatted automatically (existing data will be lost!)

### 3. Network Access
- SSH key-based access to your server
- Know your server's IP address
- Firewall allowing SSH (port 22) and PostgreSQL port (default 5433)

---

## 🛠️ Step-by-Step Setup

### Step 1: Interactive Inventory Setup (RECOMMENDED)
Run the enhanced inventory setup script:
```bash
./setup-vm-inventory.sh
```

The script will prompt you for:
- **VM Connection**: IP address, SSH user, SSH key path, SSH port
- **PostgreSQL Version**: Default 15 (latest stable)
- **Storage Device**: Default `/dev/nvme2n1` (avoids conflicts)
- **Mount Point**: Default `/srv/postgres`
- **Network CIDR**: Your network range (e.g., `10.0.0.0/16`)
- **PostgreSQL Port**: Default 5432 (or custom like 5433 for security)

**Example Session:**
```
Enter your VM IP address: 10.0.2.242
Enter SSH username (default: ubuntu): 
Enter SSH private key file path: ~/Downloads/my-key.pem
Enter PostgreSQL version (default: 15): 
Enter storage device path (default: /dev/nvme2n1): 
Enter mount point (default: /srv/postgres): 
Enter network CIDR (default: 10.1.0.0/16): 10.0.0.0/16
Enter PostgreSQL port (default: 5432): 5433
```

### Step 2: Run PostgreSQL Installation
```bash
./run-postgresql-playbook.sh
```

The script will:
- ✅ Validate your inventory configuration
- ✅ Test connectivity to your server
- ✅ Show you what will be installed
- ✅ Execute the PostgreSQL setup playbook
- ✅ Verify successful installation

### Step 3: Verify Installation
```bash
# Check service status
./check-postgresql-status.sh

# Or test manually
ansible vm_server -i hosts.ini -m shell -a "sudo systemctl status postgresql@15-main"
ansible vm_server -i hosts.ini -m shell -a "sudo -u postgres psql -p 5433 -c 'SELECT version();'"
```

---

## 🐛 Troubleshooting

### Common Issues and Solutions

#### 1. SSH Connection Fails
```bash
# Problem: "Connection refused" or "Permission denied"
# Solutions:
- Check VM is running and IP is correct
- Verify SSH key has correct permissions: chmod 600 your-key.pem
- Test manual connection: ssh -i your-key.pem ubuntu@your-ip
```

#### 2. Storage Device Not Found
```bash
# Problem: "Device /dev/nvme2n1 not found"
# Solutions:
- Check available devices: lsblk
- Use correct device name in inventory setup
- Ensure device is not already mounted
```

#### 3. Network CIDR Format Errors
```bash
# Problem: "Invalid IP mask" in PostgreSQL logs
# Solution: Use correct CIDR format
# ❌ Wrong: 10.0.0.16
# ✅ Correct: 10.0.0.0/16
```

#### 4. Localhost Sudo Errors
```bash
# Problem: "sudo: a password is required" on localhost
# Solution: This is fixed in latest version
# Ensure playbooks use "hosts: postgresql_servers" not "hosts: all"
```

---

## 🗑️ Cleanup and Maintenance

### Cleanup Options
```bash
# Quick cleanup (removes PostgreSQL, preserves data)
./cleanup-postgresql.sh --quick

# Safe cleanup (with backups, preserves device)
./cleanup-postgresql.sh --safe

# Complete cleanup (with backups, wipes device)
./cleanup-postgresql.sh --complete
```

### Safety Features
- **Automatic backups**: Configuration and data backed up before cleanup
- **Confirmation prompts**: Multiple confirmations for destructive operations
- **Device verification**: Ensures correct device is being operated on
- **Post-cleanup validation**: Verifies complete removal

---

## 🎯 Production Deployment Tips

### 1. Server Sizing
```bash
# Development
- 2 CPU, 4GB RAM, 100GB storage

# Staging  
- 4 CPU, 8GB RAM, 300GB storage

# Production
- 8+ CPU, 16GB+ RAM, 1TB+ storage
```

### 2. Security Considerations
```bash
# Use non-standard ports
postgresql_port=5433

# Restrict network access
network_cidr=10.0.0.0/16  # Only your private network

# Use dedicated storage
storage_device=/dev/nvme2n1  # Separate from OS disk
```

---

## 🎉 Success! 

Your PostgreSQL automation suite is now complete with:
- ✅ Interactive setup and configuration
- ✅ Intelligent default handling  
- ✅ Comprehensive error handling
- ✅ Complete lifecycle management
- ✅ Production-ready deployment
- ✅ Easy cleanup and maintenance

**Need help?** The scripts provide clear error messages and troubleshooting tips. Check the logs and follow the suggestions!

---

*Last updated: August 21, 2025 - Complete with all recent enhancements and fixes*
