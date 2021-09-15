#!/bin/bash
# Uninstalls softhsm
NS=keymanager
while true; do
    read -p "Are you sure you want to delete Softhsm Kernel helm charts? Y/n ?" yn
    if [[ $yn == "Y" ]]
      then
        helm -n $NS delete softhsm-kernel
        break
      else
        break
    fi
done
