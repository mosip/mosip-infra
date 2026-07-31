#!/bin/bash
# Installs uitestrig automation
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=uitestrig
CHART_VERSION=1.6.0

echo Create $NS namespace
kubectl create ns $NS

function prompt_or_env() {
  # usage: prompt_or_env VAR_NAME "Prompt text" [sensitive]
  # Do not name locals after caller variables (e.g. avoid local secret=...) —
  # printf -v would otherwise write the local and leave the global unset under set -u.
  local var_name="$1"
  local prompt_text="$2"
  local is_sensitive="${3:-}"
  local current=""

  if [ -n "${!var_name+x}" ]; then
    current="${!var_name}"
  fi
  if [ -n "$current" ]; then
    return 0
  fi
  if [ "$is_sensitive" = "sensitive" ]; then
    read -r -s -p "$prompt_text" current
    echo
  else
    read -r -p "$prompt_text" current
  fi
  # Assign in caller scope via nameref when available, else eval-safe printf -v
  printf -v "$var_name" '%s' "$current"
}

function installing_uitestrig() {
  prompt_or_env time "Please enter the time(hr) to run the cronjob every day (time: 0-23) : "
  if [ -z "${time:-}" ]; then
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

  if [ -z "${flag:-}" ]; then
    echo "Do you have public domain & valid SSL? (Y/n) "
    echo "Y: if you have public domain & valid ssl certificate"
    echo "n: if you don't have public domain & valid ssl certificate"
    read -p "" flag
  fi

  if [ -z "${flag:-}" ]; then
    echo "'flag' was provided; EXITING;"
    exit 1;
  fi
  ENABLE_INSECURE=''
  if [ "$flag" = "n" ]; then
    ENABLE_INSECURE='--set uitestrig.configmaps.uitestrig.ENABLE_INSECURE=true'
  fi

  prompt_or_env env "Please enter the env url : "
    if [ -z "${env:-}" ]; then
       echo "ERROR: env url cannot be empty; EXITING;";
       exit 1;
    fi

  prompt_or_env injiWebUi "Please enter the injiWebUi url : "
    if [ -z "${injiWebUi:-}" ]; then
       echo "ERROR: injiWebUi url cannot be empty; EXITING;";
       exit 1;
    fi

  prompt_or_env TEST_URL "Please enter the TEST_URL : "
    if [ -z "${TEST_URL:-}" ]; then
       echo "ERROR: Test url cannot be empty; EXITING;";
       exit 1;
    fi

  prompt_or_env token "Please enter the MOSIP_INJIWEB_GOOGLE_REFRESH_TOKEN : " sensitive
    if [ -z "${token:-}" ]; then
       echo "ERROR: Google Refresh Token cannot be empty; EXITING;";
       exit 1;
    fi

  prompt_or_env client_id "Please enter the MOSIP_INJIWEB_GOOGLE_CLIENT_ID : "
    if [ -z "${client_id:-}" ]; then
       echo "ERROR: Google Client ID cannot be empty; EXITING;";
       exit 1;
    fi

  prompt_or_env google_client_secret "Please enter the MOSIP_INJIWEB_GOOGLE_CLIENT_SECRET : " sensitive
    if [ -z "${google_client_secret:-}" ]; then
       echo "ERROR: Google client secret cannot be empty; EXITING;";
       exit 1;
    fi

  prompt_or_env User_name "Please enter the BROWSERSTACK USERNAME : "
    if [ -z "${User_name:-}" ]; then
       echo "ERROR: BROWSERSTACK USERNAME cannot be empty; EXITING;";
       exit 1;
    fi

  prompt_or_env Access_key "Please enter the BROWSERSTACK ACCESS KEY : " sensitive
    if [ -z "${Access_key:-}" ]; then
       echo "ERROR: BROWSERSTACK ACCESS KEY cannot be empty; EXITING;";
       exit 1;
    fi

  prompt_or_env Env_user "Please enter the Env user : "
      if [ -z "${Env_user:-}" ]; then
         echo "ERROR: Env user cannot be empty; EXITING;";
         exit 1;
      fi

  echo Istio label
  kubectl label ns $NS istio-injection=disabled --overwrite
  helm repo add mosip https://mosip.github.io/mosip-helm 2>/dev/null || true
  helm repo update

  echo Copy configmaps
  ./copy_cm.sh

  echo Copy secrets
  ./copy_secrets.sh

  echo "Delete s3, db, & uitestrig configmap if exists"
  kubectl -n $NS delete --ignore-not-found=true configmap s3
  kubectl -n $NS delete --ignore-not-found=true configmap db
  kubectl -n $NS delete --ignore-not-found=true configmap uitestrig

  DB_HOST=$( kubectl -n default get cm global -o json  |jq -r '.data."mosip-api-internal-host"' )

  if [ -z "${db_port:-}" ]; then
    read -p "Please enter the DB port (press Enter to use default 5432, or enter custom port for external PostgreSQL) : " db_port
  fi
  if [ -z "$db_port" ]; then
    db_port=5432
  fi
  if ! [[ "$db_port" =~ ^[0-9]+$ ]] || [ "$db_port" -lt 1 ] || [ "$db_port" -gt 65535 ]; then
    echo "ERROR: Invalid port '$db_port'. Must be a number between 1 and 65535; EXITING;"
    exit 1
  fi

  PMP_HOST=$(kubectl -n default get cm global -o json  |jq -r '.data."mosip-pmp-host"')
  ADMIN_HOST=$(kubectl -n default get cm global -o json  |jq -r '.data."mosip-admin-host"')
  RESIDENT_HOST=$(kubectl -n default get cm global -o json  |jq -r '.data."mosip-resident-host"')
  INJI_VERIFY_HOST=$(kubectl -n default get cm global -o json  |jq -r '.data."mosip-injiverify-host"')
  INJI_WEB_HOST=$(kubectl -n default get cm global -o json  |jq -r '.data."mosip-injiweb-host"')
  ESIGNET_HOST=$(kubectl -n default get cm global -o json  |jq -r '.data."mosip-esignet-host"')
  API_INTERNAL_HOST=$( kubectl -n default get cm global -o json  |jq -r '.data."mosip-api-internal-host"' )

  # Fall back to conventional hostnames when optional global keys are absent
  INSTALLATION_DOMAIN=$(kubectl -n default get cm global -o json | jq -r '.data."installation-domain"')
  if [ -z "$INJI_VERIFY_HOST" ] || [ "$INJI_VERIFY_HOST" = "null" ]; then
    INJI_VERIFY_HOST="injiverify.${INSTALLATION_DOMAIN}"
  fi
  if [ -z "$INJI_WEB_HOST" ] || [ "$INJI_WEB_HOST" = "null" ]; then
    INJI_WEB_HOST="injiweb.${INSTALLATION_DOMAIN}"
  fi

  echo Installing uitestrig
  helm -n $NS upgrade --install uitestrig mosip/uitestrig \
  --set crontime="0 $time * * *" \
  -f values.yaml  \
  --version $CHART_VERSION \
  --set uitestrig.configmaps.s3.s3-host='http://minio.minio:9000' \
  --set uitestrig.configmaps.s3.s3-user-key='admin' \
  --set uitestrig.configmaps.s3.s3-region='' \
  --set uitestrig.configmaps.db.db-server="$DB_HOST" \
  --set uitestrig.configmaps.db.db-su-user="postgres" \
  --set uitestrig.configmaps.db.db-port="$db_port" \
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