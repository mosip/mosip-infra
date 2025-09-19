#!/bin/bash
# Installs kafka
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=kafka
CHART_VERSION=18.3.1
UI_CHART_VERSION=0.4.2

echo Create $NS namespace
kubectl create ns $NS

function installing_kafka() {
  echo Istio label
  kubectl label ns $NS istio-injection=enabled --overwrite

  echo Updating helm repos
  helm repo add kafka-ui https://provectus.github.io/kafka-ui-charts
  helm repo add bitnami https://charts.bitnami.com/bitnami
  helm repo update

  echo Installing kafka
  helm -n $NS upgrade --install kafka mosip/kafka \
    --version $CHART_VERSION \
    --set image.repository=bitnamilegacy/kafka \
    --set image.tag=3.6.1-debian-12-r12 \
    --set jmx.metrics.image.repository=bitnamilegacy/jmx-exporter \
    --set jmx.metrics.image.tag=0.20.0-debian-12-r11 \
    --set kafkaExporter.image.repository=bitnamilegacy/kafka-exporter \
    --set kafkaExporter.image.tag=1.7.0-debian-12-r19 \
    --set kubectl.image.repository=bitnamilegacy/kubectl \
    --set kubectl.image.tag=1.29.2-debian-12-r2 \
    --set volumePermissions.image.repository=bitnamilegacy/os-shell \
    --set volumePermissions.image.tag=12-debian-12-r16 \
    --set zookeeper.image.repository=bitnamilegacy/zookeeper \
    --set zookeeper.image.tag=3.9.2-debian-12-r16 \
    --set global.security.allowInsecureImages=true \
    -f values.yaml \
    --wait


  echo Installing kafka-ui
  helm -n $NS install kafka-ui kafka-ui/kafka-ui -f ui-values.yaml --wait --version $UI_CHART_VERSION

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
