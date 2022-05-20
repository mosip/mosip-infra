#!/bin/sh
# Uninstalls all  compliance-toolkit helm charts
while true; do
    read -p "Are you sure you want to delete all compliance-toolkit helm charts?(Y/n) " yn
    if [ $yn = "Y" ]
      then
        helm -n compliance-toolkit delete compliance-toolkit-gateway
        helm -n $NS delete compliance-toolkit-ui compliance-toolkit
        break
      else
        break
    fi
done
