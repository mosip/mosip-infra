#!/bin/sh
# This script copies public key to authorized_key file of root

KEY=id_rsa
cat $KEY.pub >> /root/.ssh/authorized_keys

