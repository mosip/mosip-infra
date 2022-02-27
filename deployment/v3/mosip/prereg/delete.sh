#!/bin/sh
# Uninstalls all Prereg helm charts
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

while true; do
    read -p "Are you sure you want to delete prereg helm chart?(Y/n) " yn
    if [ $yn = "Y" ]
      then
        kubectl -n prereg delete -f rate-control-envoyfilter.yaml
        helm -n prereg delete prereg-gateway
        helm -n prereg delete prereg-application
        helm -n prereg delete prereg-batchjob
        helm -n prereg delete prereg-booking
        helm -n prereg delete prereg-datasync
        helm -n prereg delete prereg-ui
        break
      else
        break
    fi
done
