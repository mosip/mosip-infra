#!/bin/bash

# Creates captcha secrets for MOSIP services (prereg, admin, resident).

ROOT_DIR=`pwd`
NS=captcha

# Set the site keys and secret keys
PSITE_KEY="$1"
PSECRET_KEY="$2"
ASITE_KEY="$3"
ASECRET_KEY="$4"
RSITE_KEY="$5"
RSECRET_KEY="$6"


function secret_setup() {

  # Configure Captcha secrets for prereg, admin and resident
  echo "Setting up captcha secrets"
  kubectl -n $NS create secret generic mosip-captcha \
    --from-literal=prereg-captcha-site-key="$PSITE_KEY" \
    --from-literal=prereg-captcha-secret-key="$PSECRET_KEY" \
    --from-literal=admin-captcha-site-key="$ASITE_KEY" \
    --from-literal=admin-captcha-secret-key="$ASECRET_KEY" \
    --from-literal=resident-captcha-site-key="$RSITE_KEY" \
    --from-literal=resident-captcha-secret-key="$RSECRET_KEY" \
    --dry-run=client -o yaml | kubectl apply -f -
  echo "Captcha secrets configured successfully for prereg, admin and resident in namespace $NS."

  return 0
}
# Set commands for error handling.
set -e
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value
set -o nounset   ## set -u : exit the script if you try to use an uninitialized variable
set -o errtrace  # trace ERR through 'time command' and other functions
set -o pipefail  # trace ERR through pipes
secret_setup   # calling function
