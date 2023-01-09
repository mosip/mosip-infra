#!/bin/sh
# Creates configmap and secrets for Prereg Captcha
# Creates configmap and secrets for resident Captcha
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=captcha
PREREG_HOST=$(kubectl get cm global -o jsonpath={.data.mosip-prereg-host})
RESIDENT_HOST=$(kubectl get cm global -o jsonpath={.data.mosip-resident-host})

echo Create $NS namespace
kubectl create ns $NS

echo Please enter the recaptcha admin site key for domain $PREREG_HOST
read SITE_KEY
echo Please enter the recaptcha admin secret key for domain $PREREG_HOST
read SECRET_KEY
echo Please enter the recaptcha admin site key for domain $RESIDENT_HOST
read RSITE_KEY
echo Please enter the recaptcha admin secret key for domain $RESIDENT_HOST
read RSECRET_KEY

echo Setting up captcha secrets
kubectl -n $NS create secret generic mosip-captcha --from-literal=prereg-captcha-site-key=$SITE_KEY --from-literal=prereg-captcha-secret-key=$SECRET_KEY --from-literal=resident-captcha-site-key=$RSITE_KEY --from-literal=resident-captcha-secret-key=$RSECRET_KEY --dry-run=client -o yaml | kubectl apply -f -