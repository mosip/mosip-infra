#!/bin/sh
# This script copies public key to authorized_key file of root
# Assumes that this script is called with 'sudo'
# Parameter: hostname

MUSER=mosipuser
HOME=/home/$MUSER
KEY=id_rsa
hostnamectl set-hostname $1
adduser $MUSER 
chmod 755 $HOME # Needed for nginx access to display files
SSH_DIR=$HOME/.ssh
mkdir -p $SSH_DIR 
chown $MUSER $SSH_DIR 
chgrp $MUSER $SSH_DIR 
echo "$MUSER ALL=(ALL)  NOPASSWD: ALL" >> /etc/sudoers
cp /tmp/$KEY* $SSH_DIR 
cat $SSH_DIR/$KEY.pub >> $SSH_DIR/authorized_keys
chmod 600 $SSH_DIR/$KEY
chown $MUSER $SSH_DIR/*
chgrp $MUSER $SSH_DIR/*
# Mount EBS volume.
# CAUTION: the partition name is hardcoded. It may change.
mkfs -t xfs /dev/nvme1n1
mount /dev/nvme1n1 /srv
# Make the above permanent
echo "/dev/nvme1n1 /srv                       xfs     defaults        0 0" >> /etc/fstab
