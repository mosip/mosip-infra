#!/bin/sh
# Following are needed before launcher is run
sudo yum install -y gcc
sudo yum install -y https://repo.ius.io/ius-release-el7.rpm
sudo yum update
sudo yum install -y python36u python36u-libs python36u-devel python36u-pip
sudo groupadd docker
sudo usermod -a -G docker $USER # Give docker access to current user
exec su -l $USER  # Log out
