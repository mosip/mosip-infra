#!/bin/bash
# Installs kafka
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=kafka
CHART_VERSION=18.3.1
UI_CHART_VERSION=0.4.2
ISTIO_ADDONS_CHART_VERSION=1.0.0-develop

# Check if user has updated istio-addons-values.yaml with correct host
echo "=============================================="
echo "Pre-installation validation"
echo "=============================================="
echo ""
echo "Before proceeding with the installation, please ensure you have updated"
echo "the 'istio-addons-values.yaml' file with the correct host configuration."
echo ""
echo "Current host configuration:"
current_host=$(grep -A1 "host:" istio-addons-values.yaml | grep -v "serviceHost" | head -1 | cut -d: -f2 | tr -d ' ')
echo "Host: $current_host"
echo ""

while true; do
    if [[ "$current_host" == "kafka.sandbox.xyz.net" ]]; then
        echo "⚠️  WARNING: You are using the default placeholder host 'kafka.sandbox.xyz.net'"
        echo "   This needs to be updated with your actual domain name."
        echo ""
        echo "Options:"
        echo "1. Update the host configuration now"
        echo "2. I have already updated it manually"
        echo "3. Exit to update manually"
        echo ""
        echo "Enter your choice (1/2/3):"
        read -r choice
        
        case "$choice" in
            1)
                echo ""
                echo "Enter your domain name for Kafka UI (e.g., kafka.yourdomain.com):"
                read -r new_host
                if [[ -n "$new_host" && "$new_host" != "kafka.sandbox.xyz.net" ]]; then
                    # Update the host in the YAML file
                    sed -i "s/host: $current_host/host: $new_host/" istio-addons-values.yaml
                    echo "Host updated to: $new_host"
                    echo ""
                    break
                else
                    echo "Invalid domain name. Please provide a valid domain."
                    echo ""
                    continue
                fi
                ;;
            2)
                # Re-read the current host to verify
                current_host=$(grep -A1 "host:" istio-addons-values.yaml | grep -v "serviceHost" | head -1 | cut -d: -f2 | tr -d ' ')
                if [[ "$current_host" == "kafka.sandbox.xyz.net" ]]; then
                    echo "The configuration still shows the default host. Please update it first."
                    echo ""
                    continue
                else
                    echo "Configuration verified. Current host: $current_host"

                    echo ""
                    break
                fi
                ;;
            3)
                echo "Installation cancelled."


                echo "Please update the 'istio-addons-values.yaml' file with the correct host configuration and run the script again."
                echo "Edit the file and change the host value from 'kafka.sandbox.xyz.net' to your actual domain."
                exit 1
                ;;
            *)
                echo "Invalid choice. Please enter 1, 2, or 3."
                echo ""
                ;;
        esac
    else

        echo "Host configuration appears to be updated: $current_host"
        echo ""
        echo "Do you want to proceed with this configuration? (yes/no):"
        read -r user_response
        
        case "$user_response" in
            [Yy]|[Yy][Ee][Ss])
                echo "Continuing with installation..."

                echo ""
                break
                ;;
            [Nn]|[Nn][Oo])

                echo "Installation cancelled."


                echo "Please update the 'istio-addons-values.yaml' file with the correct host configuration and run the script again."
                exit 1
                ;;
            *)

                echo "Invalid response. Please enter 'yes' or 'no'."


                echo ""
                ;;
        esac
    fi
done

echo Create $NS namespace
kubectl create ns $NS

function installing_kafka() {
  echo Istio label
  kubectl label ns $NS istio-injection=enabled --overwrite

  echo Updating helm repos
  helm repo add kafka-ui https://provectus.github.io/kafka-ui-charts
  helm repo add bitnami https://charts.bitnami.com/bitnami
  helm repo update

  echo Installing kafka
  helm -n $NS install kafka bitnami/kafka \
  --set image.repository="mosipint/kafka" \
  --set image.tag="3.2.1-debian-11-r9" \
  --set zookeeper.image.repository="mosipint/zookeeper" \
  --set zookeeper.image.tag="3.8.0-debian-11-r30" \
  -f values.yaml --wait --timeout=10m --version $CHART_VERSION

  echo Installing kafka-ui
  helm -n $NS install kafka-ui kafka-ui/kafka-ui -f ui-values.yaml --wait --timeout=5m --version $UI_CHART_VERSION

  echo Install istio addons
  helm -n $NS install istio-addons mosip/istio-addons --version $ISTIO_ADDONS_CHART_VERSION -f istio-addons-values.yaml

  echo Installed kafka and kafka-ui services
  return 0
}

# set commands for error handling.
set -e
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errtrace  # trace ERR through 'time command' and other functions
set -o pipefail  # trace ERR through pipes
installing_kafka   # calling function
