# Complete PostgreSQL Secure Setup Guide - MOSIP Infrastructure

## 🎯 What This Does

This tool automatically installs and configures PostgreSQL with enterprise-grade security features, optimized for private subnet deployment in MOSIP infrastructure. It handles secure password generation, Kubernetes integration, and performance optimization automatically.

## Quick Start (The Easy Way)

```bash
# 1. Go to the PostgreSQL ansible directory
cd /path/to/mosip-infra/deployment/v3/external/postgres/ansible

# 2. Interactive inventory setup with smart defaults
./setup-vm-inventory.sh

# 3. Deploy PostgreSQL with secure setup
./run-postgresql-playbook.sh

# 4. Verify installation
./check-postgresql-status.sh
```

That's it! The scripts handle secure password generation, configuration, and Kubernetes integration automatically.

---

## Latest Version Features (August 2025)

### Security First Architecture
- **Automated Password Generation**: 16-character passwords with mixed complexity
- **MD5 Encryption**: Standard password hashing
- **Private Network Optimized**: Streamlined for private subnet deployment
- **Audit Logging**: Complete connection and statement logging
- **Kubernetes Secrets**: Auto-generated with proper encoding

### Production Ready
- **One-Command Deployment**: Fully automated secure setup
- **Kubernetes Integration**: Generates secrets and ConfigMaps
- **Data Migration**: Automatic migration from existing installations
- **Comprehensive Testing**: Built-in validation and verification

---

## Detailed Setup Process

### Step 1: Configure Inventory

Edit `hosts.ini` with your PostgreSQL server details:

```ini
[postgresql_servers]
postgres-vm ansible_host=10.0.2.176 ansible_user=mosipuser ansible_ssh_private_key_file=~/.ssh/mosip-key

# Configuration Comments (adjust as needed):
# PostgreSQL Version: 15
# PostgreSQL Port: 5433
# Storage Device: /dev/nvme2n1
# Mount Point: /srv/postgres
# Network CIDR: 10.0.0.0/8
# Kubernetes Namespace: postgres
```

### Step 2: Run Secure Setup

```bash
# Basic deployment with auto-confirmation
./run-postgresql-playbook.sh --auto-confirm

# Custom Kubernetes configuration
./run-postgresql-playbook.sh --namespace production --secret-name postgres-creds

# Enable verbose output for troubleshooting
./run-postgresql-playbook.sh -v
```

### Step 3: Verify Installation

```bash
# Check PostgreSQL status
./check-postgresql-status.sh

# Run comprehensive tests
./test-postgresql-lifecycle.sh
```

---

## 🔧 Configuration Options

### Advanced Playbook Variables

You can override defaults by setting environment variables or using `--extra-vars`:

```bash
# Custom PostgreSQL version
ansible-playbook -i hosts.ini postgresql-setup.yml --extra-vars "postgresql_version=14"

# Custom port
ansible-playbook -i hosts.ini postgresql-setup.yml --extra-vars "postgresql_port=5432"

# Custom storage device
ansible-playbook -i hosts.ini postgresql-setup.yml --extra-vars "storage_device=/dev/sdb"

# Custom mount point
ansible-playbook -i hosts.ini postgresql-setup.yml --extra-vars "mount_point=/data/postgres"

# Custom network CIDR
ansible-playbook -i hosts.ini postgresql-setup.yml --extra-vars "network_cidr=192.168.0.0/16"
```

---

## Security Features Explained

### Password Security
- **Automated Generation**: No manual password handling
- **16-Character Length**: Mixed case, numbers, special characters
- **MD5 Hashing**: Standard cryptographic hashing
- **No Logs**: Passwords never appear in log files or output

### Network Security
- **Private Subnet Only**: Optimized for internal networks
- **Connection Optimized**: Eliminates unnecessary overhead
- **Firewall Ready**: Configured for specific CIDR ranges
- **Audit Logging**: All connections and statements logged

### Kubernetes Security
- **Proper Encoding**: Base64 encoding for secrets
- **File Permissions**: 0600 for secret files
- **Namespace Isolation**: Proper Kubernetes namespace usage
- **Secret Separation**: Sensitive and non-sensitive data separated

---

---

## Kubernetes Integration

### Generated Files
After successful deployment, find these files in `/tmp/postgresql-secrets/`:

1. **`postgres-postgresql.yml`** - Kubernetes Secret
2. **`postgres-setup-config.yml`** - Kubernetes ConfigMap
3. **`DEPLOYMENT_INSTRUCTIONS.md`** - Deployment guide

### Deployment to Kubernetes

```bash
# Create namespace
kubectl create namespace postgres

# Apply secret and config
kubectl apply -f /tmp/postgresql-secrets/postgres-postgresql.yml
kubectl apply -f /tmp/postgresql-secrets/postgres-setup-config.yml

# Verify deployment
kubectl get secret postgres-postgresql -n postgres
kubectl get configmap postgres-setup-config -n postgres
```

### Using in Applications

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app
spec:
  template:
    spec:
      containers:
      - name: app
        image: my-app:latest
        env:
        - name: POSTGRES_HOST
          valueFrom:
            configMapKeyRef:
              name: postgres-setup-config
              key: postgres-host
        - name: POSTGRES_PORT
          valueFrom:
            configMapKeyRef:
              name: postgres-setup-config
              key: postgres-port
        - name: POSTGRES_PASSWORD
          valueFrom:
            secretKeyRef:
              name: postgres-postgresql
              key: postgres-password
```

---

## 🧪 Testing and Validation

### Built-in Tests

```bash
# Complete lifecycle test
./test-postgresql-lifecycle.sh

# Status check
./check-postgresql-status.sh
```

### Manual Validation

```bash
# Test connection (password will be shown in deployment summary)
PGPASSWORD='<generated-password>' psql -h 10.0.2.176 -p 5433 -U postgres -c "SELECT version();"

# Check configuration
PGPASSWORD='<generated-password>' psql -h 10.0.2.176 -p 5433 -U postgres -c "SHOW password_encryption;"

# Verify logging
sudo tail -f /var/log/postgresql/postgresql-15-main.log
```

---

## 🛠️ Maintenance and Troubleshooting

### Common Issues

1. **Device Already Mounted**
   ```bash
   # Check what's mounted
   df -h | grep nvme2n1
   
   # Unmount if needed
   sudo umount /dev/nvme2n1
   ```

2. **Permission Issues**
   ```bash
   # Fix data directory permissions
   sudo chown -R postgres:postgres /srv/postgres/postgresql/15/main
   sudo chmod -R 700 /srv/postgres/postgresql/15/main
   ```

3. **Connection Issues**
   ```bash
   # Check PostgreSQL status
   sudo systemctl status postgresql
   
   # Check if port is listening
   sudo netstat -tlnp | grep 5433
   ```

### Safe Cleanup

```bash
# Safe cleanup with backups
./cleanup-postgresql.sh --safe

# Complete cleanup (removes everything)
./cleanup-postgresql.sh --complete
```

---

## What Changed from Previous Version

### Security Improvements
- Automated secure password generation
- MD5 encryption for passwords
- Connection optimized for private networks
- Kubernetes integration
- Comprehensive audit logging

### Operational Excellence
- One-command deployment
- Automatic Kubernetes manifest generation
- Built-in testing and validation
- Safe cleanup procedures

---

## Requirements Checklist

### Server Requirements
- [ ] Ubuntu 20.04+ server
- [ ] 4GB+ RAM (8GB+ recommended)
- [ ] Dedicated storage device (e.g., `/dev/nvme2n1`)
- [ ] SSH key-based access configured

### Network Requirements
- [ ] Private subnet (10.0.0.0/8 recommended)
- [ ] SSH access on port 22
- [ ] PostgreSQL port 5433 accessible
- [ ] No encryption requirements (private network)

### Software Dependencies
- [ ] Ansible installed
- [ ] Python3-bcrypt package
- [ ] Python3-psycopg2 package
- [ ] SSH keys configured for target server

---

## �� Quick Reference Commands

```bash
# Deploy PostgreSQL
./run-postgresql-playbook.sh --auto-confirm

# Check status
./check-postgresql-status.sh

# Test everything
./test-postgresql-lifecycle.sh

# View generated secrets
ls -la /tmp/postgresql-secrets/

# Connect to PostgreSQL (use password from deployment output)
PGPASSWORD='<password>' psql -h <host> -p 5433 -U postgres

# Safe cleanup
./cleanup-postgresql.sh --safe
```

---

*This guide covers the complete PostgreSQL secure setup process optimized for MOSIP infrastructure deployment*
