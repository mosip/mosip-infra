#!/bin/sh
# This script copies public key to authorized_key file of root

KEY=/tmp/id_rsa.pub
mkdir -p /root/.ssh
cat $KEY >> /root/.ssh/authorized_keys

