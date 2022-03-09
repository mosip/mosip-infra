# Installation on e2e

## Scripts
Folder contains scripts and instructions to install MOSIP on e2e networks.  This is work-in-progres.

1. `cleanup.yaml`:  After deleting the cluster, this script might be used to clear up some of the folders. The usage of this script is not established yet - it has been picked up from v2 reset cluster procedure.

## Install guide
1. Create nodes as given in [here](e2e.md).
1. Create copy of `hosts.ini.sample` as `hosts.ini`. Update the IP addresses.

## Wireguard bastion node
- Open required Wireguard ports 
```
ansible-playbook -i hosts.ini wireguard.yaml
```
- Install [wireguard docker](../../docs/wireguard-bastion.md) with enough number of peers.
- Assign peer1 to yourself and set your wireguard client before working on the cluster.

## Cluster nodes
* Open ports on each of the nodes
```
ansible-playbook -i hosts.ini ports.yaml
```
* Disable swap _(perhaps not needed as swap is already disabled)_
```
ansible-playbook -i hosts.ini swap.yaml
```

With the above steps the nodes are ready for RKE installation.
