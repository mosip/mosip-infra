#!/bin/sh
eksctl create cluster \
--name TestCluster \
--nodegroup-name test-nodes \
--nodes 2 \
--ssh-access \
--ssh-public-key rancher

