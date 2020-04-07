# MOSIP Multi-VM Sandbox Installer

## Introduction

The folders here contain Ansible scripts to run MOSIP on a multi Virtual Machine (VM) setup.  

* `kube/`:  Scripts to install Kubernetes
* `app/`:  Scripts to install all MOSIP related modules


## Hardware setup 

The following VMs are recommended:

### Kubernetes node VMs
1. Kubernetes master:  1 (4 CPU, 16 GB RAM)
1. Kubernetes workers:  n (4 CPU, 16 GB RAM)

* n = 2 for Pre Reg only
* n = 4 for Pre Reg + Reg Proc
* n = 5 for Pre Reg + Reg Proc + IDA

All the above in the same network.

### Console
1. Console machine: 1 (2 CPU, 8 GB RAM) 

Console machine is the machine from where you will run all the scripts.  The machine needs to be in the same network as all the Kubernetes nodes.

## Installation
1.  Install Kubernetes with instructions given in `kube/`
1.  Install MOSIP modules with instructions given in `app/`





