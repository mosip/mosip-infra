#!/bin/sh
# ./docker_build.sh git_tag
# TODO: Current git tag used is mosip-12620 (for current testing).  The changes in all scripts here need
# to be merged to main stream.
# To see the differences in the script that were made for deployment, take git diff between `develop` and `mosip-12620` # branch
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
docker build -t mosipdev/postgres-init:1.1.5 .


