#!/bin/sh
# Installs all Regproc helm charts
NS=regproc
CHART_VERSION=1.2.0

echo Create namespace
kubectl create ns $NS 

echo Istio label 
kubectl label ns $NS istio-injection=enabled --overwrite
helm repo update

echo Copy configmaps
./copy_cm.sh

echo Running regproc-salt job
helm -n $NS install regproc-salt mosip/regproc-salt --version $CHART_VERSION

echo Installing regproc-workflow
helm -n $NS install regproc-workflow mosip/regproc-workflow --version $CHART_VERSION

echo Installing regproc-status
helm -n $NS install regproc-status mosip/regproc-status --version $CHART_VERSION

echo Installing regproc-camel
helm -n $NS install regproc-camel mosip/regproc-camel --version $CHART_VERSION

echo Installing regproc-pktserver
helm -n $NS install regproc-pktserver mosip/regproc-pktserver --version $CHART_VERSION

echo Installing group1
helm -n $NS install regproc-group1 mosip/regproc-group1 -f group1.yaml --version $CHART_VERSION

echo Installing group2
helm -n $NS install regproc-group2 mosip/regproc-group2  --version $CHART_VERSION

echo Installing group3 
helm -n $NS install regproc-group3 mosip/regproc-group3  --version $CHART_VERSION

echo Installing group4
helm -n $NS install regproc-group4 mosip/regproc-group4 --version $CHART_VERSION

echo Installing group5
helm -n $NS install regproc-group5 mosip/regproc-group5 --version $CHART_VERSION

echo Installing group6
helm -n $NS install regproc-group6 mosip/regproc-group6 --version $CHART_VERSION

echo Installing group7
helm -n $NS install regproc-group7 mosip/regproc-group7 --version $CHART_VERSION

echo Installing regproc-notifier
helm -n $NS install regproc-notifier mosip/regproc-notifier --version $CHART_VERSION

echo Installing regproc-reprocess
helm -n $NS install regproc-reprocess mosip/regproc-reprocess --version $CHART_VERSION


