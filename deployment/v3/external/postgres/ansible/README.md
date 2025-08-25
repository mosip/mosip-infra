# PostgreSQL Secure Setup - MOSIP Infrastructure

Production-grade PostgreSQL deployment with secure password generation, Kubernetes integration, and private subnet optimization.

## Quick Start (3 Simple Steps)

```bash
# 1. Interactive inventory setup with smart defaults
./setup-vm-inventory.sh

# 2. Deploy PostgreSQL with secure setup
./run-postgresql-playbook.sh

# 3. Verify installation status
./check-postgresql-status.sh
```

## 🎯 Core Features

### Security Features
- **16-character secure passwords** with mixed complexity
- **MD5 encryption** for password security
- **Private subnet optimized** deployment
- **Audit logging** for connections and statements
- **Kubernetes secrets** with proper base64 encoding

### Deployment Features
- **Streamlined deployment** for private networks
- **Custom port configuration** (default 5433)
- **XFS filesystem** with optimized mount options
- **Connection pooling ready** with high max_connections

### Production Ready
- **Automated password generation** - no manual password handling
- **Kubernetes integration** - generates secrets and ConfigMaps
- **Data migration support** - moves existing data to new storage
- **Complete lifecycle management** - setup, monitoring, cleanup

## Essential Scripts

### Production Scripts
- **`run-postgresql-playbook.sh`** - Main secure deployment script ⭐
- **`postgresql-setup.yml`** - Secure Ansible playbook ⭐
- **`check-postgresql-status.sh`** - Status monitoring and verification
- **`cleanup-postgresql.sh`** - Safe cleanup with backups

### 📁 Configuration Files
- **`hosts.ini`** - Ansible inventory configuration
- **`postgresql-cleanup.yml`** - Cleanup playbook

### 🧪 Testing Tools
- **`test-postgresql-lifecycle.sh`** - Complete deployment testing

## �� Configuration

Edit `hosts.ini` to configure your PostgreSQL server:

```ini
[postgresql_servers]
postgres-vm ansible_host=10.0.2.176 ansible_user=mosipuser ansible_ssh_private_key_file=~/.ssh/mosip-key

# Configuration Comments:
# PostgreSQL Version: 15
# PostgreSQL Port: 5433
# Storage Device: /dev/nvme2n1
# Mount Point: /srv/postgres
# Network CIDR: 10.0.0.0/8
# Kubernetes Namespace: postgres
```

## 🛠️ Advanced Usage

### Security Configuration
```bash
# Use custom Kubernetes namespace and secret name
./run-postgresql-playbook.sh --namespace production --secret-name postgres-creds

# Auto-confirm deployment (for automation)
./run-postgresql-playbook.sh --auto-confirm
```

### Kubernetes Integration
After deployment, Kubernetes files are generated in `/tmp/postgresql-secrets/`:
- `postgres-postgresql.yml` - Secret with credentials
- `postgres-setup-config.yml` - ConfigMap with connection details
- `DEPLOYMENT_INSTRUCTIONS.md` - Deployment guide

### Monitoring and Maintenance
```bash
# Check PostgreSQL status
./check-postgresql-status.sh

# Test complete lifecycle
./test-postgresql-lifecycle.sh

# Safe cleanup (creates backups)
./cleanup-postgresql.sh --safe
```

## Security Features

### Applied Security Measures
- 16-character secure passwords (mixed case, numbers, special chars)
- MD5 password encryption
- Private subnet deployment (no encryption overhead)
- Connection and statement audit logging
- Kubernetes secrets with proper base64 encoding
- Proper file permissions (0600 for secrets)
- Separation of sensitive and non-sensitive data
- No plaintext passwords in logs or files

## Requirements

- **Operating System**: Ubuntu 20.04+ server
- **Access**: SSH key-based authentication
- **Storage**: Dedicated device (e.g., `/dev/nvme2n1`)
- **Memory**: 4GB+ RAM (8GB+ recommended)
- **Network**: Private subnet (10.0.0.0/8)
- **Dependencies**: Ansible, Python3-bcrypt, Python3-psycopg2

## 🎯 Workflow Overview

```
Edit hosts.ini → run-postgresql-playbook.sh → PostgreSQL Ready
                          ↓
                  Kubernetes files generated
                          ↓
              check-postgresql-status.sh (verify)
```

## What Changed from Previous Version

### Security Enhancements
- **Encryption Optimized**: Streamlined for private subnet deployment
- **Secure Password Generation**: Automated 16-character passwords
- **MD5 Encryption**: Standard password encryption
- **Kubernetes Integration**: Auto-generated secrets and ConfigMaps

### Operational Excellence
- **Automated Deployment**: One-command secure setup
- **Production Ready**: Enterprise-grade security and monitoring
- **Easy Integration**: Kubernetes-ready with generated manifests

---

*Secure, fast, and production-ready PostgreSQL for MOSIP infrastructure*
