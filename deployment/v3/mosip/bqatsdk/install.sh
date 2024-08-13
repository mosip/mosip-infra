#!/bin/bash
# Installs BqatSDK
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=bqatsdk
CHART_VERSION=0.0.1-develop

echo Create $NS namespace
kubectl create ns $NS

function installing_bqatsdk() {
  echo Istio label
  kubectl label ns $NS istio-injection=enabled --overwrite
  helm repo update

  echo Copy configmaps
  sed -i 's/\r$//' copy_cm.sh
  ./copy_cm.sh

  echo Installing Bqatsdk server
  helm -n $NS install bqatsdk-service mosip/biosdk-service \
  --set extraEnvVars[0].name="service_context_env" \
    --set extraEnvVars[0].value="/bqatsdk-service" \
    --set extraEnvVars[1].name="spring_application_name_env" \
    --set extraEnvVars[1].value="bqat-sdk" \
    --set extraEnvVars[2].name="spring_cloud_config_name_env" \
    --set extraEnvVars[2].value="bqat-sdk" \
    --set startupProbe.httpGet.path="\/bqatsdk-service/actuator/health" \
    --set livenessProbe.httpGet.path="\/bqatsdk-service/actuator/health" \
    --set readinessProbe.httpGet.path="\/bqatsdk-service/actuator/health" \
    --set biosdk.zippedLibUrl="http://artifactory.artifactory:80/bqat-sdk-0.0.1-SNAPSHOT-jar-with-dependencies.zip" \
    --set biosdk.bioapiImpl="io.bqat.sdk.impl.BqatQualitySDKService" \
    --set istio.prefix="\/bqatsdk-service" \
    --set fullnameOverride="bqatsdk-service" \
    --version $CHART_VERSION

  echo Bqatsdk service installed sucessfully.
  return 0
}

# set commands for error handling.
set -e
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errtrace  # trace ERR through 'time command' and other functions
set -o pipefail  # trace ERR through pipes
installing_bqatsdk   # calling function
