# MOSIP Components Installation

## Console setup 
TBD

## Nginx setup
* Allocate a public ip and public DNS to the server.
  
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

