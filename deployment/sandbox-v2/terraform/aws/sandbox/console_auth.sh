#!/bin/sh
# This script copies public key to authorized_key file of root
# Assumes that this script is called with 'sudo'

MUSER=mosipuser
KEY=id_rsa
adduser $MUSER 
mkdir -p /home/$MUSER/.ssh
echo "$MUSER ALL=(ALL)  NOPASSWD: ALL" >> /etc/sudoers
cp /tmp/$KEY* /home/$MUSER/.ssh
cat /home/$MUSER/.ssh/$KEY.pub >> /home/$MUSER/.ssh/authorized_keys
chmod 600 /home/$MUSER/.ssh/$KEY
chown $MUSER /home/$MUSER/.ssh/*
chgrp $MUSER /home/$MUSER/.ssh/*

