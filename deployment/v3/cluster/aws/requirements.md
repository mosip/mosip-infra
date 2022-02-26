# Requirements for AWS MOSIP Cluster

This document is just a comprehensive list of requirements. Follow the installation procedure to meet these requirements. (i.e., do not manually create the nodes or loadbalancers on console)

## Hardware requirements

Will require the following number of EC2 nodes/instances

| No. of nodes | No. of vCPUs | RAM | Storage | AWS Type of each node | Used as part of |
|---|---|---|---|---|---|
| 5 | 8 vCPU | 32GB | 64 GB | t3.2xlarge | Cluster nodes |
| 1 | 2 vCPU | 1 GB | 8 GB | t2.micro | Wireguard Bastion Node |

Note: All the above nodes are to be on the same VPC.

For better security and access we can have separate Wireguard bastion server for all the partners and field operations like:
1. ABIS Partner
1. Auth Partners
1. Print Partners
1. Field Operators
1. Admin Authorities
1. Process Monitoring departments

Note: The same can be configured with single bastion server node also

## LoadBalancers

Will need two loadbalancers, one for each ingressgateway, as describe in [the reference image](../README.md). <br/>
Note: These will automatically be created upon installation of the istio & ingressgateways.

## DNS Requirements

Will require the DNS mappings. <br/>
The actual hostnames will vary from organisation to organisation. A sample hostname list is given at [global_configmap.yaml.sample](../global_configmap.yaml.sample) <br/>
Note: Will get the loadbalancer ip only after the ingressgateways are installed and the loadbalancers are setup. Only then proceed to DNS mapping.

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

## Certificate Requirements

* Depending upon the above hostnames, will requires atleast one wildcard SSL certificate. For example; `*.mosip.gov.country`.
* Will need more ssl certificates, for every new level of hierarchy. For example; `*.sandbox1.mosip.example.org`.
