#!/bin/bash
# Loads sample masterdata 
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=masterdata-loader
CHART_VERSION=12.0.1

# Check if user has updated values.yaml with correct database configuration
echo "=============================================="
echo "Pre-installation validation"
echo "=============================================="
echo ""
echo "Before proceeding with the installation, please ensure you have updated"
echo "the 'values.yaml' file with the correct database configuration."
echo ""
echo "Current database configuration:"
current_db_host=$(grep -A1 "host:" values.yaml | head -1 | cut -d: -f2 | tr -d ' "')
current_db_port=$(grep -A1 "port:" values.yaml | head -1 | cut -d: -f2 | tr -d ' ')
echo "Database Host: $current_db_host"
echo "Database Port: $current_db_port"
echo ""

while true; do
    if [[ "$current_db_host" == "postgres-postgresql.postgres" ]]; then
        echo "⚠️  WARNING: You are using the default internal PostgreSQL host 'postgres-postgresql.postgres'"
        echo "   If you're using an external database, this needs to be updated."
        echo ""
        echo "Options:"
        echo "1. Update the database configuration now (for external database)"
        echo "2. Keep current configuration (using internal PostgreSQL)"
        echo "3. I have already updated it manually"
        echo "4. Exit to update manually"
        echo ""
        echo "Enter your choice (1/2/3/4):"
        read -r choice
        
        case "$choice" in
            1)
                echo ""
                echo "Enter your external database host (e.g., your-db-server.com):"
                read -r new_db_host
                echo "Enter your external database port (e.g., 5432):"
                read -r new_db_port
                
                if [[ -n "$new_db_host" && -n "$new_db_port" && "$new_db_host" != "postgres-postgresql.postgres" ]]; then
                    # Update the database configuration in the YAML file
                    sed -i "s/host: \"$current_db_host\"/host: \"$new_db_host\"/" values.yaml
                    sed -i "s/port: $current_db_port/port: $new_db_port/" values.yaml
                    echo "✅ Database configuration updated:"
                    echo "   Host: $new_db_host"
                    echo "   Port: $new_db_port"
                    echo ""
                    break
                else
                    echo "❌ Invalid database configuration. Please provide valid host and port."
                    echo ""
                    continue
                fi
                ;;
            2)
                echo "✅ Continuing with internal PostgreSQL configuration..."
                echo "   Host: $current_db_host"
                echo "   Port: $current_db_port"
                echo ""
                break
                ;;
            3)
                # Re-read the current database config to verify
                current_db_host=$(grep -A1 "host:" values.yaml | head -1 | cut -d: -f2 | tr -d ' "')
                current_db_port=$(grep -A1 "port:" values.yaml | head -1 | cut -d: -f2 | tr -d ' ')
                if [[ "$current_db_host" == "postgres-postgresql.postgres" ]]; then
                    echo "❌ The configuration still shows the default internal host. Please update it first or choose option 2."
                    echo ""
                    continue
                else
                    echo "✅ Configuration verified:"
                    echo "   Host: $current_db_host"
                    echo "   Port: $current_db_port"
                    echo ""
                    break
                fi
                ;;
            4)
                echo "❌ Installation cancelled."
                echo "Please update the 'values.yaml' file with the correct database configuration and run the script again."
                echo "Update the db.host and db.port values in values.yaml file."
                exit 1
                ;;
            *)
                echo "❌ Invalid choice. Please enter 1, 2, 3, or 4."
                echo ""
                ;;
        esac
    else
        echo "✅ Database configuration appears to be updated:"
        echo "   Host: $current_db_host"
        echo "   Port: $current_db_port"
        echo ""
        echo "Do you want to proceed with this configuration? (yes/no):"
        read -r user_response
        
        case "$user_response" in
            [Yy]|[Yy][Ee][Ss])
                echo "✅ Continuing with installation..."
                echo ""
                break
                ;;
            [Nn]|[Nn][Oo])
                echo "❌ Installation cancelled."
                echo "Please update the 'values.yaml' file with the correct database configuration and run the script again."
                exit 1
                ;;
            *)
                echo "❌ Invalid response. Please enter 'yes' or 'no'."
                echo ""
                ;;
        esac
    fi
done

echo  WARNING: This need to be executed only once at the begining for masterdata deployment. If reexecuted in a working env this will reset the whole master_data DB tables resulting in data loss.
echo  Please skip this if masterdata is already uploaded.
read -p "CAUTION: Do you still want to continue?(Y/n)" yn
if [ $yn = "Y" ]
  then
   helm delete masterdata-loader -n $NS
   echo Create $NS namespace
   kubectl create ns $NS

   # set commands for error handling.
   set -e
   set -o errexit   ## set -e : exit the script if any statement returns a non-true return value
   set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
   set -o errtrace  # trace ERR through 'time command' and other functions
   set -o pipefail  # trace ERR through pipes

   echo Istio label
   kubectl label ns $NS istio-injection=enabled --overwrite
   helm repo update

   echo Copy configmaps
   sed -i 's/\r$//' copy_secrets.sh
   ./copy_secrets.sh

   echo Loading masterdata
   helm -n $NS install masterdata-loader mosip/masterdata-loader \
      --set mosipDataGithubBranch="v1.2.2.0" \
      --set mosipDataGithubRepo="https://github.com/mosip/mosip-data" \
      --set mosipDataXlsfolderPath="\/home/mosip/mosip-data/mosip_master/xlsx" \
      -f values.yaml \
      --version $CHART_VERSION --wait --wait-for-jobs

   else
   break

fi
