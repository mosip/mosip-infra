# PostgreSQL Ansible Testing Guide
## Mock VM Testing on Ubuntu 22.04/24.04

This guide helps you test the PostgreSQL Ansible setup on a mock VM running Ubuntu 22.04 or 24.04.

## 🎯 Test Overview

**What We're Testing:**
- ✅ Multi-OS support (Ubuntu 22.04/24.04)
- ✅ Secure password generation (cryptographic)
- ✅ Encryption key security
- ✅ PostgreSQL installation and configuration
- ✅ Kubernetes integration files generation
- ✅ Complete end-to-end deployment

## 🔧 Quick Test Setup

### Step 1: Prepare Mock VM
```bash
# On your Ubuntu 22.04/24.04 VM:
cd ansible/
./test-setup.sh
```

This script will:
- Create a simulated storage device (`/dev/test-nvme2n1`)
- Configure SSH access
- Install required packages
- Generate test configuration

### Step 2: Configure Test Inventory
Edit `hosts-test.ini` with your VM details:
```ini
[postgresql_servers]
mock-vm ansible_host=YOUR_VM_IP ansible_user=YOUR_USERNAME ansible_ssh_private_key_file=~/.ssh/id_rsa

[postgresql_servers:vars]
storage_device=/dev/test-nvme2n1  # Created by test-setup.sh
postgresql_version=15
postgresql_port=5433
```

### Step 3: Run Complete Test
```bash
./run-test.sh
```

## 🧪 Manual Testing Steps

If you prefer manual testing:

### 1. Test Connectivity
```bash
ansible postgresql_servers -i hosts-test.ini -m ping
```

### 2. Run PostgreSQL Deployment
```bash
ansible-playbook -i hosts-test.ini postgresql-setup.yml -v
```

### 3. Verify Installation
```bash
# Check PostgreSQL service
ansible postgresql_servers -i hosts-test.ini -m shell -a "sudo systemctl status postgresql"

# Check port
ansible postgresql_servers -i hosts-test.ini -m shell -a "netstat -tlnp | grep :5433"

# Test database connection
ansible postgresql_servers -i hosts-test.ini -m shell -a "sudo -u postgres psql -p 5433 -c 'SELECT version();'"
```

## ✅ Expected Test Results

### Security Validations:
- ✅ **Password Generation**: Uses `secrets` module (cryptographically secure)
- ✅ **Encryption Key**: Random 32-byte key generated
- ✅ **File Permissions**: All sensitive files have 600 permissions
- ✅ **No Log Exposure**: Sensitive operations not logged
- ✅ **Memory Cleanup**: Variables cleared after use

### Functionality Validations:
- ✅ **PostgreSQL 15**: Successfully installed and running
- ✅ **Port 5433**: PostgreSQL listening on configured port
- ✅ **Custom Storage**: Data stored in `/srv/postgres`
- ✅ **Authentication**: Password authentication working
- ✅ **Kubernetes Files**: Generated in `/tmp/postgresql-secrets/`

### Generated Files:
```
/tmp/postgresql-secrets/
├── postgres-postgresql.yml      # Kubernetes Secret
├── postgres-setup-config.yml    # Kubernetes ConfigMap  
└── DEPLOYMENT_INSTRUCTIONS.md   # How to deploy
```

### On VM:
```
/var/lib/postgresql/
├── .postgres_encryption_key     # 32-byte random key (600 perms)
├── .postgres_password_enc       # Encrypted password (600 perms)
└── .postgres_password_hash      # Password hash (600 perms)

/srv/postgres/postgresql/15/main/  # PostgreSQL data directory
```

## 🔍 Test Scenarios

### Scenario 1: Fresh Installation
- First run creates all files and configurations
- Password generated securely and encrypted
- PostgreSQL installed and configured

### Scenario 2: Re-run (Idempotency)
- Second run reuses existing password
- No changes made to working configuration
- Verifies idempotent behavior

### Scenario 3: Version Testing
- Test different PostgreSQL versions (13, 14, 15, 16)
- Update `postgresql_version` in hosts-test.ini
- Verify version-specific paths and packages

### Scenario 4: Security Validation
- Check no passwords in logs: `grep -r password test-logs/`
- Verify file permissions: `ls -la /var/lib/postgresql/.postgres_*`
- Test encryption key security

## 🚨 Troubleshooting

### Common Issues:

**SSH Connection Failed:**
```bash
# Check SSH key permissions
chmod 600 ~/.ssh/id_rsa
# Update hosts-test.ini with correct IP and user
```

**Storage Device Not Found:**
```bash
# Re-run test setup
./test-setup.sh
# Verify device exists
ls -la /dev/test-nvme2n1
```

**Permission Denied:**
```bash
# Ensure sudo access for test user
sudo usermod -aG sudo $USER
# Re-login to apply group changes
```

**PostgreSQL Installation Failed:**
```bash
# Check Ubuntu version compatibility
lsb_release -a
# Check internet connectivity
ping apt.postgresql.org
```

## 📊 Test Metrics

**Expected Performance:**
- **First Run**: 5-10 minutes (includes package installation)
- **Subsequent Runs**: 2-3 minutes (validation only)
- **Resource Usage**: ~2GB RAM, ~5GB disk space

**Security Benchmarks:**
- **Password Entropy**: 128+ bits (16 chars, mixed complexity)
- **Encryption**: AES-256-CBC with PBKDF2
- **Key Security**: 256-bit random encryption keys
- **File Security**: 600 permissions, postgres ownership

## 🎉 Success Criteria

Your test is successful when:
- ✅ PostgreSQL service is running
- ✅ Port 5433 is listening
- ✅ Database connection works
- ✅ Kubernetes files are generated
- ✅ No passwords visible in logs
- ✅ All files have correct permissions
- ✅ Password is encrypted and stored securely

## 📝 Test Reporting

After testing, you can report:
1. **OS Compatibility**: Ubuntu 22.04/24.04 ✅
2. **Security Level**: Enterprise-grade ✅
3. **Performance**: Meeting expectations ✅
4. **Functionality**: All features working ✅
5. **Reliability**: Idempotent and stable ✅

---

**Ready to test? Run `./test-setup.sh` followed by `./run-test.sh`!** 🚀
