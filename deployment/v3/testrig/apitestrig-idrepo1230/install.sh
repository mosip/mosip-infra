#!/bin/bash
# Installs idrepo-only apitestrig (image tag 1.2.3.0) against api-internal,
# which should already be retargeted to idrepo1230 via ./retarget-vs.sh
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

# Use a dedicated namespace so the existing apitestrig install is not disturbed.
# Shared CM names (s3, db, apitestrig) would otherwise be deleted/overwritten.
NS=${NS:-apitestrig1230}
RELEASE_NAME=idrepo-apitestrig
CHART_VERSION=1.5.0

echo Create $NS namespace
kubectl create ns $NS 2>/dev/null || true
export NS

function installing_apitestrig() {
  echo Istio label
  kubectl label ns $NS istio-injection=disabled --overwrite

  helm repo update

  echo Copy configmaps
  ./copy_cm.sh

  echo Copy secrets
  ./copy_secrets.sh

  echo "Delete s3, db, & apitestrig configmap if exists"
  kubectl -n $NS delete --ignore-not-found=true configmap s3
  kubectl -n $NS delete --ignore-not-found=true configmap db
  kubectl -n $NS delete --ignore-not-found=true configmap apitestrig

  API_INTERNAL_HOST=$( kubectl -n default get cm global -o json  | jq -r '.data."mosip-api-internal-host"' )
  DB_HOST=$API_INTERNAL_HOST
  ENV_USER=$( kubectl -n default get cm global -o json | jq -r '.data."mosip-api-internal-host"' | awk -F '.' '/api-internal/{print $1"."$2}')

  echo "Target ENV_ENDPOINT will be: https://$API_INTERNAL_HOST"
  echo "Ensure idrepo routes on this host already point to idrepo1230 (run ./retarget-vs.sh first)."

  read -p "Please enter the time(hr) to run the cronjob every day (time: 0-23) : " time
  if [ -z "$time" ]; then
     echo "ERROR: Time cannot be empty; EXITING;";
     exit 1;
  fi
  if ! [ $time -eq $time ] 2>/dev/null; then
     echo "ERROR: Time $time is not a number; EXITING;";
     exit 1;
  fi
  if [ $time -gt 23 ] || [ $time -lt 0 ] ; then
     echo "ERROR: Time should be in range ( 0-23 ); EXITING;";
     exit 1;
  fi

  echo "Do you have public domain & valid SSL? (Y/n) "
  echo "Y: if you have public domain & valid ssl certificate"
  echo "n: If you don't have a public domain and a valid SSL certificate. Note: It is recommended to use this option only in development environments."
  read -p "" flag

  if [ -z "$flag" ]; then
    echo "'flag' was provided; EXITING;"
    exit 1;
  fi
  ENABLE_INSECURE=''
  if [ "$flag" = "n" ]; then
    ENABLE_INSECURE='--set enable_insecure=true';
  fi

  read -p "Please provide the retention days to remove old reports ( Default: 3 )" reportExpirationInDays

  if [[ -z $reportExpirationInDays ]]; then
    reportExpirationInDays=3
  fi
  if ! [[ $reportExpirationInDays =~ ^[0-9]+$ ]]; then
    echo "The variable \"reportExpirationInDays\" should contain only number; EXITING";
    exit 1;
  fi

  read -p "Please provide slack webhook URL to notify server end issues on your slack channel : " slackWebhookUrl

  if [ -z "$slackWebhookUrl" ]; then
    echo "slack webhook URL not provided; EXITING;"
    exit 1;
  fi

  valid_inputs=("yes" "no")
  eSignetDeployed=""

  while [[ ! " ${valid_inputs[*]} " =~ " ${eSignetDeployed} " ]]; do
      read -p "Is the eSignet service deployed? (yes/no): " eSignetDeployed
      eSignetDeployed=${eSignetDeployed,,}
  done

  if [[ $eSignetDeployed == "yes" ]]; then
      echo "eSignet service is deployed. Proceeding with installation..."
  else
      echo "eSignet service is not deployed. hence will be skipping esignet related test-cases..."
  fi

  # Uninstall previous release of the same name if present
  if helm -n $NS status $RELEASE_NAME >/dev/null 2>&1; then
    echo "Existing release $RELEASE_NAME found; upgrading..."
    HELM_CMD=upgrade
  else
    HELM_CMD=install
  fi

  echo "Installing/upgrading idrepo apitestrig (image mosipid/apitest-idrepo:1.2.3.0)"
  helm -n $NS $HELM_CMD $RELEASE_NAME mosip/apitestrig \
  --set crontime="0 $time * * *" \
  -f values.yaml \
  --version $CHART_VERSION \
  --set apitestrig.configmaps.s3.s3-host='http://minio.minio:9000' \
  --set apitestrig.configmaps.s3.s3-user-key='admin' \
  --set apitestrig.configmaps.s3.s3-region='' \
  --set apitestrig.configmaps.db.db-server="$DB_HOST" \
  --set apitestrig.configmaps.db.db-su-user="postgres" \
  --set apitestrig.configmaps.db.db-port="5432" \
  --set apitestrig.configmaps.apitestrig.ENV_USER="$ENV_USER" \
  --set apitestrig.configmaps.apitestrig.ENV_ENDPOINT="https://$API_INTERNAL_HOST" \
  --set apitestrig.configmaps.apitestrig.ENV_TESTLEVEL="smokeAndRegression" \
  --set apitestrig.configmaps.apitestrig.reportExpirationInDays="$reportExpirationInDays" \
  --set apitestrig.configmaps.apitestrig.slack-webhook-url="$slackWebhookUrl" \
  --set apitestrig.configmaps.apitestrig.eSignetDeployed="$eSignetDeployed" \
  --set apitestrig.configmaps.apitestrig.NS="$NS" \
  $ENABLE_INSECURE

  echo Installed $RELEASE_NAME.
  echo
  echo "  kubectl -n $NS create job --from=cronjob/cronjob-${RELEASE_NAME}-idrepo idrepo-apitestrig-manual-\$(date +%s)"
  return 0
}

set -e
set -o errexit
set -o nounset
set -o errtrace
set -o pipefail
installing_apitestrig
