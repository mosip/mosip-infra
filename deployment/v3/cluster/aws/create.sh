#!/bin/sh
eksctl create cluster \
--name IAMCluster \
--nodegroup-name workder-nodes \
--nodes 1 \
--ssh-access \
--ssh-public-key rancher
