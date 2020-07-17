#!/bin/sh
# This script copies public key to authorized_key file of root
# Assumes that this script is called with 'sudo'
# Parameter: hostname

MUSER=mosipuser
KEY=id_rsa
hostnamectl set-hostname $1
adduser $MUSER 
mkdir -p /home/$MUSER/.ssh
chown $MUSER /home/$MUSER/.ssh
chgrp $MUSER /home/$MUSER/.ssh
echo "$MUSER ALL=(ALL)  NOPASSWD: ALL" >> /etc/sudoers
cp /tmp/$KEY* /home/$MUSER/.ssh
cat /home/$MUSER/.ssh/$KEY.pub >> /home/$MUSER/.ssh/authorized_keys
chmod 600 /home/$MUSER/.ssh/$KEY
chown $MUSER /home/$MUSER/.ssh/*
chgrp $MUSER /home/$MUSER/.ssh/*
# Mount EBS volume.
# CAUTION: the partition name is hardcoded. It may change.
mkfs -t xfs /dev/nvme1n1
mount /dev/nvme1n1 /srv
