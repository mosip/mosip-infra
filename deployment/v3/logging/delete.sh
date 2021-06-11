#!/bin/sh
# Uninstalls all logging helm charts
NS=logging
while true; do
    read -p "Are you sure you want to delete ALL logging helm charts?(Y/n) " yn
    if [[ $yn == "Y" ]]
      then
        helm -n $NS delete elasticsearch
        helm -n $NS delete mykibana
        break
      else
        break
    fi
done
