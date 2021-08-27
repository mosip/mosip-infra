#!/bin/sh
# Creates configmap and secrets for Prereg Captcha
[ $# -lt 2 ] && { echo "Usage: ./captcha.sh <site-key> <secret>"; exit 1; }

NS=prereg

echo Create namespace
kubectl create ns $NS 

kubectl -n $NS create secret generic prereg-captcha --from-literal=prereg-captcha-site-key=$1 --from-literal=prereg-captcha-secret-key=$2 --dry-run=client  -o yaml | kubectl apply -f -
