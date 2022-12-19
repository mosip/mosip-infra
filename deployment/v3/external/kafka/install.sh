#!/bin/sh
# Installs kafka
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=kafka

echo Create $NS namespace
kubectl create ns $NS

echo Istio label
kubectl label ns $NS istio-injection=enabled --overwrite

echo Updating helm repos
helm repo add kafka-ui https://provectus.github.io/kafka-ui
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

echo Installing kafka
helm -n $NS install kafka bitnami/kafka -f values.yaml --wait --version 18.3.1

echo Installing kafka-ui
helm -n $NS install kafka-ui kafka-ui/kafka-ui -f ui-values.yaml --wait

KAFKA_UI_HOST=$(kubectl get cm global -o jsonpath={.data.mosip-kafka-host})
KAFKA_UI_NAME=kafka-ui

echo Install istio addons
helm -n $NS install istio-addons chart/istio-addons --set kafkaUiHost=$KAFKA_UI_HOST --set installName=$KAFKA_UI_NAME

Echo Installed kafka and kafka-ui services
