#!/bin/bash

# Log file path
echo "[ Set Log File ] : "
sudo mv /tmp/nginx-setup.log /tmp/nginx-setup.log.old || true
LOG_FILE="/tmp/nginx-setup.log"
ENV_FILE_PATH="/etc/environment"
source $ENV_FILE_PATH
env | grep cluster

# Redirect stdout and stderr to log file
exec > >(tee -a "$LOG_FILE") 2>&1

# set commands for error handling.
set -e
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errtrace  # trace ERR through 'time command' and other functions
set -o pipefail  # trace ERR through pipes

## Install Nginx, ssl dependencies
echo "[ Install nginx & ssl dependencies packages ] : "
sudo apt-get update
sudo apt install -y software-properties-common
sudo add-apt-repository universe
sudo apt update
sudo apt-get install nginx letsencrypt certbot python3-certbot-nginx python3-certbot-dns-route53 -y

## Get ssl certificate automatically
echo "[ Generate SSL certificates from letsencrypt  ] : "
sudo certbot certonly --dns-route53 -d "*.${mosip_domain}" -d "${mosip_domain}" --non-interactive --agree-tos --email "$certbot_email"

## start and enable Nginx
echo "[ Start & Enable nginx ] : "
sudo systemctl enable nginx
sudo systemctl start nginx

cd $working_dir
git clone $k8s_infra_repo_url -b $k8s_infra_branch || true # read it from variables
cd $nginx_location
./install.sh

