#!/bin/bash

# PostgreSQL Secure Setup Script
# Production-grade deployment with secure password generation and Kubernetes integration

set -euo pipefail

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INVENTORY_FILE="${SCRIPT_DIR}/hosts.ini"
PLAYBOOK_FILE="${SCRIPT_DIR}/postgresql-setup.yml"
SECRETS_DIR="/tmp/postgresql-secrets"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging function
log() {
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Print banner
print_banner() {
    cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║                PostgreSQL Secure Setup                      ║
║           Production-Grade with Kubernetes Integration       ║
╚══════════════════════════════════════════════════════════════╝
EOF
}

# Check prerequisites
check_prerequisites() {
    log "Checking prerequisites..."
    
    # Check if running as non-root user
    if [[ $EUID -eq 0 ]]; then
        error "This script should not be run as root for security reasons"
        exit 1
    fi
    
    # Check if inventory file exists
    if [[ ! -f "$INVENTORY_FILE" ]]; then
        error "Inventory file not found: $INVENTORY_FILE"
        exit 1
    fi
    
    # Check if playbook exists
    if [[ ! -f "$PLAYBOOK_FILE" ]]; then
        error "Playbook file not found: $PLAYBOOK_FILE"
        exit 1
    fi
    
    # Check if ansible is installed
    if ! command -v ansible-playbook >/dev/null 2>&1; then
        error "ansible-playbook is not installed"
        exit 1
    fi
    
    # Check Python dependencies
    if ! python3 -c "import bcrypt" >/dev/null 2>&1; then
        warning "python3-bcrypt not found, installing..."
        sudo apt-get update && sudo apt-get install -y python3-bcrypt
    fi
    
    success "Prerequisites check passed"
}

# Show configuration
show_configuration() {
    log "Reading configuration from $INVENTORY_FILE..."
    
    # Extract configuration from inventory file
    POSTGRES_VERSION=$(grep -E "^\s*#.*PostgreSQL Version:" "$INVENTORY_FILE" | awk '{print $NF}' || echo "15")
    POSTGRES_PORT=$(grep -E "^\s*#.*PostgreSQL Port:" "$INVENTORY_FILE" | awk '{print $NF}' || echo "5433")
    STORAGE_DEVICE=$(grep -E "^\s*#.*Storage Device:" "$INVENTORY_FILE" | awk '{print $NF}' || echo "/dev/nvme2n1")
    MOUNT_POINT=$(grep -E "^\s*#.*Mount Point:" "$INVENTORY_FILE" | awk '{print $NF}' || echo "/srv/postgres")
    TARGET_HOST=$(grep "ansible_host=" "$INVENTORY_FILE" | awk -F'ansible_host=' '{print $2}' | awk '{print $1}')
    
    cat << EOF

Configuration Summary:
  PostgreSQL Version: $POSTGRES_VERSION
  Target Host: $TARGET_HOST
  Port: $POSTGRES_PORT
  Storage Device: $STORAGE_DEVICE
  Mount Point: $MOUNT_POINT
  Secrets Directory: $SECRETS_DIR
  Inventory File: $INVENTORY_FILE
  Playbook: $PLAYBOOK_FILE

Security Features:
  ✓ 16-character secure password generation
  ✓ MD5 password encryption
  ✓ Private subnet deployment (no SSL overhead)
  ✓ Connection and statement audit logging
  ✓ Kubernetes secrets with base64 encoding
  ✓ Proper file permissions (0600 for secrets)
  ✓ Separation of sensitive and non-sensitive data

EOF
}

# Test connectivity
test_connectivity() {
    log "Testing connectivity to PostgreSQL servers..."
    
    if ansible postgresql_servers -i "$INVENTORY_FILE" -m ping >/dev/null 2>&1; then
        success "Connectivity test passed"
    else
        error "Connectivity test failed"
        echo "Please check your inventory file and SSH configuration"
        exit 1
    fi
}

# Clean up previous secrets
cleanup_previous_secrets() {
    if [[ -d "$SECRETS_DIR" ]]; then
        warning "Previous secrets directory found, cleaning up..."
        rm -rf "$SECRETS_DIR"
    fi
    
    # Create secure directory
    mkdir -p "$SECRETS_DIR"
    chmod 700 "$SECRETS_DIR"
    log "Created secure secrets directory: $SECRETS_DIR"
}

# Main execution
main() {
    print_banner
    
    # Parse command line arguments
    KUBERNETES_NAMESPACE="postgres"
    SECRET_NAME="postgres-postgresql"
    AUTO_CONFIRM=false
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            --namespace)
                KUBERNETES_NAMESPACE="$2"
                shift 2
                ;;
            --secret-name)
                SECRET_NAME="$2"
                shift 2
                ;;
            --auto-confirm)
                AUTO_CONFIRM=true
                shift
                ;;
            -h|--help)
                cat << EOF
PostgreSQL Secure Setup Script

Usage: $0 [OPTIONS]

Options:
    --namespace NAMESPACE    Kubernetes namespace for secrets (default: postgres)
    --secret-name NAME       Name for Kubernetes secret (default: postgres-postgresql)
    --auto-confirm          Skip confirmation prompts
    -h, --help              Show this help message

Examples:
    $0
    $0 --namespace production --secret-name postgres-creds
    $0 --auto-confirm

EOF
                exit 0
                ;;
            *)
                error "Unknown option: $1"
                exit 1
                ;;
        esac
    done
    
    check_prerequisites
    show_configuration
    test_connectivity
    cleanup_previous_secrets
    
    # Confirmation prompt
    if [[ "$AUTO_CONFIRM" == "false" ]]; then
        echo
        read -p "Do you want to proceed with PostgreSQL secure setup? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            log "Setup cancelled by user"
            exit 0
        fi
    fi
    
    log "Starting PostgreSQL secure setup..."
    echo "=============================================="
    
    # Execute the secure playbook
    if ansible-playbook -i "$INVENTORY_FILE" "$PLAYBOOK_FILE" \
        --extra-vars "kubernetes_namespace=$KUBERNETES_NAMESPACE" \
        --extra-vars "secret_name=$SECRET_NAME" \
        -v; then
        
        echo
        echo "=============================================="
        success "PostgreSQL secure setup completed successfully!"
        
        # Show generated files
        if [[ -d "$SECRETS_DIR" ]]; then
            echo
            log "Generated Kubernetes files:"
            ls -la "$SECRETS_DIR"
            echo
            success "Kubernetes secret files are ready for deployment"
            success "Review the DEPLOYMENT_INSTRUCTIONS.md file for next steps"
            
            # Show file permissions
            echo
            log "File permissions (security check):"
            find "$SECRETS_DIR" -type f -exec ls -l {} \;
            
        else
            warning "Secrets directory not found. Check playbook execution."
        fi
        
    else
        error "PostgreSQL setup failed"
        exit 1
    fi
}

# Cleanup function for signals
cleanup() {
    log "Script interrupted, cleaning up..."
    # Add any cleanup operations here if needed
    exit 1
}

# Set up signal handlers
trap cleanup SIGINT SIGTERM

# Run main function
main "$@"
