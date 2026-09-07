#!/bin/bash

NAMESPACE=kafka

echo "Deleting Kafka Cluster..."
kubectl delete -f kafka.yaml -n ${NAMESPACE} --ignore-not-found=true

echo "Deleting Broker NodePool..."
kubectl delete -f broker-nodepool.yaml -n ${NAMESPACE} --ignore-not-found=true

echo "Deleting Controller NodePool..."
kubectl delete -f controller-nodepool.yaml -n ${NAMESPACE} --ignore-not-found=true

echo "Uninstalling Strimzi Operator..."
helm uninstall strimzi -n ${NAMESPACE} || true

echo
echo "Note: Persistent Volume Claims (PVCs) created for Kafka storage are not deleted automatically."
echo "If you want to completely clear the storage data, run:"
echo "  kubectl delete pvc -l strimzi.io/cluster=kafka -n ${NAMESPACE}"
echo

echo "Kafka deletion script finished!"
