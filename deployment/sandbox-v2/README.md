# MOSIP Multi-VM Sandbox Installer

## Introduction

The Ansible scripts here run MOSIP on a multi Virtual Machine (VM) setup.  

## Sandbox architecture
![](https://github.com/pjoshi751/mosip-infra/blob/master/deployment/sandbox-v2/docs/sanbox_architecture.png)

## Hardware setup 

The following VMs are recommended:

### Kubernetes node VMs
1. Kubernetes master:  2 (2 CPU, 8 GB RAM)
1. Kubernetes workers:  n (4 CPU, 16 GB RAM)

* n = 1 for Pre Reg only
* n = 4 for Pre Reg + Reg Proc
* n = 5 for Pre Reg + Reg Proc + IDA

All the above within the same network.

### Console
Console machine: 1 (2 CPU, 8 GB RAM) 

## Console setup
Console machine is the machine from where you will run all the scripts.  The machine needs to be in the same network as all the Kubernetes nodes.  Your Ansible scripts run on the console machine. You may work on this machine as non-root user.   The console machine must be accessible from public domain name and port 80 on console machine must be accessible externally.

* Change hostname of console machine to `console`. 
* Create a (non-root) user account on console machine.
* Make `sudo` password-less for the user.
* Create ssh keys using `ssh-keygen` and place them in ~/.ssh folder:
```
$ ssh-keygen -t rsa
```
No passphrase, all defaults.
* Copy the public key of console user to all `authorized_keys` of `root` users of all machines, including console such that password-less ssh is possible to all Kubenetes machines (root user) and console (both root and console user).

* Install Ansible
```
$ sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
$ sudo yum install ansible-2.9.6-3.el7.noarch
```
* Install git:
```
$ sudo yum install -y git
```
* Git clone this repo in user home directory.

## K8s cluster machines setup
* Set up kubernetes machines with following hostnames matching names in hosts.ini. (may require reboot of machines)
* If you have more nodes in the cluster add them to `hosts.ini`.   

## Running Ansible scripts
* Change `sandbox_domain_name` in `group_vars/all.yml` to domain name of the console machine.

* Run the following:
```
$ ansible-playbook -i hosts.ini site.yml

To run individual roles, use tags, e.g
```
$ ansible-playbook -i hosts --tags postgres site.yml
```

