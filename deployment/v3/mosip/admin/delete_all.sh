#!/bin/sh
# Uninstalls all Kernel helm charts 
while true; do
    read -p "Are you sure you want to delete ALL Admin helm charts? Y/n ?" yn
    if [[ $yn == "Y" ]]
      then
        helm -n admin delete admin-ui
        helm -n admin delete admin-service
        break
      else
        break
    fi
done
