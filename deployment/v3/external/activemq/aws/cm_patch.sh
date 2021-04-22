#!/bin/sh
# Update activemq host  This is needed as host value is assigned by internal load balancer after activemq is
# installed 

ACTIVEMQ_HOST=$(kubectl -n activemq get svc activemq-activemq-artemis -o "jsonpath={.status.loadBalancer.ingress[0].hostname}")
echo $ACTIVEMQ_HOST
kubectl -n activemq  create configmap activemq-activemq-artemis-share --from-literal=activemq-host=$ACTIVEMQ_HOST --dry-run=client -o yaml | kubectl apply -f -
