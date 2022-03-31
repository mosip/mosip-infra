# Requirements for AWS MOSIP Cluster

Listed below are hardware, network and certificate requirements for **MOSIP sandbox** on AWS. Note that [Rancher cluster (AWS) requirements](../../rancher/aws) are not covered here.

## Hardware requirements

The following number of EC2 nodes/instances will be required

| No. of nodes | No. of vCPUs | RAM | Storage | AWS Type of each node | Used as part of |
|---|---|---|---|---|---|
| 5 | 8 vCPU | 32GB | 64 GB | t3.2xlarge | Cluster nodes |
| 1 | 2 vCPU | 1 GB | 8 GB | t2.micro | Wireguard Bastion Node |

Note: All the above nodes are to be on the same VPC.<br/>
Note: The above should also be on the same VPC as rancher cluster, since these will require rancher access. Otherwise the routes have to be manually setup.

## LoadBalancers

Two loadbalancers will be required, one for each ingressgateway, as describe in [the reference image](../README.md). <br/>
Note: These will automatically be created upon installation of the istio & ingressgateways.

## DNS Requirements

The following DNS mappings will be required.

| Hostname | Mapped to Loadbalancer/ip |
|---|---|
| mosip-api-host | Public load balancer (LB) |
| mosip-api-internal-host | Internal LB |
| mosip-prereg-host | Public LB |
| mosip-activemq-host | Internal LB |
| mosip-kibana-host | Internal LB |
| mosip-regclient-host | Internal LB |
| mosip-admin-host | Internal LB |
| mosip-minio-host | Internal LB |
| mosip-kafka-host | Internal LB |
| mosip-iam-external-host | Internal LB |

Note: The above table is just a placeholder for hostnames, the actual name itself varies from organisation to organisation.  A sample hostname list is given at [global_configmap.yaml.sample](../global_configmap.yaml.sample) <br/>
Note: Only proceed to DNS mapping after the ingressgateways are installed and the loadbalancers are setup.

## Certificate Requirements

* Depending upon the above hostnames, procure SSL certificates for domain and subdomains. E.g. `sandbox.mosip.net` and `*.sandbox.mosip.net`.
