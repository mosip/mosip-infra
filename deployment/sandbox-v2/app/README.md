# MOSIP Components installation

## Console setup 
TBD
  
## Kube worker node setup
* Creation of git config repo
* Creation of postgres folder

## Ansible variables
Modifying variables in Ansible roles for your  setup.

## Running Ansible scripts
```
$ ansible-playbook -i hosts site.yml
```
To run individual roles, use tags, e.g
```
$ ansible-playbook -i hosts --tags postgres site.yml
```
## Testing 
TBD

