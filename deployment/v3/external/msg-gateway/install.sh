#!/bin/sh
# Creates configmap and secrets for Email 
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=msg-gateways

echo Create $NS namespace
kubectl create ns $NS

echo Istio label
kubectl label ns $NS istio-injection=enabled --overwrite

HOST=mock-smtp.mock-smtp
PORT=8025
USER=
SECRET="''"

read -p "Would you like to use mock-smtp (Y/N) [ Default: Y ] : " yn
# Set yn to N if user input is null
if [ -z $yn ]; then
  yn=Y;
fi
if [ $yn != "Y" ]; then
    read -p "Please enter the SMTP host " HOST
    read -p "Please enter the SMTP host port " PORT
    read -p "Please enter the SMTP user " USER
    read -p "Please enter the SMTP secret key " SECRET
fi

kubectl -n $NS delete --ignore-not-found=true configmap email-gateway
kubectl -n $NS create configmap email-gateway --from-literal="email-smtp-host=$HOST" --from-literal="email-smtp-port=$PORT" --from-literal="email-smtp-username=$USER"
kubectl -n $NS delete --ignore-not-found=true secret email-gateway
kubectl -n $NS create secret generic email-gateway --from-literal="email-smtp-secret=$SECRET" --dry-run=client  -o yaml | kubectl apply -f -

echo Email realted configurations set.
