#!/bin/sh
docker build --tag config-server:1.0 --build-arg config_git_path=/mnt/config .
