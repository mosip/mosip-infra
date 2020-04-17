# MOSIP Components Installation 
## Setup of all machines  
Set up kubernetes machines. Make sure all have the same root password. 

## Console setup 
* Configure all variables of the setup as below:
* Create a normal (non-root) account on console machine
* Create ssh keys using `ssh-keygen` and place them in ~/.ssh folder
* Include public key in ~/.ssh/authorized_keys.  
* Include current user in /etc/sudoers file with no password. 
```
$ ansible-playbook -i --ask-pass hosts.ini ssh.yml 
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

