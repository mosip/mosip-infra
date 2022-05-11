#!/bin/sh
# Uninstalls all prereg helm charts
while true; do
    read -p "Are you sure you want to delete all mosip-compliance-toolkit helm charts?(Y/n) " yn
    if [ $yn = "Y" ]
      then
        helm -n mosip-compliance-toolkit delete mosip-compliance-toolkit-gateway
        break
      else
        break
    fi
done