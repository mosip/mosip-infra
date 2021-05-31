#!/bin/sh
# Uninstalls all Regproc helm charts

helm repo update
./uninstall.sh regproc-status
./uninstall.sh regproc-camel
./uninstall.sh regproc-receiver
./uninstall.sh regproc-pktserver
./uninstall.sh regproc-uploader
./uninstall.sh regproc-validator 
./uninstall.sh regproc-quality 
./uninstall.sh regproc-osi 
./uninstall.sh regproc-demo 
./uninstall.sh regproc-biodedupe
./uninstall.sh regproc-abishandler
./uninstall.sh regproc-abismid
./uninstall.sh regproc-manual 
./uninstall.sh regproc-bioauth
./uninstall.sh regproc-eis
./uninstall.sh regproc-external 
./uninstall.sh regproc-msg
./uninstall.sh regproc-print
./uninstall.sh regproc-reprocess
./uninstall.sh regproc-trans
./uninstall.sh regproc-uin
