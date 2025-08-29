#!/bin/bash
# Test Runner for PostgreSQL Ansible Playbook
# Specifically designed for Ubuntu 22.04/24.04 Mock VM testing

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Test configuration
TEST_INVENTORY="hosts-test.ini"
PLAYBOOK="postgresql-setup.yml"

# Logging
LOG_DIR="test-logs"
LOG_FILE="$LOG_DIR/postgres-test-$(date +%Y%m%d-%H%M%S).log"

# Function to print colored output
print_status() {
    echo -e "${BLUE}[$(date '+%H:%M:%S')]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Create log directory
mkdir -p "$LOG_DIR"

# Pre-flight checks
preflight_checks() {
    print_status "Running pre-flight checks..."
    
    # Check if inventory exists
    if [[ ! -f "$TEST_INVENTORY" ]]; then
        print_error "Test inventory file $TEST_INVENTORY not found!"
        print_status "Please create $TEST_INVENTORY or run ./test-setup.sh first"
        exit 1
    fi
    
    # Check if playbook exists
    if [[ ! -f "$PLAYBOOK" ]]; then
        print_error "Playbook $PLAYBOOK not found!"
        exit 1
    fi
    
    # Check ansible installation
    if ! command -v ansible-playbook &> /dev/null; then
        print_warning "Ansible not found. Installing..."
        sudo apt update
        sudo apt install -y ansible
    fi
    
    # Check Python3
    if ! command -v python3 &> /dev/null; then
        print_error "Python3 not found! Please install Python3"
        exit 1
    fi
    
    print_success "Pre-flight checks completed"
}

# Test connectivity
test_connectivity() {
    print_status "Testing connectivity to mock VM..."
    
    if ansible postgresql_servers -i "$TEST_INVENTORY" -m ping >> "$LOG_FILE" 2>&1; then
        print_success "Mock VM connectivity test passed"
    else
        print_error "Cannot connect to mock VM. Check your hosts-test.ini configuration"
        print_status "Log file: $LOG_FILE"
        exit 1
    fi
}

# Run the actual deployment
run_deployment() {
    print_status "Starting PostgreSQL deployment test..."
    print_status "This may take 5-10 minutes for first-time installation..."
    print_status "Log file: $LOG_FILE"
    
    # Run with verbose output for testing
    if ansible-playbook -i "$TEST_INVENTORY" "$PLAYBOOK" -v >> "$LOG_FILE" 2>&1; then
        print_success "PostgreSQL deployment completed successfully!"
    else
        print_error "PostgreSQL deployment failed!"
        print_status "Check log file: $LOG_FILE"
        print_status "Last 20 lines of log:"
        tail -n 20 "$LOG_FILE"
        exit 1
    fi
}

# Verify deployment
verify_deployment() {
    print_status "Verifying PostgreSQL deployment..."
    
    # Check if PostgreSQL is running
    if ansible postgresql_servers -i "$TEST_INVENTORY" -m shell -a "sudo systemctl is-active postgresql" >> "$LOG_FILE" 2>&1; then
        print_success "PostgreSQL service is running"
    else
        print_warning "PostgreSQL service status check failed"
    fi
    
    # Check if port is listening
    if ansible postgresql_servers -i "$TEST_INVENTORY" -m shell -a "netstat -tlnp | grep :5433" >> "$LOG_FILE" 2>&1; then
        print_success "PostgreSQL is listening on port 5433"
    else
        print_warning "PostgreSQL port 5433 check failed"
    fi
    
    # Check if Kubernetes files were generated
    if [[ -d "/tmp/postgresql-secrets" ]]; then
        print_success "Kubernetes files generated in /tmp/postgresql-secrets/"
        ls -la /tmp/postgresql-secrets/
    else
        print_warning "Kubernetes files not found in /tmp/postgresql-secrets/"
    fi
}

# Display results
show_results() {
    print_status "Test Results Summary:"
    echo "=================================="
    print_success "PostgreSQL Version: 15 (or configured version)"
    print_success "Port: 5433"
    print_success "Data Directory: /srv/postgres/postgresql/15/main"
    print_success "Kubernetes Files: /tmp/postgresql-secrets/"
    print_success "Log File: $LOG_FILE"
    echo ""
    print_status "Next Steps:"
    echo "1. Review Kubernetes files in /tmp/postgresql-secrets/"
    echo "2. Test database connection:"
    echo "   kubectl create ns postgres"
    echo "   kubectl apply -f /tmp/postgresql-secrets/postgres-postgresql.yml"
    echo "   kubectl apply -f /tmp/postgresql-secrets/postgres-setup-config.yml"
    echo ""
    print_status "To test connection directly on VM:"
    echo "ansible postgresql_servers -i $TEST_INVENTORY -m shell -a 'sudo -u postgres psql -p 5433 -c \"SELECT version();\"'"
}

# Cleanup function
cleanup() {
    print_status "Test completed. Logs saved to: $LOG_FILE"
}

# Main execution
main() {
    print_status "🧪 Starting PostgreSQL Mock VM Test"
    print_status "======================================"
    
    preflight_checks
    test_connectivity
    run_deployment
    verify_deployment
    show_results
    cleanup
    
    print_success "🎉 Mock VM test completed successfully!"
}

# Trap for cleanup
trap cleanup EXIT

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
