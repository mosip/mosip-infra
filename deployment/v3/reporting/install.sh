#!/bin/sh
## This script install all required components for reporting framework.

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

## Variables
NS=reporting
CHART_VERSION=1.2.0

# Add helm repos
echo "Adding helm repos"
helm repo add mosip https://mosip.github.io/mosip-helm
helm repo update

# Creating namespace with istio-injeciton
echo "Creating namespace"
kubectl create ns $NS
kubectl label ns $NS istio-injection=enabled

## Configure Postgres essentials
# Assumed Postgres is installed in 'postgres' namespace with extended.conf as extended config.

echo "Copying secrets"
./copy_secret.sh $NS

echo "Installing reporting helm"
helm -n $NS install reporting mosip/reporting -f values.yaml --wait --version $CHART_VERSION

echo "Waiting for helm chart to install"
sleep 30s

echo "Installing reporting-init helm"
helm -n $NS install reporting-init mosip/reporting-init -f values-init.yaml --wait --version $CHART_VERSION
