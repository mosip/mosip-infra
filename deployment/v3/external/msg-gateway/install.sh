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

read -p "Please enter the SMTP host " HOST
read -p "Please enter the SMTP user " USER
read -p "Please enter the SMTP secret key " SECRET
kubectl -n $NS create configmap email-gateway --from-literal=email-smtp-host=$HOST --from-literal=email-smtp-username=$USER --dry-run=client  -o yaml | kubectl apply -f -
kubectl -n $NS create secret generic email-gateway --from-literal=email-smtp-secret="$SECRET" --dry-run=client  -o yaml | kubectl apply -f -

echo Email realted configurations set.
