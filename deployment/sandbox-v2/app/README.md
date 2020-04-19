# MOSIP Components Installation 
## Setup of all machines  
* Set up kubernetes machines with following hostnames:
  * kubemaster
  * kubeworker0
  * kuberworker1
* Make sure hostname in inventory match with actual hostnames.
    ...
## Console setup 
Configure all variables of the setup as below:
* Create a normal (non-root) account on console machine with hostname 'console'.
* Change "PasswordAuthentication no" to "PasswordAuthentication yes" in /etc/ssh/sshd_config. And restart sshd.
* Create ssh keys using `ssh-keygen` and place them in ~/.ssh folder:
```
$ ssh-keygen -t rsa
```
No passphrase, all defaults.

* Include public key in ~/.ssh/authorized_keys.  
* Do the same for root user.
* Include current user in /etc/sudoers file with no password. 
* Install Ansible
```
$ sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
$ sudo yum install ansible # This will install 2.9 version
```

```
$ ansible-playbook -i --ask-pass hosts.ini ssh.yml 
```
* Install git:
```
$ sudo yum install -y git
```
  
## Kube worker node setup
* Creation of git config repo
* Creation of postgres folder

## Ansible variables
Modifying variables in Ansible roles for your  setup.

## Running Ansible scripts
```
$ ansible-playbook -i hosts ssh.yml
$ ansible-playbook -i hosts mosip.yml 
```
To run individual roles, use tags, e.g
```
$ ansible-playbook -i hosts --tags postgres site.yml
```
## Testing 
TBD

