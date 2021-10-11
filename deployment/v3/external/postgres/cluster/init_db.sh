#!/bin/sh
# Script to initialize the DB. 
## Usage: ./init_db.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=postgres
CHART_VERSION=1.2.0
helm repo update
while true; do
    read -p "CAUTION: all existing data will be lost. Are you sure?(Y/n)" yn
    if [ $yn == "Y" ]
      then
        echo Removing any existing installation
        helm -n $NS delete postgres-init
        echo Initializing DB
        helm -n $NS install postgres-init mosip/postgres-init -f init_values.yaml --version $CHART_VERSION --wait --wait-for-jobs
        break
      else
        break
    fi
done
