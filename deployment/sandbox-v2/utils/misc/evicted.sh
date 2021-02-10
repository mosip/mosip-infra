#!/bin/bash
# Script to delete evicted pod from mz and dmz

kubectl --kubeconfig ~/.kube/dmzcluster.config get pods | grep Evicted | awk '{print $1}' | xargs kubectl --kubeconfig ~/.kube/dmzcluster.config  delete pod 
kubectl --kubeconfig ~/.kube/mzcluster.config get pods | grep Evicted | awk '{print $1}' | xargs kubectl --kubeconfig ~/.kube/mzcluster.config  delete pod
