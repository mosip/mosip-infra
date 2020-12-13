#!/bin/sh

## Removing MOSIP Modules

helm --kubeconfig $HOME/.kube/mzcluster.config delete kernel

helm --kubeconfig $HOME/.kube/mzcluster.config delete prereg

helm --kubeconfig $HOME/.kube/mzcluster.config delete regproc

helm --kubeconfig $HOME/.kube/mzcluster.config delete idrepo

helm --kubeconfig $HOME/.kube/mzcluster.config delete ida

helm --kubeconfig $HOME/.kube/mzcluster.config delete datashare

helm --kubeconfig $HOME/.kube/mzcluster.config delete pms

helm --kubeconfig $HOME/.kube/mzcluster.config delete admin

helm --kubeconfig $HOME/.kube/mzcluster.config delete resident

helm --kubeconfig $HOME/.kube/mzcluster.config delete print

helm --kubeconfig $HOME/.kube/mzcluster.config delete artifactory-service

helm --kubeconfig $HOME/.kube/mzcluster.config delete softhsm-ida

helm --kubeconfig $HOME/.kube/mzcluster.config delete mockabis

helm --kubeconfig $HOME/.kube/mzcluster.config delete mock-biosdk

helm --kubeconfig $HOME/.kube/mzcluster.config delete softhsm-keymanager

helm --kubeconfig $HOME/.kube/mzcluster.config delete packetmanager

helm --kubeconfig $HOME/.kube/dmzcluster.config delete dmzregproc

date
