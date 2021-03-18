#!/bin/sh
# ./docker_build.sh git_tag

mkdir -p repos
cd repos
git clone -b $1 https://github.com/mosip/commons 
git clone -b $1 https://github.com/mosip/pre-registration
git clone -b $1 https://github.com/mosip/registration
git clone -b $1 https://github.com/mosip/partner-management-services
git clone -b $1 https://github.com/mosip/id-authentication
git clone -b $1 https://github.com/mosip/id-repository
git clone -b $1 https://github.com/mosip/websub
cd ../
docker build -t postgres-init .


