#!/bin/sh
# Installs the Admin module
# Make sure you have updated ui_values.yaml
NS=admin
echo Helm update
helm repo update

echo Creating namespace
kubectl create ns $NS 

while true; do
  read -p "Have you updated ui_values.yaml Y/n ?" yn
  if [[ $yn == "Y" ]]
    then
      echo Installing admin service. Will wait till service gets installed.
      helm -n $NS install admin-service mosip/admin-service --wait

      echo 'Installing admin-ui'
      helm -n $NS install admin-ui mosip/admin-ui -f ui_values.yaml
    else
      break
  fi
done

