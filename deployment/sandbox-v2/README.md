# MOSIP Multi-VM Sandbox Installer

## Introduction

The Ansible scripts here run MOSIP on a multi Virtual Machine (VM) setup.  

## Sandbox architecture
![](https://github.com/mosip/mosip-infra/blob/master/deployment/sandbox-v2/docs/sanbox_architecture.png)

## OS
CentOS 7.7 on all machines.

## Hardware setup 

The sandbox has been tested on the following configuration:

| Component| Number of VMs| Configuration| Persistence |
|---|---|---|---|
|Console| 1 | 4 CPU, 8 GB RAM | 128 GB SSD |
|K8s MZ master | 1 | 4 CPU, 8 GB RAM | - |
|K8s MZ workers | 9 | 4 CPU, 16 GB RAM | - |
|K8s DMZ master | 1 | 4 CPU, 8 GB RAM | - |
|K8s DMZ workers | 1 | 4 CPU, 16 GB RAM | - |

All the above within the same network. Note that all pods run with replication=1.  If higher replication is needed, accordingly, the number of VMs will be higher.

## VM setup
### All machines
* Create a user 'mosipuser' with strong password, same on all machines
* Make `sudo su` passwordless.
* All machines in same subnet.
* All machines accessible using hostnames defined in `hosts.ini`.

### Console 
Console machine is the machine from where you will run Ansible and other the scripts.  You must work on this machine as 'mosipuser' user (not root).   
* Console machine must be accessible with the public domain name (e.g. sandbox.mycompany.com)
* Port 80, 443, 30090 (for postgres), 9000 (HDFS) must be open on the console for external access.
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
```
$ cd ~/
$ git clone https://github.com/mosip/mosip-infra
$ cd mosip-infra/deployment/sandbox-v2
```
* Exchange ssh keys with all machines. Provide the common machine password.
```
$ ./key.sh hosts.ini
``` 

##  Installing MOSIP 
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
## Dashboards
The following dashboards are installed with the deployment:
* Kubernetes dashboard
```
https://<domain name>/mz-dashboard/
https://<domain name>/dmz-dashboard/
```
* Keycloak
```
https://<domain name>/keycloak/auth/    # Slash at the end is required!
```
* Pgadmin (or psql)
  * host: <domain name>
  * port: 30090
* Grafana
```
https://<domain name>/mz-grafana/
https://<domain name>/dmz-grafana/
```
## Useful tips
* You may add the following short-cuts in `/home/mosipuser/.bashrc`:
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
* If you are using `tmux` tool, copy the config file as below:
```
$ cp /utils/tmux.conf ~/.tmux.conf
```
* To enable hdfs namenode access externally
  * Open port 9000 for external access
  * Run
```
kc1 port-forward --address 0.0.0.0 service/hadoop-hadoop-hdfs-nn 9000:9000
```
