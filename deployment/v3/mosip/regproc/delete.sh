#!/bin/sh
# Uninstalls all Reg Proc helm charts
NS=regproc
while true; do
    read -p "Are you sure you want to delete ALL Regproc helm charts?(Y/n) " yn
    if [ $yn == "Y" ]
      then
        helm -n $NS delete regproc-salt
        helm -n $NS delete regproc-workflow
        helm -n $NS delete regproc-status 
        helm -n $NS delete regproc-camel 
        helm -n $NS delete regproc-pktserver 
        helm -n $NS delete regproc-group1
        helm -n $NS delete regproc-group2
        helm -n $NS delete regproc-group3
        helm -n $NS delete regproc-group4
        helm -n $NS delete regproc-group5
        helm -n $NS delete regproc-group6
        helm -n $NS delete regproc-group7
        helm -n $NS delete regproc-notifier 
        helm -n $NS delete regproc-reprocess 
        break
      else
        break
    fi
done
