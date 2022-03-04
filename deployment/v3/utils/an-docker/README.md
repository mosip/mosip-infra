# Ansible Docker Installer

## Overview
This folder contains Ansible scripts to install Docker on set of nodes.

## Install
* Configure `hosts.ini.sample` and copy to `hosts.ini`
* Run
```
ansible-playbook -i hosts.ini install.yaml
```
