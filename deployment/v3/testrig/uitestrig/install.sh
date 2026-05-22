#!/bin/bash
# Installs uitestrig automation
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=uitestrig
CHART_VERSION=1.6.0
COPY_UTIL=../copy_cm_func.sh

echo Create $NS namespace
kubectl create ns $NS

function installing_uitestrig() {
  ENV_NAME=$( kubectl -n default get cm global -o json |jq -r '.data."installation-domain"')

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
  echo "n: if you don't have public domain & valid ssl certificate"
  read -p "" flag

  if [ -z "$flag" ]; then
    echo "'flag' was provided; EXITING;"
    exit 1;
  fi
  ENABLE_INSECURE=''
  if [ "$flag" = "n" ]; then
    ENABLE_INSECURE='--set uitestrig.configmaps.uitestrig.ENABLE_INSECURE=true';
  fi

  read -p "Please enter the env url : " env
    if [ -z "$env" ]; then
       echo "ERROR: env url cannot be empty; EXITING;";
       exit 1;
    fi

  read -p "Please enter the injiWebUi url : " injiWebUi
    if [ -z "$injiWebUi" ]; then
       echo "ERROR: injiWebUi url cannot be empty; EXITING;";
       exit 1;
    fi

  read -p "Please enter the TEST_URL : " TEST_URL
    if [ -z "$TEST_URL" ]; then
       echo "ERROR: Test url cannot be empty; EXITING;";
       exit 1;
    fi

  read -p "Please enter the MOSIP_INJIWEB_GOOGLE_REFRESH_TOKEN : " token
    if [ -z "$token" ]; then
       echo "ERROR: Google Refresh Token cannot be empty; EXITING;";
       exit 1;
    fi

  read -p "Please enter the MOSIP_INJIWEB_GOOGLE_CLIENT_ID : " client_id
    if [ -z "$client_id" ]; then
       echo "ERROR: Google Client ID cannot be empty; EXITING;";
       exit 1;
    fi

  read -p "Please enter the MOSIP_INJIWEB_GOOGLE_CLIENT_SECRET : " secret
    if [ -z "$secret" ]; then
       echo "ERROR: Google client secret cannot be empty; EXITING;";
       exit 1;
    fi

  read -p "Please enter the BROWSERSTACK USERNAME : " User_name
    if [ -z "$User_name" ]; then
       echo "ERROR: BROWSERSTACK USERNAME cannot be empty; EXITING;";
       exit 1;
    fi

  read -p "Please enter the BROWSERSTACK ACCESS KEY : " Access_key
    if [ -z "$Access_key" ]; then
       echo "ERROR: BROWSERSTACK ACCESS KEY cannot be empty; EXITING;";
       exit 1;
    fi

    read -p "Please enter the Env user : " Env_user
      if [ -z "$Env_user" ]; then
         echo "ERROR: Env user cannot be empty; EXITING;";
         exit 1;
      fi

  echo Istio label
  kubectl label ns $NS istio-injection=disabled --overwrite
  helm repo update

  echo Copy configmaps
  $COPY_UTIL configmap global default $NS
  $COPY_UTIL configmap keycloak-host keycloak $NS
  $COPY_UTIL configmap artifactory-share artifactory $NS
  $COPY_UTIL configmap config-server-share config-server $NS

  echo Copy secrets
  $COPY_UTIL secret keycloak-client-secrets keycloak $NS
  $COPY_UTIL secret s3 s3 $NS
  $COPY_UTIL secret postgres-postgresql postgres $NS

  DB_HOST=$( kubectl -n default get cm global -o json  |jq -r '.data."mosip-api-internal-host"' )
  PMP_HOST=$(kubectl -n default get cm global -o json  |jq -r '.data."mosip-pmp-host"')
  ADMIN_HOST=$(kubectl -n default get cm global -o json  |jq -r '.data."mosip-admin-host"')
  RESIDENT_HOST=$(kubectl -n default get cm global -o json  |jq -r '.data."mosip-resident-host"')
  INJI_VERIFY_HOST=$(kubectl -n default get cm global -o json  |jq -r '.data."mosip-injiverify-host"')
  INJI_WEB_HOST=$(kubectl -n default get cm global -o json  |jq -r '.data."mosip-injiweb-host"')
  ESIGNET_HOST=$(kubectl -n default get cm global -o json  |jq -r '.data."mosip-esignet-host"')
  API_INTERNAL_HOST=$( kubectl -n default get cm global -o json  |jq -r '.data."mosip-api-internal-host"' )

  echo Installing uitestrig
  helm -n $NS install uitestrig mosip/uitestrig \
  --set crontime="0 $time * * *" \
  -f values.yaml  \
  --version $CHART_VERSION \
  --set uitestrig.configmaps.s3.s3-host='http://minio.minio:9000' \
  --set uitestrig.configmaps.s3.s3-user-key='admin' \
  --set uitestrig.configmaps.s3.s3-region='' \
  --set uitestrig.configmaps.db.db-server="$DB_HOST" \
  --set uitestrig.configmaps.db.db-su-user="postgres" \
  --set uitestrig.configmaps.db.db-port="5432" \
  --set uitestrig.configmaps.uitestrig.apiInternalEndPoint="https://$API_INTERNAL_HOST" \
  --set uitestrig.configmaps.uitestrig.apiEnvUser="$API_INTERNAL_HOST" \
  --set uitestrig.configmaps.uitestrig.PmpPortalPath="https://$PMP_HOST" \
  --set uitestrig.configmaps.uitestrig.adminPortalPath="https://$ADMIN_HOST" \
  --set uitestrig.configmaps.uitestrig.residentPortalPath="https://$RESIDENT_HOST" \
  --set uitestrig.configmaps.uitestrig.verifyPortalPath="https://$INJI_VERIFY_HOST/" \
  --set uitestrig.configmaps.uitestrig.NS="$NS" \
  --set uitestrig.configmaps.uitestrig.env="$env" \
  --set uitestrig.configmaps.uitestrig.injiWebUi="$injiWebUi" \
  --set uitestrig.configmaps.uitestrig.TEST_URL="$TEST_URL" \
  --set uitestrig.configmaps.uitestrig.mosip_components_base_urls="auditmanager=$API_INTERNAL_HOST;idrepository=$API_INTERNAL_HOST;partnermanager=$API_INTERNAL_HOST;idauthentication=$API_INTERNAL_HOST;policymanager=$API_INTERNAL_HOST;authmanager=$API_INTERNAL_HOST;resident=$API_INTERNAL_HOST;preregistration=$API_INTERNAL_HOST;masterdata=$API_INTERNAL_HOST;idgenerator=$API_INTERNAL_HOST;" \
  --set uitestrig.configmaps.uitestrig.mosip_inji_web_url="https://$INJI_WEB_HOST/" \
  --set uitestrig.configmaps.uitestrig.injiweb="https://$INJI_WEB_HOST/issuers" \
  --set uitestrig.configmaps.uitestrig.eSignetbaseurl="https://$ESIGNET_HOST" \
  --set uitestrig.configmaps.uitestrig.injiverify="https://$INJI_VERIFY_HOST/" \
  --set uitestrig.configmaps.uitestrig.ENV_ENDPOINT="https://$API_INTERNAL_HOST" \
  --set uitestrig.configmaps.uitestrig.ENV_USER="$Env_user" \
  --set uitestrig.configmaps.uitestrig.MOSIP_INJIWEB_GOOGLE_REFRESH_TOKEN="$token" \
  --set uitestrig.configmaps.uitestrig.MOSIP_INJIWEB_GOOGLE_CLIENT_ID="$client_id" \
  --set uitestrig.configmaps.uitestrig.MOSIP_INJIWEB_GOOGLE_CLIENT_SECRET="$secret" \
  --set uitestrig.configmaps.uitestrig.BROWSERSTACK_ACCESS_KEY="$Access_key" \
  --set uitestrig.configmaps.uitestrig.BROWSERSTACK_USERNAME="$User_name" \
  $ENABLE_INSECURE

  echo Installed uitestrig
  return 0
}

# set commands for error handling.
set -e
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errtrace  # trace ERR through 'time command' and other functions
set -o pipefail  # trace ERR through pipes
installing_uitestrig   # calling function