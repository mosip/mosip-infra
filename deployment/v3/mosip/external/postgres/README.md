# Postgres

## Introduction
Postgress may be integrated in MOSIP in the following ways:
1. Cloud: Postgres service provided by Cloud Provider, like RDS on AWS.
1. Native: Postgres setup on dedicated VMs (outside of MOSIP cluster)
1. In-cluster: Postgres running inside MOSIP Kubernetes cluster. Typically, for development purposes.   

While production deployments will either use (1) or (2) for non-production deployment you may go with (3). It is possible to install high availablity Postgres on cluster as well, however, whether the same approach can be scaled to full scale production is yet to be evaluated and tested.  Having said that, the method outlined in (3) should work well for sandboxes and small pilot rollouts.

## Dependency

## Cloud setup
On AWS:
* Provision a Postgres RDS instance on AWS depending on scale of deployment
* CAUTION: Do check the costs of RDS before deploying.
* For non-production env you may want to install Postgres yourself as given [here](../on-prem/README.)

## Native
Follow Postgres installation procedure of your choice. Make sure high availability, replication and other reliability factors are taken care.

## In-cluster
Follow instructions given [here](cluster/README.md)

## Recommended DB groupings
In production, rather than running all DBs on a single Postgres server it is recommended you have multiple servers with following DBs running on them:
1. Audit: mosip_audit
1. PMS: mosip_pms, mosip_authdevice, mosip_regdevice
1. IDA: mosip_ida
1. REGPROC: mosip_regprc
1. PREREG: mosip_prereg
1. KERNEL: mosip_kernel
1. IDREPO: mosip-idrepo, mosip-credential, mosip_idmap 
1. mosip_websub 

