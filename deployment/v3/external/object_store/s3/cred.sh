#!/bin/sh
# Creates configmap and secrets for S3

[ $# -lt 3 ] && { echo "Usage: ./cred.sh <aws access key> <secret> <region>"; exit 1; }

NS=s3

echo Create namespace
kubectl create ns $NS 

echo Istio label 
kubectl label ns $NS istio-injection=enabled --overwrite

kubectl -n s3 create configmap s3 --from-literal=s3-user-key=$1 --from-literal=s3-region=$3 --dry-run=client  -o yaml | kubectl apply -f -
kubectl -n s3 create secret generic s3 --from-literal=s3-user-secret=$2 --dry-run=client  -o yaml | kubectl apply -f -
