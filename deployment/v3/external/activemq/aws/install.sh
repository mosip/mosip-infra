#!/bin/sh
NS=activemq
kubectl create ns $NS
kubectl label namespace $NS istio-injection=enabled --overwrite 
helm repo add mosip https://mosip.github.io/mosip-helm
helm repo update
helm -n $NS install activemq mosip/activemq-artemis -f values.yaml
