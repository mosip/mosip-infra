#!/bin/sh
# Creates configmap and secrets for S3/Minio
# Specific "" for region for minio local installation
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 3 ] ; then
  export KUBECONFIG=$4
fi

NS=s3

echo Create $NS namespace
kubectl create ns $NS 

echo Istio label 
kubectl label ns $NS istio-injection=enabled --overwrite

echo Plesae select the type of object-store to be used:
echo 1: for minio native using helm charts
echo 2: for s3 object store
read -p "Please choose the correct option as mentioned above(1/2) " choice
if [ $choice = "1" ]
then
echo Creating secrets as per Minio native installation
USER=$(kubectl -n minio get secret minio -o jsonpath='{.data.root-user}' | base64 --decode)
PASS=$(kubectl -n minio get secret minio -o jsonpath='{.data.root-password}' | base64 --decode)
kubectl -n s3 create configmap s3 --from-literal=s3-user-key=$USER --from-literal=s3-region="" --dry-run=client  -o yaml | kubectl apply -f -
kubectl -n s3 create secret generic s3 --from-literal=s3-user-secret=$Pass --dry-run=client  -o yaml | kubectl apply -f -
echo object-store secret and config map is set now.
break
elif [ $choice = "2" ]
then
read -p "Please enter the S3 user key " USER
read -p "Please enter the S3 secret key" PASS
read -p "Please enter the S3 region" REGION
kubectl -n s3 create configmap s3 --from-literal=s3-user-key=$USER --from-literal=s3-region=$REGION --dry-run=client  -o yaml | kubectl apply -f -
kubectl -n s3 create secret generic s3 --from-literal=s3-user-secret=$Pass --dry-run=client  -o yaml | kubectl apply -f -
echo object-store secret and config map is set now.
break
else
echo You entered wrong choice
kill -9 `ps --pid $$ -oppid=`; exit
break
fi
