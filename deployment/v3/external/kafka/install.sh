#!/bin/bash
# Installs kafka
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=kafka
CHART_VERSION=0.4.2

echo Create $NS namespace
kubectl create ns $NS

function installing_kafka() {
  echo Istio label
  kubectl label ns $NS istio-injection=enabled --overwrite

  echo Updating helm repos
  helm repo add kafka-ui https://provectus.github.io/kafka-ui
  helm repo add bitnami https://charts.bitnami.com/bitnami
  helm repo update

  echo Installing kafka
  helm -n $NS install kafka mosip/kafka -f values.yaml --wait --version 18.3.1

  echo Installing kafka-ui
  helm -n $NS install kafka-ui kafka-ui/kafka-ui -f ui-values.yaml --wait --version $CHART_VERSION

  KAFKA_UI_HOST=$(kubectl get cm global -o jsonpath={.data.mosip-kafka-host})
  KAFKA_UI_NAME=kafka-ui

  echo Install istio addons
  helm -n $NS install istio-addons chart/istio-addons --set kafkaUiHost=$KAFKA_UI_HOST --set installName=$KAFKA_UI_NAME

  echo Installed kafka and kafka-ui services
  return 0
}

# set commands for error handling.
set -e
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errtrace  # trace ERR through 'time command' and other functions
set -o pipefail  # trace ERR through pipes
installing_kafka   # calling function
