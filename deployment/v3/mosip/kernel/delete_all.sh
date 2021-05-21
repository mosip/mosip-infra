#!/bin/sh
# Uninstalls all Kernel helm charts 
while true; do
    read -p "Are you sure you want to delete ALL Kernel helm charts? Y/n ?" yn
    if [[ $yn == "Y" ]]
      then
        helm -n keymanager delete keymanager
        helm -n kernel delete auditmanager
        helm -n kernel delete authmanager
        helm -n kernel delete idgenerator 
        helm -n kernel delete masterdata
        helm -n kernel delete otpmanager
        helm -n kernel delete pridgenerator
        helm -n kernel delete ridgenerator
        helm -n kernel delete syncdata
        break
      else
        break
    fi
done
