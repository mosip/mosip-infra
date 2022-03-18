#!/bin/sh
# Adds the secret to pull private dockers.
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

i=0
read -p "Do you want to add secrets for pulling docker image from private docker registory? (Y/n)" yn
while [ $yn = "Y" ]
do
i=$((i+1))
echo "Enter docker registry URL (e.g. https://index.docker.io/v1/ for dockerhub)"
read DOCKER_REGISTRY_URL
echo Enter  docker registry username
read USERNAME
echo Enter  docker registry Password/Token
read PASSWORD
echo Enter docker registry email account
read EMAIL
echo Creating docker secret
kubectl create secret docker-registry regsecret$i --docker-server=$DOCKER_REGISTRY_URL --docker-username=$USERNAME --docker-password=$PASSWORD --docker-email=$EMAIL
read -p "Do you want to add more secrets for pulling docker image from another private docker registory? (Y/n)" yn
done
