#!/bin/sh
# Installs the Admin module
# Make sure you have updated ui_values.yaml
NS=admin
echo Copy configmaps
./copy_cm.sh

echo Create namespace
kubectl create ns $NS

echo Istio label 
kubectl label ns $NS istio-injection=enabled --overwrite
helm repo update

while true; do
  read -p "Have you created/updated ui_values.yaml Y/n ?" yn
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

