#!/bin/sh
# Run this scrip to exchanges ssh keys between console and 
# cluster machines
# Provide 'mosipuser' password.  Assumes password is same for all machines
# Parameter:  inventory file (.ini)

$ ansible-playbook -i $1 --extra-vars "ansible_user=mosipuser" --ask-pass --ask-become-pass playbooks/ssh.yml
