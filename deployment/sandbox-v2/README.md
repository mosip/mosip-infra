# MOSIP Sandbox Installer

## Introduction

The Ansible scripts here run MOSIP on a multi Virtual Machine (VM) setup.  The sandbox may be used for development and testing.

_**WARNING**: The sandbox is not intented to be used for serious pilots or production.  Further, do not run the sandbox with any confidential data._

## Sandbox architecture
![](https://github.com/mosip/mosip-infra/blob/master/deployment/sandbox-v2/docs/sandbox_architecture.png)

## OS
**CentOS 7.8** on all machines.

## Hardware configuration

### Full sandbox
The sandbox has been tested with the following configuration:

| Component| Number of VMs| Configuration| Persistence |
|---|---|---|---|
|Console| 1 | 4 vCPU*, 16 GB RAM | 128 GB SSD**|
|K8s MZ master | 1 | 4 vCPU, 8 GB RAM | 32 GB|
|K8s MZ workers | 9 | 4 vCPU, 16 GB RAM | 32 GB |
|K8s DMZ master | 1 | 4 vCPU, 8 GB RAM | 32 GB |
|K8s DMZ workers | 1 | 4 vCPU, 16 GB RAM | 32 GB |

\* vCPU:  Virtual CPU  
\** Console has all the persistent data stored under `/srv/nfs`.  Recommended storage here is SSD or any other high IOPS disk for better performance.

### Minibox
It is possible to bring up MOSIP modules with lesser VMs as below.  However, do note that this may not be sufficient for any kind of load or multiple pod replication scenarios:

| Component| Number of VMs| Configuration| Persistence |
|---|---|---|---|
|Console| 1 | 4 vCPU*, 16 GB RAM | 128 GB SSD |
|K8s MZ master | 1 | 4 vCPU, 8 GB RAM | 32 GB |
|K8s MZ workers | 3 | 4 vCPU, 16 GB RAM | 32 GB |
|K8s DMZ master | 1 | 4 vCPU, 8 GB RAM | 32 GB |
|K8s DMZ workers | 1 | 4 vCPU, 16 GB RAM | 32 GB |

## Virtual Machines (VMs) setup

Before installing MOSIP modules you will have to set up your VMs as below:
1. Install above mentioned OS on all machines
1. Create user 'mosipuser' on console machine with password-less `sudo su`. 
1. `hostname` on all machines must match hostnames in `hosts.ini`.  Set the same with
    ```
    $ sudo hostnamectl set-hostname <hostname>
    ```
1. Enable Internet connectivity on all machines. 
1. Disable `firewalld` on all machines. 
1. Exchange ssh keys between console and K8s cluster machines such that ssh is password-less from console machine:
    ```  
    $[mosipuser@console.sb] ssh root@<any K8s node>
    $[mosipuser@console.sb] ssh mosipuser@console.sb
    ```  
1. Make console machine accessible via a public domain name (e.g. sandbox.mycompany.com).  This step may be skipped if you do not plan to access the sandbox externally. 
1. Make sure datetime on all machines is in UTC.
1. Open ports 80, 443, 30090 (postgres), 30616 (activemq), 53 (coredns) on console machine for external access.

## Terraform
All the above is achieved using Terraform scripts available in `terraform/`.  At present, AWS scripts are being used and maintained.  It is highly recommended that you study the scripts in detail before running them. 

## Software prerequisites

* Install `git`:
```
$ sudo yum install -y git
```
* Git clone this repo in user home directory. Switch to the appropriate branch.  
```
$ cd ~/
$ git clone https://github.com/mosip/mosip-infra
$ cd mosip-infra
$ git checkout 1.1.2
$ cd mosip-infra/deployment/sandbox-v2
```
* Install Ansible and create shortcuts:
```
$ ./preinstall.sh
$ source ~/.bashrc
```

##  Installing MOSIP 
### Site settings
* Update `hosts.ini` as per your setup. Make sure the machine names are IP addresses match your setup. 
* In `group_vars/all.yml` change `sandbox_domain_name`  to domain name of the console machine.
* By default the installation scripts will try to obtain fresh SSL certificate for the above domain from [Letsencrypt](https://letsencrypt.org). However, If you already have the same then set the following variables in `group_vars/all.yml` file:
```
ssl:
  get_certificate: false
  email: ''
  certificate: <certificate dir>
  certificate_key: <private key path> 
```
### Network interface
If your cluster machines use network interface other than "eth0", update it in `group_vars/k8s.yml`.
```
network_interface: "eth0"
```
### Ansible vault
All secrets (passwords) used in this automation are stored in Ansible vault file `secrets.yml`.  The default password to access the file is 'foo'.  It is recommended that you change this password with following command:
```
$ av rekey secrets.yml
```
You may view and edit the contents of `secrets.yml`:
```
$ av view secrets.yml
$ av edit secrets.yml
```

### MOSIP configuration
Configure MOSIP as per [MOSIP Configuration Guide](docs/mosip_configuration_guide.md).

### Install MOSIP
* Intall all MOSIP modules:
```
$ an site.yml
```
Provide the vault password.  Default is 'foo'.

## Dashboards
The links to various dashboards are available at 

```
https://<sandbox domain name>/index.html
```

Refer to [Dashboards Guide](docs/dashboards.md)

## Sanity checks

[Sanity checks](docs/sanity_checks.md) during and post deployment.

## Reset
To install fresh, you may want to reset the clusters and persistence data.  Run the below script for the same.  This is **dangerous!**  The reset script will tear down the clusters and delete all persistence data.  Provide 'yes/no' responses to the prompts:
```
$ an reset.yml
```

## Persistence
All persistent data is available over Network File System (NFS) hosted on the console at location `/srv/nfs/mosip`.  All pods write into this location for any persistent data.  You may backup this folder if needed.

Note the following:
* Postgres is initialized and populated only once.  If persistent data is present in `/srv/nfs/mosip/postgres` then postgres is not initialized.  To force an init, run the following:
```
$ an playbooks/postgres.yml --extra-vars "force_init=true"
``` 
* Postgres also contains Keycloak data.  `keycloak-init` does not overwrite any data, but just updates and adds.  If you want to clean up Keycloak data, you will need to clean it up manually or reset entire postgres.

## Useful tools
### Shortcut commands
The following shortcuts are installed with `preinstall.sh`.  These are quite helpful with command line operations.
```
alias an='ansible-playbook -i hosts.ini --ask-vault-pass -e @secrets.yml'
alias av='ansible-vault'
alias kc1='kubectl --kubeconfig $HOME/.kube/mzcluster.config'
alias kc2='kubectl --kubeconfig $HOME/.kube/dmzcluster.config'
alias sb='cd $HOME/mosip-infra/deployment/sandbox-v2/'
alias helm1='helm --kubeconfig $HOME/.kube/mzcluster.config'
alias helm2='helm --kubeconfig $HOME/.kube/dmzcluster.config'
alias helmm='helm --kubeconfig $HOME/.kube/mzcluster.config -n monitoring'
alias kcm='kubectl -n monitoring --kubeconfig $HOME/.kube/mzcluster.config'
```
After adding the above:
```
  $ source  ~/.bashrc
``` 
### Tmux
If you use `tmux` tool, copy the config file as below:
```
$ cp /utils/tmux.conf ~/.tmux.conf  # Note the "."
```
### Property file comparator
To compare two property files (`*.properties`) use:
```
$ ./utils/prop_comparator.py <file1> <file2>
```
