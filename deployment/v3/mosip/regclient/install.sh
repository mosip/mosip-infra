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

REGCLIENT_HOST=`kubectl get cm global -o json | jq .data.\"mosip-regclient-host\" | tr -d '"'`
INTERNAL_HOST=`kubectl get cm global -o json | jq .data.\"mosip-api-internal-host\" | tr -d '"'`
HEALTH_URL=https://$INTERNAL_HOST/v1/syncdata/actuator/health

echo Install reg client downloader. This may take a few minutes ..
helm -n $NS install regclient mosip/regclient \
  --set regclient.upgradeServerUrl=https://$REGCLIENT_HOST \
  --set regclient.healthCheckUrl=$HEALTH_URL \
  --set istio.host=$REGCLIENT_HOST \
  --wait

echo Get your download url from here
echo https://$REGCLIENT_HOST/
