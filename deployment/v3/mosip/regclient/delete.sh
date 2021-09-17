#!/bin/sh
# Uninstalls Regclient downloader
NS=regclient
while true; do
    read -p "Are you sure you want to delete regclient helm chart?(Y/n) " yn
    if [ $yn == "Y" ]
      then
        helm -n $NS delete regclient
        break
      else
        break
    fi
done
