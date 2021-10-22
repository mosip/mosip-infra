#!/bin/sh
NS=activemq

echo Create namespace
kubectl create ns $NS
kubectl label namespace $NS istio-injection=enabled --overwrite

echo Updating repos
helm repo add mosip https://mosip.github.io/mosip-helm
helm repo update

echo Installing Activemq
ACTIVEMQ_HOST=$(kubectl get cm global -o jsonpath={.data.mosip-activemq-host})
echo Activemq host: $ACTIVEMQ_HOST
helm -n $NS install activemq mosip/activemq-artemis -f values.yaml --set istio.hosts[0]="$ACTIVEMQ_HOST"
