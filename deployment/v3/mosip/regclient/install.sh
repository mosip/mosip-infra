#!/bin/sh
# Installs Reg Client Downloader
NS=regclient
CHART_VERSION=1.2.0

echo Create namespace
kubectl create ns $NS

echo Istio label
kubectl label ns $NS istio-injection=enabled --overwrite
helm repo update

echo Copy configmaps
./copy_cm.sh

REGCLIENT_HOST=$(kubectl get cm global -o jsonpath={.data.mosip-regclient-host})
INTERNAL_HOST=$(kubectl get cm global -o jsonpath={.data.mosip-api-internal-host})
HEALTH_URL=https://$INTERNAL_HOST/v1/syncdata/actuator/health

echo Install reg client downloader. This may take a few minutes ..
helm -n $NS install regclient mosip/regclient \
  --set regclient.upgradeServerUrl=https://$REGCLIENT_HOST \
  --set regclient.healthCheckUrl=$HEALTH_URL \
  --set regclient.hostName=$INTERNAL_HOST \
  --set istio.host=$REGCLIENT_HOST \
  --wait \
  -f values.yaml \
  --version $CHART_VERSION

echo Get your download url from here
echo https://$REGCLIENT_HOST/
