#!/bin/sh
# Installs resident service
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=resident
CHART_VERSION=12.0.2

echo Create $NS namespace
kubectl create ns $NS

echo Istio label
kubectl label ns $NS istio-injection=enabled --overwrite
helm repo update

echo Copy configmaps
./copy_cm.sh

echo Copy secrets
./copy_secrets.sh

API_HOST=$(kubectl get cm global -o jsonpath={.data.mosip-api-internal-host})
RESIDENT_HOST=$(kubectl get cm global -o jsonpath={.data.mosip-resident-host})

echo Installing Resident
helm -n $NS install resident mosip/resident --set istio.corsPolicy.allowOrigins\[0\].prefix=$RESIDENT_HOST --set "extraEnvVarsCM={"global","config-server-share","artifactory-share-develop"}" --version $CHART_VERSION

echo Installing Resident UI
helm -n $NS install resident-ui mosip/resident-ui --set resident.apiHost=$API_HOST --set istio.hosts\[0\]=$RESIDENT_HOST --version $CHART_VERSION

kubectl -n $NS  get deploy -o name |  xargs -n1 -t  kubectl -n $NS rollout status

echo Installed Resident services
echo Installed Resident UI

echo "resident-ui portal URL: https://$RESIDENT_HOST/"
