#!/bin/sh
# This script copies public key to authorized_key file of root

MUSER=mosipuser
KEY=id_rsa
adduser $MUSER 
echo "$MUSER ALL=(ALL)  NOPASSWD: ALL" >> /etc/sudoers
mv /tmp/$KEY /home/$MUSER/.ssh
mv /tmp/$KEY.pub /home/$MUSER/.ssh
chown $MUSER /tmp/$KEY* 
chgrp $MUSER /tmp/$KEY* 
cat $KEY.pub >> /home/$MUSER/.ssh/authorized_keys

