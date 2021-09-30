#!/bin/sh
# ./docker_build.sh git_tag
# git_tag for all repos corresponding to postgres-init:1.2.0-rc1 is mosip-16601
# git_tag for all repos corresponding to postgres-init:1.2.0-rc2 is mosip-17836

mkdir -p repos
cd repos
git clone -b $1 https://github.com/mosip/commons 
git clone -b $1 https://github.com/mosip/pre-registration
git clone -b $1 https://github.com/mosip/registration
git clone -b $1 https://github.com/mosip/partner-management-services
git clone -b $1 https://github.com/mosip/id-authentication
git clone -b $1 https://github.com/mosip/id-repository
git clone -b $1 https://github.com/mosip/admin-services
cd ../
docker build -t mosipdev/postgres-init:1.2.0-rc2
