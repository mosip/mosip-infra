#!/bin/bash
## Point config to your cluster on which you are installing IAM.
## "Usage: ./install.sh [kube_config_file]"

if [ $# -ge 1 ]; then
  export KUBECONFIG=$1
fi
NS=keycloak
SERVICE_NAME=keycloak
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
    if [[ "$current_host" == "iam.sandbox.xyz.net" ]]; then
        echo "⚠️  WARNING: You are using the default placeholder host 'iam.sandbox.xyz.net'"
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
                echo "Enter your domain name for IAM (e.g., iam.yourdomain.com):"
                read -r new_host
                if [[ -n "$new_host" && "$new_host" != "iam.sandbox.xyz.net" ]]; then
                    # Update the host in the YAML file
                    sed -i "s/host: $current_host/host: $new_host/" istio-addons-values.yaml
                    echo "✅ Host updated to: $new_host"
                    echo ""
                    break
                else
                    echo "❌ Invalid domain name. Please provide a valid domain."
                    echo ""
                    continue
                fi
                ;;
            2)
                # Re-read the current host to verify
                current_host=$(grep -A1 "host:" istio-addons-values.yaml | grep -v "serviceHost" | head -1 | cut -d: -f2 | tr -d ' ')
                if [[ "$current_host" == "iam.sandbox.xyz.net" ]]; then
                    echo "❌ The configuration still shows the default host. Please update it first."
                    echo ""
                    continue
                else
                    echo "✅ Configuration verified. Current host: $current_host"
                    echo ""
                    break
                fi
                ;;
            3)
                echo "❌ Installation cancelled."
                echo "Please update the 'istio-addons-values.yaml' file with the correct host configuration and run the script again."
                echo "Edit the file and change the host value from 'iam.sandbox.xyz.net' to your actual domain."
                exit 1
                ;;
            *)
                echo "❌ Invalid choice. Please enter 1, 2, or 3."
                echo ""
                ;;
        esac
    else
        echo "✅ Host configuration appears to be updated: $current_host"
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
                echo "Please update the 'istio-addons-values.yaml' file with the correct host configuration and run the script again."
                exit 1
                ;;
            *)
                echo "❌ Invalid response. Please enter 'yes' or 'no'."
                echo ""
                ;;
        esac
    fi
done

echo Creating $NS namespace
kubectl create ns $NS

function installing_keycloak() {
  echo Istio label
  ## TODO: enable istio injection after testing well.
  kubectl label ns $NS istio-injection=disabled --overwrite
  helm repo add bitnami https://charts.bitnami.com/bitnami
  helm repo update

  echo Installing
  helm -n $NS install $SERVICE_NAME mosip/keycloak --version "7.1.18" \
  --set image.repository=mosipid/mosip-artemis-keycloak \
  --set image.tag=1.2.0.1 \
  --set image.pullPolicy=Always \
  --set postgresql.image.repository="mosipint/postgresql" \
  --set postgresql.image.tag="14.2.0-debian-10-r70" \
  -f values.yaml --wait

  echo Install Istio gateway, virtual service
  helm -n $NS install istio-addons mosip/istio-addons --version $ISTIO_ADDONS_CHART_VERSION -f istio-addons-values.yaml
  return 0
}

# set commands for error handling.
set -e
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errtrace  # trace ERR through 'time command' and other functions
set -o pipefail  # trace ERR through pipes
installing_keycloak   # calling function
