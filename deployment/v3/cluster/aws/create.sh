#!/bin/sh
eksctl create cluster \
--name MOSIPCluster \
--nodegroup-name mosip-worker-nodes \
--nodes 2 \
--instance-types=r5a.large \
--ssh-access \
--ssh-public-key rancher \
--managed
