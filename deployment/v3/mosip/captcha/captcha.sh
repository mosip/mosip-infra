#!/bin/sh
# Creates configmap and secrets for Prereg Captcha
## Usage: ./captcha.sh [kubeconfig]
[ $# -lt 2 ] && { echo "Usage: ./captcha.sh <site-key> <secret> [kubeconfig]"; exit 1; }

if [ $# -ge 2 ] ; then
  export KUBECONFIG=$3
fi

NS=prereg

echo Create namespace
kubectl create ns $NS 

kubectl -n $NS create secret generic prereg-captcha --from-literal=prereg-captcha-site-key=$1 --from-literal=prereg-captcha-secret-key=$2 --dry-run=client  -o yaml | kubectl apply -f -
