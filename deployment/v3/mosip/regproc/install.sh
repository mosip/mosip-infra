#!/bin/sh
# Installs all Regproc helm charts
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=regproc
CHART_VERSION=1.1.5

echo Create namespace
kubectl create ns $NS 

echo Istio label 
kubectl label ns $NS istio-injection=enabled --overwrite
helm repo update

echo Copy configmaps
./copy_cm.sh

echo Installing regproc-status
helm -n $NS install regproc-status mosip/regproc-status -f status-values.yaml --version $CHART_VERSION

echo Installing regproc-camel
helm -n $NS install regproc-camel mosip/regproc-camel -f camel-values.yaml --version $CHART_VERSION

echo Installing regproc-receiver
helm -n $NS install regproc-receiver mosip/regproc-receiver -f receiver_values.yaml --version $CHART_VERSION

echo Installing regproc-pktserver
helm -n $NS install regproc-pktserver mosip/regproc-pktserver -f pktserver-values.yaml --version $CHART_VERSION

echo Installing regproc-uploader
helm -n $NS install regproc-uploader mosip/regproc-uploader -f upload-values.yaml --version $CHART_VERSION

echo Installing regproc-validator
helm -n $NS install regproc-validator mosip/regproc-validator -f valid-values.yaml --version $CHART_VERSION

echo Installing regproc-quality
helm -n $NS install regproc-quality mosip/regproc-quality -f quality-values.yaml --version $CHART_VERSION

echo Installing regproc-osi
helm -n $NS install regproc-osi mosip/regproc-osi -f osi-values.yaml --version $CHART_VERSION

echo Installing regproc-demo
helm -n $NS install regproc-demo mosip/regproc-demo -f demo-values.yaml --version $CHART_VERSION

echo Installing regproc-biodedupe
helm -n $NS install regproc-biodedupe mosip/regproc-biodedupe -f biodedupe-values.yaml --version $CHART_VERSION

echo Installing regproc-abishandler
helm -n $NS install regproc-abishandler mosip/regproc-abishandler -f handler-values.yaml --version $CHART_VERSION

echo Installing regproc-abismid
helm -n $NS install regproc-abismid mosip/regproc-abismid -f middle-values.yaml --version $CHART_VERSION

echo Installing regproc-manual
helm -n $NS install regproc-manual mosip/regproc-manual -f manual-values.yaml --version $CHART_VERSION

echo Installing regproc-bioauth
helm -n $NS install regproc-bioauth mosip/regproc-bioauth -f bioauth-values.yaml --version $CHART_VERSION

echo Installing regproc-eis
helm -n $NS install regproc-eis mosip/regproc-eis -f eis-values.yaml --version $CHART_VERSION

echo Installing regproc-external
helm -n $NS install regproc-external mosip/regproc-external -f external-values.yaml --version $CHART_VERSION

echo Installing regproc-msg
helm -n $NS install regproc-msg mosip/regproc-msg -f msg-values.yaml --version $CHART_VERSION

echo Installing regproc-print
helm -n $NS install regproc-print mosip/regproc-print -f print-values.yaml --version $CHART_VERSION

echo Installing regproc-reprocess
helm -n $NS install regproc-reprocess mosip/regproc-reprocess -f reprocess-values.yaml --version $CHART_VERSION

echo Installing regproc-trans
helm -n $NS install regproc-trans mosip/regproc-trans -f trans-values.yaml --version $CHART_VERSION

echo Installing regproc-uin
helm -n $NS install regproc-uin mosip/regproc-uin -f uin-values.yaml --version $CHART_VERSION

