# MOSIP cluster using RKE

## Setup
* Create VMs with Ranchor OS.
* Open all ports as given [here](https://rancher.com/docs/rancher/v2.x/en/installation/requirements/ports/#ports-for-rancher-launched-kubernetes-clusters-using-node-pools)
* Open port 179 on nodes for Calico
* Open port 7946 on TCP and UDP for Metallb.
* Let control plane run on all nodes for HA.

## Config
* Choose Calico as networking model.

