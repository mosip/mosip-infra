# Requirements for AWS Rancher Cluster

Listed below are hardware, network and certificate requirements to setup a **Rancher Cluster** on AWS.

## Hardware requirements

The following number of EC2 nodes/instances will be required

|Purpose|vCPUs|RAM|Storage| AWS Type of each node | Number of Nodes|
|---|:---:|:---:|:---:|:---:|---:|
|Cluster nodes | 2 | 8 GB | 32 GB | t3.large |2|
|Wireguard bastion host| 2 | 1 GB | 8 GB | t2.micro |1|

Note: All the above nodes are to be on the same VPC.

## LoadBalancers

One loadbalancer will be required, for the ingress controller. <br/>
Note: This will automatically be created upon installation of the ingress controller.

## DNS requirements

The following DNS mappings will be required.

| Hostname | Mapped to |
|---|---|
| rancher.org.net | Ingresscontroller Loadbalancer \* |
| iam.org.net | Ingresscontroller Loadbalancer \* |

\* There is only one LB in the cluster.<br/>
Note: The above table is just a placeholder for hostnames, the actual name itself varies from organisation to organisation. <br/>
Note: Will get the loadbalancer ip only after the ingresscontroller is installed and the loadbalancer is setup. Only then proceed to DNS mapping.

## Certificate requirements

* Depending upon the above hostnames, atleast one wildcard SSL certificate will be required. For example; `*.org.net`.
* More ssl certificates will be required, for every new level of hierarchy. For example; `*.sandbox1.org.net`.
