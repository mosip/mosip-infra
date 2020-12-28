#!/bin/sh
# Run this script to exchange ssh keys between console and cluster machines
# Provide password for 'mosipuser' user. Assumes password is same for all machines
# Parameter:  inventory file (.ini)

ansible-playbook -i $1 --extra-vars "ansible_user=mosipuser" --ask-pass --ask-become-pass playbooks/ssh.yml
