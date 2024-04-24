#!/bin/bash
# Installs imagecompressor
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=image-compressor
CHART_VERSION=12.0.x-develop-B3

echo Create $NS namespace
kubectl create ns $NS

function installing_imagecompressor() {
  echo Istio label
  kubectl label ns $NS istio-injection=enabled --overwrite
  helm repo update

  echo Copy configmaps
  sed -i 's/\r$//' copy_cm.sh
  ./copy_cm.sh

  echo Installing imagecompressor server
  helm -n $NS install image-compressor mosip/biosdk-service \
  --set extraEnvVars[0].name="server_servlet_context_env" \
  --set extraEnvVars[0].value="/image-compressor" \
  --set extraEnvVars[1].name="spring_application_name_env" \
  --set extraEnvVars[1].value="image-compressor" \
  --set extraEnvVars[2].name="spring_cloud_config_name_env" \
  --set extraEnvVars[2].value="image-compressor" \
  --set startupProbe.httpGet.path="\/image-compressor/actuator/health" \
  --set livenessProbe.httpGet.path="\/image-compressor/actuator/health" \
  --set readinessProbe.httpGet.path="\/image-compressor/actuator/health" \
  --set biosdk.zippedLibUrl="http://artifactory.artifactory/artifactory/libs-release-local/compressor/image-compressor.zip" \
  --set biosdk.bioapiImpl="io.mosip.image.compressor.sdk.impl.ImageCompressorSDKV2" \
  --set istio.prefix="\/image-compressor" \
  --set fullnameOverride="image-compressor" \
  --version $CHART_VERSION

  echo imagecompressor service installed sucessfully.
  return 0
}

# set commands for error handling.
set -e
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errtrace  # trace ERR through 'time command' and other functions
set -o pipefail  # trace ERR through pipes
installing_imagecompressor   # calling function
