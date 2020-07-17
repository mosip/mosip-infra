# MOSIP Sandbox Installer

## Introduction

The Ansible scripts here run MOSIP on a multi Virtual Machine (VM) setup.  The sandbox may be used for development and testing.

_**WARNING**: The sandbox is not intented to be used for serious pilots or production.  Further, do not run the sandbox with any confidential data._

## Sandbox architecture
![](https://github.com/mosip/mosip-infra/blob/master/deployment/sandbox-v2/docs/sandbox_architecture.png)

## OS
**CentOS 7.7** on all machines.

## Hardware setup 

The sandbox has been tested with the following configuration:

| Component| Number of VMs| Configuration| Persistence |
|---|---|---|---|
|Console| 1 | 4 VCPU*, 8 GB RAM | 128 GB SSD |
|K8s MZ master | 1 | 4 VCPU, 8 GB RAM | - |
|K8s MZ workers | 9 | 4 VCPU, 16 GB RAM | - |
|K8s DMZ master | 1 | 4 VCPU, 8 GB RAM | - |
|K8s DMZ workers | 1 | 4 VCPU, 16 GB RAM | - |

\* VCPU:  Virtual CPU

All pods run with replication=1.  If higher replication is needed, accordingly, the number of VMs needed will be higher.

## VM setup
### All machines
All machines need to have the following:
* User 'mosipuser' with strong password. Same password on all machines.
* Password-less `sudo su`.
* Internet connectivity.
* Accessible from console via hostnames defined in `hosts.ini`.  
* `firewalld` disabled.

### Console 
Console machine is the machine from where you run Ansible and other the scripts.  You must work on this machine as 'mosipuser' user (not 'root').   
* Console machine must be accessible with public domain name (e.g. sandbox.mycompany.com).
* Port 80, 443, 30090 (for postgres) must be open on the console for external access.
* Install Ansible
```
$ sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
$ sudo yum install ansible
```
* Install git
```
$ sudo yum install -y git
```
* Git clone this repo in user home directory.
```
$ cd ~/
$ git clone https://github.com/mosip/mosip-infra
$ cd mosip-infra/deployment/sandbox-v2
```
* Exchange ssh keys with all machines. Provide the password for 'mosipuser'.
```
$ ./key.sh hosts.ini
``` 

##  Installing MOSIP 
### Site settings
In `group_vars/all.yml`, set the following: 
* Change `sandbox_domain_name`  to domain name of the console machine.
* By default the installation scripts will try to obtain fresh SSL certificate for the above domain from [Letsencrypt](https://letsencrypt.org). However, If you already have the same then set the following variables in `group_vars/all.yml` file:
```
ssl:
  get_certificate: false
  email: ''
  certificate: <certificate dir>
  certificate_key: <private key path> 
```
* Set **private ip** address of `mzworker0.sb` and `dmzworker0.sb` in `group_vars/all.yml`:

```
clusters:
  mz:
    any_node_ip: '<mzworker0.sb ip>'

clusters:
  dmz:
    any_node_ip: '<dmzworker0.sb ip>'
```
### Network interface
If your cluster machines use network interface other than "eth0", update it in `group_vars/mzcluster.yml` and `group_vars/dmzcluster.yml`:
```
network_interface: "eth0"
```
### MOSIP configuration
Configure MOSIP as per [MOSIP Configuration Guide](docs/mosip_configuration_guide.md).

### Shortcut commands
Add the following shortcuts in `/home/mosipuser/.bashrc`:
```
alias an='ansible-playbook -i hosts.ini'
alias kc1='kubectl --kubeconfig $HOME/.kube/mzcluster.config'
alias kc2='kubectl --kubeconfig $HOME/.kube/dmzcluster.config'
alias sb='cd $HOME/mosip-infra/deployment/sandbox-v2/'
alias helm1='helm --kubeconfig $HOME/.kube/mzcluster.config'
alias helm2='helm --kubeconfig $HOME/.kube/dmzcluster.config'
```
After adding the above:
```
  $ source  ~/.bashrc
``` 
### Install MOSIP
* Intall all MOSIP modules:
```
$ ansible-playbook -i hosts.ini site.yml
```
or with shortcut command
```
$ an site.yml
```

## Dashboards
The links to various dashboards are available at 

```
https://<sandbox domain name>/index.html
```
Tokens/passwords to login into dashboards are available at `/tmp/mosip` of the console.

For Grafana you may import chart `1860`.

## Sanity checks

[Sanity checks](docs/sanity_checks.md) during and post deployment.

## Reset
To install fresh, you may want to reset the clusters and persistence data.  Run the below script for the same.  This is **dangerous!**  The reset script will tear down the clusters and delete all persistence data.  Provide 'yes/no' responses to the prompts:
```
$ an reset.yml
```

## Persistence
All persistent data is available over Network File System (NFS) hosted on the console at location `/srv/nfs/mosip`.  All pods write into this location for any persistent data.  You may backup this folder if needed.

## Useful tools
* If you use `tmux` tool, copy the config file as below:
```
$ cp /utils/tmux.conf ~/.tmux.conf  # Note the "."
```
