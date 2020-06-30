# MOSIP Sandbox Installer

## Introduction

The Ansible scripts here run MOSIP on a multi Virtual Machine (VM) setup.  The sandbox may be used for development and testing.

**WARNING**: The sandbox is not intented to be used for serious pilots or production.  Further, do not run the sandbox with any confidential data.  

## Sandbox architecture
![](https://github.com/mosip/mosip-infra/blob/master/deployment/sandbox-v2/docs/sandbox_architecture.png)

## OS
CentOS 7.7 on all machines.

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
* Set captcha keys in `site.captcha` (for PreReg). Get captcha keys for your domain from Google Recaptcha Admin.
* By default the installation scripts will try to obtain fresh SSL certificate for the above domain from [Letsencrypt](https://letsencrypt.org). However, If you already have the same then set the following variables in `group_vars/all.yml` file:
```
ssl:
  get_certificate: false
  email: ''
  certificate: <certificate dir>
  certificate_key: <private key path> 
```
### OTP settings
To receive OTP on email and SMS set the following in `group_vars/all.yml`.  If you do not have access to Email and SMS gateways, you may want to run MOSIP in Proxy OTP mode in which case skip to [Proxy OTP Settings](#proxy-otp-settings).  
* Email 
  ```
  smtp:
    email_from: mosiptestuser@gmail.com
    host: smtp.sendgrid.net
    username: apikey
    password: xyz
  ```
* SMS 
  ```
  sms:
    gateway: gateway name
    api: gateway api
    authkey: authkey
    route: route
    sender: sender
    unicode: unicode
  ```
### Proxy OTP settings

* To run MOSIP in Proxy OTP mode set the following in `roles/config-repo/files/properties/application-mz.properties`: 
  ```
  mosip.kernel.sms.proxy-sms=true
  mosip.kernel.auth.proxy-otp=true
  mosip.kernel.auth.proxy-email=true
  ```
Note that the default OTP is set to `111111`.

* Intall all MOSIP modules:
```
$ ansible-playbook -i hosts.ini site.yml
```

## Dashboards
The links to various dashboards are available at 

```
https://<sandbox domain name>/index.html
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
* If you use `tmux` tool, copy the config file as below:
```
$ cp /utils/tmux.conf ~/.tmux.conf
```
