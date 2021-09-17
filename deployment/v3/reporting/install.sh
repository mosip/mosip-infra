#!/bin/sh
## This script install all required components for reporting framework.

## Variables
NS=reporting

# Add helm repos
helm repo add mosip https://mosip.github.io/mosip-helm
helm repo update

# Creating namespace with istio-injeciton
kubectl create ns $NS
kubectl label ns $NS istio-injection=enabled

## Configure Postgres essentials
# Assumed Postgres is installed in 'postgres' namespace with extended.conf as extended config.

## Copy db secrets from postgres namespace to current namespace
./copy_secret.sh $NS

## Install kafka and Zookeeper
helm -n $NS install reporting mosip/reporting -f values.yaml --wait
