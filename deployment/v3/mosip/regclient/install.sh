#!/bin/sh
# Installs Reg Client Downloader
NS=regclient

echo Create namespace
kubectl create ns $NS

echo Istio label 
kubectl label ns $NS istio-injection=enabled --overwrite
helm repo update

echo Copy configmaps
./copy_cm.sh

REGCLIENT_URL=`kubectl get cm global -o json | jq .data.\"mosip-regclient-url\" | tr -d '"'`
REGCLIENT_HOST=`kubectl get cm global -o json | jq .data.\"mosip-regclient-host\" | tr -d '"'`
INTERNAL_URL=`kubectl get cm global -o json | jq .data.\"mosip-api-internal-url\" | tr -d '"'`
HEALTH_URL=$INTERNAL_URL/v1/syncdata/actuator/health
INTERNAL_HOST=`kubectl get cm global -o json | jq .data.\"mosip-api-internal-host\" | tr -d '"'`

echo Install reg client downloader. This may take a few minutes ..
helm -n $NS install regclient mosip/regclient \
  --set regclient.upgradeServerUrl=$REGCLIENT_URL \
  --set regclient.healthCheckUrl=$HEALTH_URL \
  --set istio.host=$REGCLIENT_HOST \
  --wait

echo Get your download url from here
echo $REGCLIENT_URL/
