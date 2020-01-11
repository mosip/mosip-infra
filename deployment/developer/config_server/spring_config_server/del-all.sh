#!/bin/sh
# Steps to delete all isntances of config-server on Minikube.
kubectl delete deployment config-server
kubectl delete pods --force  --grace-period=0 --all --namespace=default
kubectl delete svc config-server 
