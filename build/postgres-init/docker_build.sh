#!/bin/sh
# ./docker_build.sh git_tag

mkdir -p repos
cd repos
git clone -b $1 https://github.com/mosip/commons 
git clone -b $1 https://github.com/mosip/pre-registration
cd ../
docker build -t postgres-init .


