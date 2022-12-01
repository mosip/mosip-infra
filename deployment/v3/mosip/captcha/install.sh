#!/bin/sh
# Creates configmap and secrets for Prereg Captcha
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=prereg
PREREG_HOST=$(kubectl get cm global -o jsonpath={.data.mosip-prereg-host})

echo Create $NS namespace
kubectl create ns $NS

echo Please enter the recaptcha admin site key for domain $PREREG_HOST
read SITE_KEY
echo Please enter the recaptcha admin secret key for domain $PREREG_HOST
read SECRET_KEY

echo Please enter the recaptcha admin site key for domain $MOSIP_HOST
read MSITE_KEY
echo Please enter the recaptcha admin secret key for domain $MOSIP_HOST
read MSECRET_KEY

echo Setting up captcha secrets
kubectl -n $NS create secret generic prereg-captcha --from-literal=prereg-captcha-site-key=$SITE_KEY --from-literal=prereg-captcha-secret-key=$SECRET_KEY --dry-run=client  -o yaml | kubectl apply -f -
kubectl create secret generic mosip-captcha --from-literal=mosip-captcha-site-key=$MSITE_KEY --from-literal=mosip-captcha-secret-key=$MSECRET_KEY --dry-run=client  -o yaml | kubectl apply -f -