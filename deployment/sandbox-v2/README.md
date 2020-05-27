# MOSIP Multi-VM Sandbox Installer

## Introduction

The Ansible scripts here run MOSIP on a multi Virtual Machine (VM) setup.  

## Sandbox architecture
![](https://github.com/mosip/mosip-infra/blob/master/deployment/sandbox-v2/docs/sanbox_architecture.png)

## OS
CentOS 7.7 on all machines.

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
* m = 2, n = 3 for Pre Reg + Reg Proc
* m = 2, n = 4 for Pre Reg + Reg Proc + IDA

All the above within the same network. Note that all pods run with replication=1.  If higher replication is needed, accordingly, the number of VMs will be higher.

### Console
Console machine: 1 (2 CPU, 4 GB RAM) 

## Console setup
Console machine is the machine from where you will run all the scripts.  Your Ansible scripts run on the console machine.  You must work on this machine as 'mosipuser' user (not root).   

* Create 'mosipuser' user.
* Make `sudo` password-less for this user.
* Console machine must be in the same subnet as kuberntes cluster machines.
* Console machine must be accessible with the public domain name (e.g. sandbox.mycompany.com)
* Port 80, 443, 30090 (for postgres) must be open on the console for external access.
* Change hostname of console machine to `console`. 
* Create ssh keys using `ssh-keygen` and place them in `~/.ssh` folder:
```
$ ssh-keygen -t rsa
```
No passphrase, all defaults.
* Copy the public key of 'mosipuser' to all `authorized_keys` of `root` users of all machines, including console such that password-less ssh is possible to all Kubenetes machines (root user) and console. Check if password-less ssh works:
```
$ ssh root@<hostname> 
```

* Install Ansible
```
$ sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
$ sudo yum install ansible
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
* Change the hostname of machines to hostnames mentioned in `hosts.ini`:
```
$ sudo hostnamectl set-hostname <hostname>
```
* Make sure each machine is accessible password-less with above hostname.
```
$ ssh root@<hostname>
```
* Disable `firewalld`:
```
$ systemctl stop firewalld 
$ systemctl disable firewalld 
```

## Running Ansible scripts
* In `groups_vars/all.yml`, set the following: 
  * Change `sandbox_domain_name`  to domain name of the console machine.
  * Set captcha keys in `site.captcha`.
  * Set SMTP email settings:
    ```
    smtp:
      email_from: mosiptestuser@gmail.com
      host: smtp.sendgrid.net
      username: apikey
      password: xyz
    ```
* If you already have SSL certificate for your domain, place the certificates appropriately under `/etc/ssl` (or any directory of choice) and set the following `group_vars/all.yml` file:
```
ssl:
  get_certificate: false 
  email: ''
  certificate: <certificate dir>
  certificate_key: <private key path> 
```

* Run the following:
```
$ ansible-playbook -i hosts.ini site.yml
```
To run individual roles, use tags, e.g
```
$ ansible-playbook -i hosts --tags postgres site.yml
```
## Useful tips
You may add the following short-cuts in `/home/mosipuser/.bashrc`:
```
alias an='ansible-playbook -i hosts.ini'
alias kc1='kubectl --kubeconfig $HOME/.kube/mzcluster.config'
alias kc2='kubectl --kubeconfig $HOME/.kube/dmzcluster.config'
alias sb='cd $HOME/mosip-infra/deployment/sandbox-v2/'
alias helm1='helm --kubeconfig $HOME/.kube/mzcluster.config'
alias helm2='helm --kubeconfig $HOME/.kube/dmzcluster.config'
```
After the adding the above:
```
$ source  ~/.bashrc
```

