#!/bin/sh
# ./docker_build.sh git_tag
# git_tag for all repos corresponding to postgres-init:1.2.0-rc1 is mosip-16601
# git_tag for all repos corresponding to postgres-init:1.2.0-rc2 is mosip-17836

TAG=mosipdev/postgres-init:1.2.0-rc2
echo Building $TAG
docker build --no-cache -t $TAG .
