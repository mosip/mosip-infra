# MOSIP Multi-VM Sandbox Installer

## Introduction

The Ansible scripts here run MOSIP on a multi Virtual Machine (VM) setup.  

## Sandbox architecture
![](https://github.com/pjoshi751/mosip-infra/blob/master/deployment/sandbox-v2/docs/sanbox_architecture.png)

## Hardware setup 

The following VMs are recommended:

### Kubernetes node VMs
* Kubernetes master:  
  * Number of VMs: _m_
  * Configuration: 2 CPU, 4 GB RAM
* Kubernetes workers:  
  * Number of Vms: _n_ 
  * Configuration: 4 CPU, 16 GB RAM

* m = 1, n = 1 for Pre Reg only
* m = 2, n = 2 for Pre Reg + Reg Proc
* m = 2, n = 3 for Pre Reg + Reg Proc + IDA

All the above within the same network. Note that all pods run with replication=1.  If higher replication is needed, accordingly, the number of VMs will be higher.

### Console
Console machine: 1 (2 CPU, 4 GB RAM) 

## Console setup
Console machine is the machine from where you will run all the scripts.  Your Ansible scripts run on the console machine.  You must work on this machine as 'mosipuser' user (not root).   

* Create 'mosipuser' user.
* Console machine is must be in the same subnet as kuberntes cluster machines.
* Console machine must be accessible with the puplic domain name.
* Port 80 and 443 open for external access.
* Change hostname of console machine to `console`. 
* Create a (non-root) user account on console machine.
* Make `sudo` password-less for the user.
* Create ssh keys using `ssh-keygen` and place them in `~/.ssh` folder:
```
$ ssh-keygen -t rsa
```
No passphrase, all defaults.
* Copy the public key of console user to all `authorized_keys` of `root` users of all machines, including console such that password-less ssh is possible to all Kubenetes machines (root user) and console (both root and console user). Check if password-less ssh works:
```
$ ssh root@<hostname> 
```

* Install Ansible
```
$ sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
$ sudo yum install ansible-2.9.7-1.el7
```
* Install git:
```
$ sudo yum install -y git
```
* Git clone this repo in user home directory.
* Check `hosts.ini` file. If you are not running Registration Processor (regproc) remove the DMZ cluster hosts and groups from `hosts.ini` otherwise scripts will try to setup DMZ cluster.
* Disable `firewalld`:
```
$ sudo systemctl stop firewalld 
$ sudo systemctl disable firewalld 
```
## K8s cluster machines setup
* Set up kubernetes machines with following hostnames matching names in hosts.ini. (may require reboot of machines)
* If you have more nodes in the cluster add them to `hosts.ini`.   
* Disable `firewalld`:
```
$ systemctl stop firewalld 
$ systemctl disable firewalld 
```

## Running Ansible scripts
* Change `sandbox_domain_name` in `group_vars/all.yml` to domain name of the console machine.

* Run the following:
```
$ ansible-playbook -i hosts.ini site.yml
```
To run individual roles, use tags, e.g
```
$ ansible-playbook -i hosts --tags postgres site.yml
```

