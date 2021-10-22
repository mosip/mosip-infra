#!/bin/sh
# Uninstalls all Prereg helm charts
while true; do
    read -p "Are you sure you want to delete ALL Prereg helm charts?(Y/n) " yn
    if [ $yn = "Y" ]
      then
        kubectl -n prereg delete -f rate-control-envoyfilter.yaml
        helm -n prereg delete prereg-gateway
        helm -n prereg delete prereg-captcha
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
