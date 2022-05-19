#!/bin/sh
# Uninstalls all  mosip-compliance-toolkit helm charts
while true; do
    read -p "Are you sure you want to delete all mosip-compliance-toolkit helm charts?(Y/n) " yn
    if [ $yn = "Y" ]
      then
        helm -n mosip-compliance-toolkit delete mosip-compliance-toolkit-gateway
        helm -n $NS delete mosip-compliance-toolkit-ui
        break
      else
        break
    fi
done
