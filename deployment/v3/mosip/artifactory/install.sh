#!/bin/sh
# Installs artifactory
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=artifactory
CHART_VERSION=12.0.1

echo Create $NS namespace
kubectl create ns $NS 

echo Istio label 
kubectl label ns $NS istio-injection=enabled --overwrite
helm repo update

echo Installing artifactory
helm -n $NS install artifactory mosip/artifactory --version $CHART_VERSION 

kubectl -n $NS  get deploy -o name |  xargs -n1 -t  kubectl -n $NS rollout status

echo Installed artifactory service

echo Copy configmaps
./copy_cm.sh

echo Copied artifactory share as artifactory-share-develop

kubectl patch cm -n $NS artifactory-share-develop --type merge -p '{"data":{"iam_adapter_url_env":"http://artifactory.artifactory:80/artifactory/libs-release-local/io/mosip/kernel/develop/kernel-auth-adapter.jar"}}'

echo Updating the artifactory-share-develop configmap to point to develop jar for iam_adapter_url_env
