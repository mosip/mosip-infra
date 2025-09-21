#!/bin/bash
# Script to initialize the DB. 
## Usage: ./init_db.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

function initialize_db() {
  NS=postgres
  CHART_VERSION=12.0.1
  helm repo update
  
  # Ask user about PostgreSQL deployment type
  echo ""
  echo "PostgreSQL Deployment Configuration:"
  echo "1. Container-based PostgreSQL (deployed in Kubernetes)"
  echo "2. External PostgreSQL (deployed outside Kubernetes)"
  echo ""
  
  while true; do
      read -p "Which type of PostgreSQL deployment are you using? (1/2): " deployment_type
      case $deployment_type in
          1)
              echo "Using container-based PostgreSQL."
              echo "Updating init_values.yaml with container PostgreSQL configuration:"
              echo "  Host: postgres-postgresql.postgres"
              echo "  Port: 5432 (default)"
              
              # Update all host entries to container default
              sed -i 's/host: "[^"]*"/host: "postgres-postgresql.postgres"/g' init_values.yaml
              
              # Update all port entries to container default
              sed -i 's/port: [0-9]*/port: 5432/g' init_values.yaml
              
              echo "✓ Updated init_values.yaml with container PostgreSQL settings"
              echo ""
              break
              ;;
          2)
              echo ""
              echo "You are using external PostgreSQL."
              echo "Please provide the connection details for your external PostgreSQL server."
              echo "Current configuration in init_values.yaml:"
              echo "  Host: postgres-postgresql.postgres"
              echo "  Port: 5432"
              echo ""
              read -p "Enter your external PostgreSQL host (e.g., 192.168.1.100 or postgres.example.com): " external_host
              
              if [ -z "$external_host" ]; then
                  echo "Error: Host cannot be empty. Please run the script again and provide a valid host."
                  exit 1
              fi
              
              echo ""
              read -p "Enter your external PostgreSQL port [5432]: " external_port
              
              # Set default port if empty
              if [ -z "$external_port" ]; then
                  external_port=5432
                  echo "Using default port: 5432"
              fi
              
              # Validate port number
              if ! [[ "$external_port" =~ ^[0-9]+$ ]] || [ "$external_port" -lt 1 ] || [ "$external_port" -gt 65535 ]; then
                  echo "Error: Invalid port number. Port must be a number between 1 and 65535."
                  exit 1
              fi
              
              echo ""
              echo "Updating init_values.yaml with external PostgreSQL configuration:"
              echo "  Host: $external_host"
              echo "  Port: $external_port"
              
              # Update all host entries in init_values.yaml
              sed -i "s/host: \"postgres-postgresql.postgres\"/host: \"$external_host\"/g" init_values.yaml
              
              # Update all port entries in init_values.yaml
              sed -i "s/port: 5432/port: $external_port/g" init_values.yaml
              
              echo "✓ Updated init_values.yaml with external PostgreSQL host: $external_host and port: $external_port"
              echo ""
              break
              ;;
          *)
              echo "Invalid option. Please enter 1 or 2."
              ;;
      esac
  done
  
  while true; do
      read -p "CAUTION: all existing data will be lost. Are you sure?(Y/n)" yn
      if [ $yn = "Y" ]
        then
          echo Removing any existing installation
          helm -n $NS delete postgres-init || true
          echo Initializing DB
          helm -n $NS install postgres-init mosip/postgres-init -f init_values.yaml --version $CHART_VERSION --wait --wait-for-jobs
          break
        else
          break
      fi
  done
  return 0
}

# set commands for error handling.
set -e
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errtrace  # trace ERR through 'time command' and other functions
set -o pipefail  # trace ERR through pipes
initialize_db   # calling function
