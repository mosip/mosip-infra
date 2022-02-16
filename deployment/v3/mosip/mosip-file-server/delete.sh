#!/bin/sh
# Uninstalls Regclient downloader
NS=mosip-file-server
while true; do
    read -p "Are you sure you want to delete mosip-file-server helm chart?(Y/n) " yn
    if [ $yn = "Y" ]
      then
        helm -n $NS delete mosip-file-server
        break
      else
        break
    fi
done
