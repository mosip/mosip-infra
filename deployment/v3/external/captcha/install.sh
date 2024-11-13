#!/bin/bash

# Creates captcha secrets for MOSIP services (prereg, admin, resident).
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

ROOT_DIR=`pwd`
NS=captcha

function secret_setup() {

  kubectl create ns $NS || true
  while true; do
    read -p "Do you want to continue configuring Captcha secrets for prereg ? (y/n) : " ans
      if [ "$ans" = 'Y' ] || [ "$ans" = 'y' ]; then
        echo "Please create captcha site and secret key for esignet domain: prereg.sandbox.xyz.net"

        PREREG_HOST=$(kubectl get cm global -o jsonpath={.data.mosip-prereg-host})
        echo Please enter the recaptcha admin site key for domain $PREREG_HOST
        read -s PSITE_KEY
        echo Please enter the recaptcha admin secret key for domain $PREREG_HOST
        read -s PSECRET_KEY
      elif [ "$ans" = "N" ] || [ "$ans" = "n" ]; then
        exit 1
      else
        echo "Please provide a correct option (Y or N)"
      fi
  done

  while true; do
    read -p "Do you want to continue configuring Captcha secrets for admin ? (y/n) : " ans
      if [ "$ans" ='Y' ] || [ "$ans" = 'y' ]; then
        echo "Please create captcha site and secret key for esignet domain: admin.sandbox.xyz.net"

        ADMIN_HOST=$(kubectl get cm global -o jsonpath={.data.mosip-admin-host})
        echo Please enter the recaptcha admin site key for domain $ADMIN_HOST
        read -s ASITE_KEY
        echo Please enter the recaptcha admin secret key for domain $ADMIN_HOST
        read -s ASECRET_KEY
      elif [ "$ans" = "N" ] || [ "$ans" = "n" ]; then
        exit 1
      else
        echo "Please provide a correct option (Y or N)"
      fi
  done

  while true; do
    read -p "Do you want to continue configuring Captcha secrets for resident ? (y/n) : " ans
      if [ "$ans" = 'Y' ] || [ "$ans" = 'y' ]; then
        echo "Please create captcha site and secret key for esignet domain: resident.sandbox.xyz.net"

        RESIDENT_HOST=$(kubectl get cm global -o jsonpath={.data.mosip-resident-host})
        echo Please enter the recaptcha admin site key for domain $RESIDENT_HOST
        read -s RSITE_KEY
        echo Please enter the recaptcha admin secret key for domain $RESIDENT_HOST
        read -s RSECRET_KEY
      elif [ "$ans" = "N" ] || [ "$ans" = "n" ]; then
        exit 1
      else
        echo "Please provide a correct option (Y or N)"
      fi
  done

  echo "Setting up captcha secrets"
  kubectl -n $NS create secret generic mosip-captcha --from-literal=prereg-captcha-site-key=$PSITE_KEY --from-literal=prereg-captcha-secret-key=$PSECRET_KEY --from-literal=admin-captcha-site-key=$ASITE_KEY --from-literal=admin-captcha-secret-key=$ASECRET_KEY --from-literal=resident-captcha-site-key=$RSITE_KEY --from-literal=resident-captcha-secret-key=$RSECRET_KEY --dry-run=client -o yaml | kubectl apply -f -
  echo "Captcha secrets for mosip configured sucessfully"

  return 0
}
# Set commands for error handling.
set -e
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value
set -o nounset   ## set -u : exit the script if you try to use an uninitialized variable
set -o errtrace  # trace ERR through 'time command' and other functions
set -o pipefail  # trace ERR through pipes
secret_setup   # calling function
