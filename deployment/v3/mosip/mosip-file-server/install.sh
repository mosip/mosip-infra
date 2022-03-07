#!/bin/sh
# Install mosip-file-server
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi


NS=mosip-file-server
CHART_VERSION=1.2.0

echo Create namespace
kubectl create $NS namespace

echo Istio label Disabled
kubectl label ns $NS istio-injection=disabled --overwrite
helm repo update


FILESERVER_HOST=$(kubectl get cm global -o jsonpath={.data.mosip-fileserver-host})
HEALTH_URL=https://$FILESERVER_HOST/mosipvc/

echo Install mosip-file-server. This may take a few minutes ..
helm -n $NS install mosip-file-server mosip/mosip-file-server \
  --set mosip_file_server.healthCheckUrl=$HEALTH_URL \
  --wait \
  -f values.yaml \
  --version $CHART_VERSION

echo Get your download url from here
echo https://$FILESERVER_HOST/mosipvc
