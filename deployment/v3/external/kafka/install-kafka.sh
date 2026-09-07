#!/bin/bash
set -e

NAMESPACE=kafka

echo "Creating namespace..."
kubectl create namespace ${NAMESPACE} --dry-run=client -o yaml | kubectl apply -f -

echo "Installing Strimzi Operator..."
helm upgrade --install strimzi \
  oci://quay.io/strimzi-helm/strimzi-kafka-operator \
  --version 0.50.1 \
  --namespace ${NAMESPACE} \
  --create-namespace \
  --wait

echo "Waiting for Strimzi Operator..."
kubectl rollout status deployment/strimzi-cluster-operator -n ${NAMESPACE}

echo "Creating Controller NodePool..."
kubectl apply -f controller-nodepool.yaml -n ${NAMESPACE}

echo "Creating Broker NodePool..."
kubectl apply -f broker-nodepool.yaml -n ${NAMESPACE}

echo "Creating Kafka Cluster..."
kubectl apply -f kafka.yaml -n ${NAMESPACE}

echo "Waiting for Kafka cluster..."
kubectl wait kafka/kafka \
    --for=condition=Ready \
    --timeout=10m \
    -n ${NAMESPACE}

echo
echo "Kafka Bootstrap Server:"
kubectl get svc kafka-kafka-bootstrap -n ${NAMESPACE}

echo
echo "Kafka Pods:"
kubectl get pods -n ${NAMESPACE}

echo
echo "Kafka Cluster Ready!"
