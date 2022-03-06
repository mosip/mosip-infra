#!/bin/bash
echo Installing MOSIP services

echo Installing Config server make sure that config repository details are correct in config_server/values.yaml
cd config_server 
./install.sh
cd ../
kubectl -n config-server rollout status deploy config-server
echo Installed Config Server

echo Instaling artifactory service for all MOSIP modules
cd artifactory
./install.sh
cd ../
kubectl -n artifactory rollout status deploy artifactory

echo Instaling keymanager
cd keymanager
./install.sh
cd ../
kubectl -n keymanager rollout status deploy keymanager

echo Instaling websub 
cd websub
./install.sh
cd ../
kubectl -n websub rollout status deploy websub
echo Instaling kernel services

cd kernel
./install.sh
cd ../
kubectl -n kernel rollout status deploy auditmanager
kubectl -n kernel rollout status deploy authmanager
kubectl -n kernel rollout status deploy idgenerator
kubectl -n kernel rollout status deploy masterdata
kubectl -n kernel rollout status deploy notifier
kubectl -n kernel rollout status deploy otpmanager
kubectl -n kernel rollout status deploy pridgenerator
kubectl -n kernel rollout status deploy ridgenerator
kubectl -n kernel rollout status deploy syncdata
echo Installed kernel services

cd packetmanager
echo Instaling packetmanager services
./install.sh
cd ../
kubectl -n packetmanager rollout status deploy packetmanager
echo Installed packetmanager-service

echo Instaling datashare services
cd datashare
./install.sh
cd ../
kubectl -n datashare rollout status deploy datashare
echo Instaling prereg services

cd prereg
./install.sh
cd ../
kubectl -n prereg rollout status deploy prereg-application
kubectl -n prereg rollout status deploy prereg-batchjob
kubectl -n prereg rollout status deploy prereg-booking
kubectl -n prereg rollout status deploy prereg-datasync
kubectl -n prereg rollout status deploy prereg-ui
echo Installed prereg services

echo Instaling idrepo services
cd idrepo
./install.sh
cd ../
kubectl -n idrepo rollout status deploy credential
kubectl -n idrepo rollout status deploy credentialrequest
kubectl -n idrepo rollout status deploy identity
kubectl -n idrepo rollout status deploy vid
echo Installed idrepo services

echo Instaling pms services
cd pms
./install.sh
cd ../
kubectl -n pms rollout status deploy pms-partner
kubectl -n pms rollout status deploy pms-policy
echo Installed pms services

echo Instaling mock-abis services
cd mock-abis
./install.sh
cd ../
kubectl -n abis rollout status deploy mock-abis
echo Installed mock-abis services

echo Instaling regproc services
cd regproc
./install.sh
cd ../
kubectl -n regproc rollout status deploy regproc-abishandler
kubectl -n regproc rollout status deploy regproc-abismid
kubectl -n regproc rollout status deploy regproc-bioauth
kubectl -n regproc rollout status deploy regproc-biodedupe
kubectl -n regproc rollout status deploy regproc-camel
kubectl -n regproc rollout status deploy regproc-demo
kubectl -n regproc rollout status deploy regproc-eis
kubectl -n regproc rollout status deploy regproc-external
kubectl -n regproc rollout status deploy regproc-manual
kubectl -n regproc rollout status deploy regproc-msg
kubectl -n regproc rollout status deploy regproc-osi
kubectl -n regproc rollout status deploy regproc-pktserver
kubectl -n regproc rollout status deploy regproc-print
kubectl -n regproc rollout status deploy regproc-quality
kubectl -n regproc rollout status deploy regproc-receiver
kubectl -n regproc rollout status deploy regproc-reprocess
kubectl -n regproc rollout status deploy regproc-status
kubectl -n regproc rollout status deploy regproc-trans
kubectl -n regproc rollout status deploy regproc-uin
kubectl -n regproc rollout status deploy regproc-uploader
kubectl -n regproc rollout status deploy regproc-validator
echo Installed regproc services

echo Instaling admin services
cd admin
./install.sh
cd ../
kubectl -n admin rollout status deploy admin-service
kubectl -n admin rollout status deploy admin-ui
echo Installed admin services

echo Instaling ida services
cd ida
./install.sh
cd ../
kubectl -n ida rollout status deploy ida-auth
kubectl -n ida rollout status deploy ida-internal
kubectl -n ida rollout status deploy ida-kyc
kubectl -n ida rollout status deploy ida-otp
echo Installed ida services

echo Instaling registration-client service
cd regclient
./install.sh
cd ../
kubectl -n regclient rollout status deploy regclient
echo regclient downloader deployed.

echo All the MOSIP services deployed sucessfully
