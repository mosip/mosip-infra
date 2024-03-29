#!/bin/bash
# Creates configmap and secrets for Prereg Captcha
# Creates configmap and secrets for resident Captcha
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=captcha
PREREG_HOST=$(kubectl get cm global -o jsonpath={.data.mosip-prereg-host})
RESIDENT_HOST=$(kubectl get cm global -o jsonpath={.data.mosip-resident-host})
ESIGNET_HOST=$(kubectl get cm global -o jsonpath={.data.mosip-esignet-host})

echo Create $NS namespace
kubectl create ns $NS

function Prereg_Captcha() {
  echo Please enter the recaptcha admin site key for domain $PREREG_HOST
  read SITE_KEY
  echo Please enter the recaptcha admin secret key for domain $PREREG_HOST
  read SECRET_KEY
  echo Please enter the recaptcha admin site key for domain $RESIDENT_HOST
  read RSITE_KEY
  echo Please enter the recaptcha admin secret key for domain $RESIDENT_HOST
  read RSECRET_KEY
  echo Please enter the recaptcha admin site key for domain $ESIGNET_HOST
  read ESITE_KEY
  echo Please enter the recaptcha admin secret key for domain $ESIGNET_HOST
  read ESECRET_KEY

  echo Setting up captcha secrets
  kubectl -n $NS create secret generic mosip-captcha --from-literal=prereg-captcha-site-key=$SITE_KEY --from-literal=prereg-captcha-secret-key=$SECRET_KEY --from-literal=resident-captcha-site-key=$RSITE_KEY --from-literal=resident-captcha-secret-key=$RSECRET_KEY --from-literal=esignet-captcha-site-key=$ESITE_KEY --from-literal=esignet-captcha-secret-key=$ESECRET_KEY --dry-run=client -o yaml | kubectl apply -f -
}

# set commands for error handling.
set -e
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errtrace  # trace ERR through 'time command' and other functions
set -o pipefail  # trace ERR through pipes
Prereg_Captcha   # calling function
