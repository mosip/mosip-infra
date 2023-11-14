#!/bin/bash
# Installs data-archive
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=data-archive
CHART_VERSION=1.0.0

echo Create $NS namespace
kubectl create ns $NS

function installing_data-archive() {
  read -p "Is values.yaml for data-archive chart set correctly as part of Pre-requisites?(Y/n) " yn;
  if [ "$yn" != "Y" ]; then
    echo "ERROR: values.yaml not set correctly; EXITING;";
    exit 1;
  fi
  helm repo update

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

  read -p "Is archival running for sandbox installation? (Y/N): " archival_running
  if [ "$archival_running" == "Y" ]; then
    echo "Using super user postgres secrets to create archivedb "
    super_user_password=$(kubectl get secret --namespace postgres postgres-postgresql -o jsonpath={.data.postgres-password} | base64 --decode)
    echo "Using common secrets as password for all the db users"
    db_common_password=$(kubectl get secret --namespace postgres db-common-secrets -o jsonpath={.data.db-dbuser-password} | base64 --decode)
    echo Installing data-archive
    helm -n $NS install data-archive mosip/data-archive \
      --set crontime="0 $time * * *" \
      --set databases.archive_db.su_user_pwd=$super_user_password \
      --set databases.source_db.source_audit_db_pass=$db_common_password \
      --set databases.source_db.source_credential_db_pass=$db_common_password \
      --set databases.source_db.source_esignet_db_pass=$db_common_password \
      --set databases.source_db.source_ida_db_pass=$db_common_password \
      --set databases.source_db.source_idrepo_db_pass=$db_common_password \
      --set databases.source_db.source_kernel_db_pass=$db_common_password \
      --set databases.source_db.source_master_db_pass=$db_common_password \
      --set databases.source_db.source_pms_db_pass=$db_common_password \
      --set databases.source_db.source_regprc_db_pass=$db_common_password \
      --set databases.source_db.source_resident_db_pass=$db_common_password \
      --set databases.archive_db.db_pwd=$db_common_password \
      --set databases.archive_db.archive_db_password=$db_common_password \
      -f values.yaml \
      --version $CHART_VERSION
  elif [ "$archival_running" == "N" ]; then
    echo "Using individual secrets for db passwords"
    helm -n $NS install data-archive mosip/data-archive  --set crontime="0 $time * * *" -f values.yaml --version $CHART_VERSION
  else
    echo "Incorrect input; EXITING;"
    exit 1;
  fi

  echo Installed data-archive
  return 0
}

# set commands for error handling.
set -e
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errtrace  # trace ERR through 'time command' and other functions
set -o pipefail  # trace ERR through pipes
installing_data-archive  # calling function
