# MOSIP Multi-VM Sandbox Installer

## Introduction

The Ansible scripts here run MOSIP on a multi Virtual Machine (VM) setup.  The sandbox may be used for development and testing.

WARNING: The sandbox is not intented to be used for serious pilots or production.  Further, do not run the sandbox with any confidential data.  

## Sandbox architecture
![](https://github.com/mosip/mosip-infra/blob/master/deployment/sandbox-v2/docs/sandbox_architecture.png)

## OS
CentOS 7.7 on all machines.

## Hardware setup 

The sandbox has been tested with following configuration:

| Component| Number of VMs| Configuration| Persistence |
|---|---|---|---|
|Console| 1 | 4 VCPU*, 8 GB RAM | 128 GB SSD |
|K8s MZ master | 1 | 4 VCPU, 8 GB RAM | - |
|K8s MZ workers | 9 | 4 VCPU, 16 GB RAM | - |
|K8s DMZ master | 1 | 4 VCPU, 8 GB RAM | - |
|K8s DMZ workers | 1 | 4 VCPU, 16 GB RAM | - |

\* VPU:  Virtual CPU

All the above machines are within the same subnet. Note that all pods run with replication=1.  If higher replication is needed, accordingly, the number of VMs needed will be higher.

## VM setup
### All machines
* Create a user 'mosipuser' with strong password, same on all machines.
* Make `sudo su` passwordless.
* All machines in the same subnet.
* All machines accessible via hostnames defined in `hosts.ini`.  

### Console 
Console machine is the machine from where you run Ansible and other the scripts.  You must work on this machine as 'mosipuser' user (not root).   
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
  * Set captcha keys in `site.captcha` (for PreReg). Get captcha keys for your domain from Google Recaptch admin.
  * (Optional) Set SMTP email settings:
    ```
    smtp:
      email_from: mosiptestuser@gmail.com
      host: smtp.sendgrid.net
      username: apikey
      password: xyz
    ```
  * Set the sms gateway settings in the `site.sms` field:
    ```
    sms:
    gateway: gateway name
    api: gateway api
    authkey: authkey
    route: route
    sender: sender
    unicode: unicode
    ```
* If you already have an SSL certificate for your domain, place the certificates appropriately under `/etc/ssl` (or any directory of choice) and set the following variables in `group_vars/all.yml` file:
```
ssl:
  get_certificate: false
  email: ''
  certificate: <certificate dir>
  certificate_key: <private key path> 
```
* (Optional) If you want the proxy OTP to be used in case you dont have msg91.authkey and smtp.password make below property changes.
    In mosip-infra/deployment/sandbox-v2/roles/config-repo/files/properties/application-mz.properties make below flag changes:
     ```
     mosip.kernel.sms.proxy-sms=true
     mosip.kernel.auth.proxy-otp=true
     mosip.kernel.auth.proxy-email=true
     ```
    Also set the proxy OTP which you want, by default it is set to 111111 in mosip-infra/deployment/sandbox-v2/roles/config-repo/files/properties/kernel-mz.properties:
    Note : OTP length should be 6 digits.
     ```
     mosip.kernel.auth.proxy-otp-value=<proxy OTP value>    
     ```

* Run playbooks:
```
$ ansible-playbook -i hosts.ini site.yml
```
## Dashboards
The links to various dashboards are available at 
```
https://<sandbox domain name/index.html
```

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
kc1 port-forward --address 0.0.0.0 service/hadoop-hdfs-nn 9000:9000
```
