#!/bin/bash

# Creates captcha secrets for MOSIP services (prereg, admin, resident).
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ]; then
  export KUBECONFIG=$1
fi

ROOT_DIR=$(pwd)
NS=captcha

function prompt_for_secret() {
  local service=$1
  local host_var=$2
  local site_key_var=$3
  local secret_key_var=$4

  while true; do
    read -p "Do you want to configure Captcha secrets for $service? (y/n): " ans
    if [[ "$ans" == "y" || "$ans" == "Y" ]]; then
      local host=$(kubectl get cm global -o jsonpath="{.data.$host_var}")
      echo "Please create captcha site and secret key for domain: $host"

      echo "Enter the reCAPTCHA site key for domain $host:"
      read -s $site_key_var
      echo
      echo "Enter the reCAPTCHA secret key for domain $host:"
      read -s $secret_key_var
      echo

      if [ -z "${!site_key_var}" ] || [ -z "${!secret_key_var}" ]; then
        echo "Error: Site key or secret key cannot be empty. Please try again."
      else
        break
      fi
    elif [[ "$ans" == "n" || "$ans" == "N" ]]; then
      echo "Skipping configuration for $service."
      return 1
    else
      echo "Please provide a valid option (Y or N)"
    fi
  done
}

function secret_setup() {
  kubectl create ns $NS || true

  # Variables to store keys
  local PSITE_KEY PSECRET_KEY ASITE_KEY ASECRET_KEY RSITE_KEY RSECRET_KEY

  # Prompt for secrets for each service
  prompt_for_secret "prereg" "mosip-prereg-host" PSITE_KEY PSECRET_KEY || echo "Skipping prereg secrets."
  prompt_for_secret "admin" "mosip-admin-host" ASITE_KEY ASECRET_KEY || echo "Skipping admin secrets."
  prompt_for_secret "resident" "mosip-resident-host" RSITE_KEY RSECRET_KEY || echo "Skipping resident secrets."

  # Create Kubernetes secret
  echo "Setting up captcha secrets..."
  kubectl -n $NS create secret generic mosip-captcha \
    --from-literal=prereg-captcha-site-key="$PSITE_KEY" \
    --from-literal=prereg-captcha-secret-key="$PSECRET_KEY" \
    --from-literal=admin-captcha-site-key="$ASITE_KEY" \
    --from-literal=admin-captcha-secret-key="$ASECRET_KEY" \
    --from-literal=resident-captcha-site-key="$RSITE_KEY" \
    --from-literal=resident-captcha-secret-key="$RSECRET_KEY" \
    --dry-run=client -o yaml | kubectl apply -f -

  echo "Captcha secrets for MOSIP configured successfully."
}

# Set commands for error handling.
set -e
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value
set -o nounset   ## set -u : exit the script if you try to use an uninitialized variable
set -o errtrace  # trace ERR through 'time command' and other functions
set -o pipefail  # trace ERR through pipes
secret_setup   # calling function
