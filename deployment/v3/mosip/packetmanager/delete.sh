#!/bin/sh
# Uninstalls packetmanager
NS=packetmanager
while true; do
    read -p "Are you sure you want to delete packetmanager helm chart?(Y/n) " yn
    if [ $yn = "Y" ]
      then
        helm -n $NS delete packetmanager
        break
      else
        break
    fi
done
