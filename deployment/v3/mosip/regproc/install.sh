#!/bin/bash
# Installs all regproc helm charts
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=regproc
CHART_VERSION=12.0.2

echo Create $NS namespace
kubectl create ns $NS

function installing_regproc() {
  echo Istio label
  kubectl label ns $NS istio-injection=enabled --overwrite
  helm repo update

  echo Copy configmaps
  sed -i 's/\r$//' copy_cm.sh
  ./copy_cm.sh

  echo Running regproc-salt job
  helm -n $NS install regproc-salt mosip/regproc-salt --set image.repository=mosipdev/kernel-salt-generator  --version $CHART_VERSION

  echo Installing regproc-workflow
  helm -n $NS install regproc-workflow mosip/regproc-workflow --set image.repository=mosipdev/registration-processor-workflow-manager-service  --version $CHART_VERSION

  echo Installing regproc-status
  helm -n $NS install regproc-status mosip/regproc-status --set image.repository=mosipdev/registration-processor-registration-status-service  --version $CHART_VERSION

  echo Installing regproc-camel
  helm -n $NS install regproc-camel mosip/regproc-camel --set image.repository=mosipdev/registration-processor-common-camel-bridge  --version $CHART_VERSION

  echo Installing regproc-pktserver
  helm -n $NS install regproc-pktserver mosip/regproc-pktserver --set image.repository=mosipdev/registration-processor-dmz-packet-server  --version $CHART_VERSION

  echo Installing group1
  helm -n $NS install regproc-group1 mosip/regproc-group1 -f group1_values.yaml --set image.repository=mosipdev/registration-processor-stage-group-1  --version $CHART_VERSION

  echo Installing group2
  helm -n $NS install regproc-group2 mosip/regproc-group2 --set image.repository=mosipdev/registration-processor-stage-group-2 --version $CHART_VERSION

  echo Installing group3
  helm -n $NS install regproc-group3 mosip/regproc-group3 --set image.repository=mosipdev/registration-processor-stage-group-3 --version $CHART_VERSION

  echo Installing group4
  helm -n $NS install regproc-group4 mosip/regproc-group4 --set image.repository=mosipdev/registration-processor-stage-group-4 --version $CHART_VERSION

  echo Installing group5
  helm -n $NS install regproc-group5 mosip/regproc-group5 --set image.repository=mosipdev/registration-processor-stage-group-5 --version $CHART_VERSION

  echo Installing group6
  helm -n $NS install regproc-group6 mosip/regproc-group6 --set image.repository=mosipdev/registration-processor-stage-group-6 --version $CHART_VERSION

  echo Installing group7
  helm -n $NS install regproc-group7 mosip/regproc-group7 --set image.repository=mosipdev/registration-processor-stage-group-7 --version $CHART_VERSION

  echo Installing regproc-trans
  helm -n $NS install regproc-trans mosip/regproc-trans --set image.repository=mosipdev/registration-processor-registration-transaction-service --version $CHART_VERSION

  echo Installing regproc-notifier
  helm -n $NS install regproc-notifier mosip/regproc-notifier --set image.repository=mosipdev/registration-processor-notification-service --version $CHART_VERSION

  echo Installing regproc-reprocess
  helm -n $NS install regproc-reprocess mosip/regproc-reprocess --set image.repository=mosipdev/registration-processor-reprocessor --version $CHART_VERSION

  echo Installing regproc-landingzoneutility
  helm -n $NS install regproc-landingzoneutility mosip/regproc-landingzoneutility --set image.repository=mosipdev/registration-processor-landing-zone-utility --version $CHART_VERSION

  kubectl -n $NS  get deploy -o name |  xargs -n1 -t  kubectl -n $NS rollout status

  echo Installed regproc services
  return 0
}

# set commands for error handling.
set -e
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errtrace  # trace ERR through 'time command' and other functions
set -o pipefail  # trace ERR through pipes
installing_regproc   # calling function
