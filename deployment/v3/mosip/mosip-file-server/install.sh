#!/bin/sh
# Install mosip-file-server
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi


NS=mosip-file-server
CHART_VERSION=12.0.2

echo Create $NS namespace
kubectl create ns $NS

echo Istio label Disabled
kubectl label ns $NS istio-injection=disabled --overwrite
helm repo update

echo Copy configmaps
./copy_cm.sh

FILESERVER_HOST=$(kubectl get cm global -o jsonpath={.data.mosip-api-host})
API_HOST=$(kubectl get cm global -o jsonpath={.data.mosip-api-host})
API_INTERNAL_HOST=$(kubectl get cm global -o jsonpath={.data.mosip-api-internal-host})
HEALTH_URL=https://$FILESERVER_HOST/.well-known/

read -p "Please Enter MOBILE APP Link publicly accessible APK: " pub_url
read -p "Please Enter MOBILE APP Link privately accessible APK: " priv_url

echo Install mosip-file-server. This may take a few minutes ..
helm -n $NS install mosip-file-server mosip/mosip-file-server      \
  --set mosipfileserver.host=$FILESERVER_HOST                      \
  --set mosipfileserver.puburl={$pub_url}                          \
  --set mosipfileserver.privurl={$priv_url}                        \
  --set istio.corsPolicy.allowOrigins\[0\]=$API_HOST               \
  --set istio.corsPolicy.allowOrigins\[1\]=$API_INTERNAL_HOST      \
  --set istio.corsPolicy.allowOrigins\[2\].prefix=https://verifiablecredential.io \
  --wait                                                           \
  --version $CHART_VERSION

echo Get your download url from here
echo https://$FILESERVER_HOST/.well-known/
echo https://$FILESERVER_HOST/files/mobileapp/
