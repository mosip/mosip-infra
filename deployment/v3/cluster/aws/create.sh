#!/bin/sh
eksctl create cluster \
--name MOSIPCluster \
--nodegroup-name mosip-worker-nodes \
--nodes 2 \
--instance-types=m5a.xlarge \
--ssh-access \
--ssh-public-key rancher \
--managed
