#!/bin/bash
echo deleting MOSIP services

cd config_server 
./delete.sh
cd ../
echo Deleted Config Server

cd artifactory
./delete.sh
cd ../

cd keymanager
./delete.sh
cd ../

cd websub
./delete.sh
cd ../

cd kernel
./delete.sh
cd ../

cd packetmanager
./delete.sh
cd ../

cd datashare
./delete.sh
cd ../

cd prereg
./delete.sh
cd ../

cd idrepo
./delete.sh
cd ../

cd pms
./delete.sh
cd ../

cd mock-abis
./delete.sh
cd ../

cd regproc
./delete.sh
cd ../

cd admin
./delete.sh
cd ../

cd ida
./delete.sh
cd ../

cd regclient
./delete.sh
cd ../
