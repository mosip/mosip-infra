#!/bin/sh
# Installs all Regproc helm charts

helm repo update
./install.sh regproc-status
./install.sh regproc-camel
./install.sh regproc-receiver
./install.sh regproc-pktserver
./install.sh regproc-uploader
./install.sh regproc-validator 
./install.sh regproc-quality 
./install.sh regproc-osi 
./install.sh regproc-demo 
./install.sh regproc-biodedupe
./install.sh regproc-abishandler
./install.sh regproc-abismid
./install.sh regproc-manual 
./install.sh regproc-bioauth
./install.sh regproc-eis
./install.sh regproc-external 
./install.sh regproc-msg
./install.sh regproc-print
./install.sh regproc-reprocess
./install.sh regproc-trans
./install.sh regproc-uin
