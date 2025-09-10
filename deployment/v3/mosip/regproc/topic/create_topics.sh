#!/bin/bash
#

function create_topics() {
  read -p "Enter IAM username: " iam_user

  # This username is hardcoded in sql scripts
  DB_PWD=$(kubectl get secret --namespace postgres db-common-secrets -o jsonpath={.data.db-dbuser-password} | base64 --decode)
  DB_HOST=$(kubectl get cm global -o jsonpath={.data.mosip-api-internal-host})
  DB_PORT=5432

  echo Creating topics
  cd lib
  python3 create_topics.py $DB_HOST $DB_PWD $iam_user ../topics.xlsx
return 0
}

# set commands for error handling.
set -e
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errtrace  # trace ERR through 'time command' and other functions
set -o pipefail  # trace ERR through pipes
create_topics   # calling function
