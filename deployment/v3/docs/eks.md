# Cluster on Amazon EKS

## Create cluster with eksctl
```
~/Documents/mosip/mosip-infra/deployment/v3$ eksctl create cluster \                    
--name TestCluster2 \                
--nodegroup-name test-nodes \
--nodes 2
--ssh-access 
```

* The nodes will be seen under Auto Scaling Group tab on the left of AWS EC2 dashboard.

