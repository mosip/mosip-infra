#!/bin/sh
# Installs packetcreator
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=packetcreator
CHART_VERSION=12.0.2

read -p "Provide the allowed origin list separated by comma : " originList;

list='';
i=0;
originList=$( echo "$originList" | sed 's/,/ /g');
for origin in $originList; do
  list="$list --set istio.corsPolicy.allowOrigins[$i].prefix=$origin ";
  i=$(( i+1 ));
done

echo Create $NS namespace
kubectl create ns $NS

echo Istio label
kubectl label ns $NS istio-injection=enabled --overwrite
helm repo update

echo Installing packetcreator
helm -n $NS install packetcreator mosip/packetcreator $( echo $list ) --wait --version $CHART_VERSION
echo Installed packetcreator.

