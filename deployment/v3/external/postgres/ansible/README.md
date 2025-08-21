# PostgreSQL Automation Suite

Complete PostgreSQL automation with enhanced setup, intelligent configuration, and comprehensive lifecycle management.

## 🚀 Quick Start

### New Enhanced Workflow (Recommended)
```bash
# 1. Interactive inventory setup with smart defaults
./setup-vm-inventory.sh

# 2. Enhanced PostgreSQL installation
./run-postgresql-playbook.sh

# 3. Verify installation
./check-postgresql-status.sh
```

### Legacy Workflow (Still Available)
```bash
# Original setup script (interactive)
./ansible-postgresql.sh
```

## 🆕 Recent Updates

- **Enhanced Setup**: Interactive inventory creator with smart defaults
- **Device Conflict Fix**: Uses `/dev/nvme2n1` instead of `/dev/nvme1n1` to avoid NFS conflicts
- **Improved Error Handling**: Better troubleshooting and validation
- **Complete Testing**: End-to-end validation with PostgreSQL 15.14 on custom port 5433

## 📚 Documentation

- **[Complete Guide](COMPLETE_POSTGRESQL_GUIDE.md)** - Comprehensive setup and usage
- **[ACL Troubleshooting](ACL_PERMISSION_FIX.md)** - Permission issue fixes
- **[Legacy Docs](old-docs/)** - Previous documentation versions

## 🛠️ Key Features

- **Interactive Setup**: Guided configuration with validation
- **Smart Defaults**: Conflict-free device and network settings
- **Security Hardening**: Custom ports and network restrictions
- **Complete Cleanup**: Multi-level cleanup with automatic backups
- **Production Ready**: Tested end-to-end with comprehensive validation

## 🔧 Main Scripts

- `setup-vm-inventory.sh` - Interactive inventory creator ⭐
- `run-postgresql-playbook.sh` - Enhanced playbook runner ⭐
- `cleanup-postgresql.sh` - Complete cleanup system
- `check-postgresql-status.sh` - Status verification
- `ansible-postgresql.sh` - Legacy setup script

## 📋 Requirements

- Ubuntu 20.04+ server
- SSH key-based access
- Storage device for PostgreSQL data (e.g., `/dev/nvme2n1`)
- 4GB+ RAM (8GB+ recommended)

---

*For detailed instructions, see [COMPLETE_POSTGRESQL_GUIDE.md](COMPLETE_POSTGRESQL_GUIDE.md)*
