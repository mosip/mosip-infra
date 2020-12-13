#!/bin/bash 

## Removing pre-reuisites for mosip.

helm --kubeconfig $HOME/.kube/mzcluster.config delete clamav

helm --kubeconfig $HOME/.kube/dmzcluster.config delete clamav

helm --kubeconfig $HOME/.kube/mzcluster.config delete activemq

helm --kubeconfig $HOME/.kube/mzcluster.config delete keycloak

helm --kubeconfig $HOME/.kube/mzcluster.config delete minio

helm --kubeconfig $HOME/.kube/mzcluster.config delete postgres
