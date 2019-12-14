#!/bin/sh
# Following are needed before launcher is run
sudo yum install -y gcc
sudo yum install -y gcc-c++
sudo yum install -y https://centos7.iuscommunity.org/ius-release.rpm
sudo yum update
sudo yum install -y python36u python36u-libs python36u-devel python36u-pip
sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo yum install -y maven
sudo yum install -y postgresql-devel
sudo yum install -y python-devel
sudo yum install -y telnet
sudo pip3.6 install psutil
sudo pip3.6 install psycopg2
sudo pip3.6 install requests
sudo pip3.6 install pycrypto
sudo yum install -y openldap-devel
sudo pip3.6 install python-ldap
timedatectl set-timezone UTC # TODO: remove after regproc patch  
sudo groupadd docker
sudo usermod -a -G docker $USER # Give docker access to current user
exec su -l $USER  # Log out
