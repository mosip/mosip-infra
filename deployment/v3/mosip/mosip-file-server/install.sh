#!/bin/sh
# Install mosip-file-server
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi


NS=mosip-file-server
CHART_VERSION=12.0.1

echo Create $NS namespace
kubectl create ns $NS

echo Istio label Disabled
kubectl label ns $NS istio-injection=disabled --overwrite
helm repo update

echo Copy configmaps
./copy_cm.sh

FILESERVER_HOST=$(kubectl get cm global -o jsonpath={.data.mosip-api-host})
HEALTH_URL=https://$FILESERVER_HOST/.well-known/

echo Install mosip-file-server. This may take a few minutes ..
helm -n $NS install mosip-file-server mosip/mosip-file-server      \
  --set mosipfileserver.host=$FILESERVER_HOST                      \
  --set istio.existingGateway="istio-system/public"                \
  --wait                                                           \
  -f values.yaml                                                   \
  --version $CHART_VERSION

echo Get your download url from here
echo https://$FILESERVER_HOST/.well-known/
