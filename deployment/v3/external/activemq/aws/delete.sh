#!/bin/sh
# Uninstalls Activemq
NS=activemq
while true; do
    read -p "Are you sure you want to delete ActiveMQ helm chart? (Y/n) " yn
    if [ $yn == "Y" ]
      then
        helm -n $NS delete activemq
        break
      else
        break
    fi
done
