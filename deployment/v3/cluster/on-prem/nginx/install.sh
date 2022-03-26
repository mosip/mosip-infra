#!/usr/bin/env bash
# Script to install Nginx with public and private interfaces
# Usage: WG_DIR=<wg_dir> ./install.sh [+wg].
# +wg: Install Wiregaurd on the same Nginx machine. Optional.
# WG_DIR: Directory where all key files will be stored by Wireguard. Only applicable with +wg option

if [ -z $WG_DIR ]; then
  WG_DIR=.
fi
CURR_DIR=$(pwd)

if [ "$1" != "wg" ]; then
  if [ -z "$cluster_nginx_internal_ip" ]; then
    echo -en "=====>\nThe following internal ip will have to be DNS-mapped to all internal domains from you global_configmap.yaml. Ex: api-internal.mosip.xyz.net, iam.mosip.xyz.net, etc.\n"
    echo -en "Give the internal interface ip of this node here. Run \`ip a\` to get all the interface addresses (without any whitespaces) : "
    read cluster_nginx_internal_ip
  fi
  if [ -z "$cluster_nginx_public_ip" ]; then
    echo -en "=====>\nThis nginx's public ip will have to be DNS-mapped to all public domains from you global_configmap.yaml. Ex: api.mosip.xyz.net, prereg.mosip.xyz.net, etc.\nThe above mentioned nginx's public ip might be different from this nginx machine's public interface ip, if you have provisioned public ip seperately that might be forwarding traffic to this interface ip.\n"
    echo -en "Give the public interface ip of this node here. Run \`ip a\` to get all the interfaces : "
    read cluster_nginx_public_ip
  fi
  if [ -z "$cluster_nginx_certs" ]; then
    echo -en "=====>\nGive path for SSL Certificate for mosip.xyz.net (without any whitespaces) : "
    read cluster_nginx_certs
    cluster_nginx_certs=$(sed 's/\//\\\//g' <<< $cluster_nginx_certs)
  fi
  if [ -z "$cluster_public_domains" ]; then
    echo -en "=====>\nGive list of (comma seperated) publicly exposing domain names (without any whitespaces) : "
    read cluster_public_domains
  fi
  if [ -z "$cluster_nginx_cert_key" ]; then
    echo -en "=====>\nGive path for SSL Certificate Key for mosip.xyz.net (without any whitespaces) : "
    read cluster_nginx_cert_key
    cluster_nginx_cert_key=$(sed 's/\//\\\//g' <<< $cluster_nginx_cert_key)
  fi
  if [ -z "$cluster_node_ips" ]; then
    echo -en "=====>\nGive list of (comma seperated) ips of all nodes in the mosip cluster (without any whitespaces) : "
    read cluster_node_ips
  fi
  if [ -z "$cluster_ingress_public_nodeport" ]; then
    unset to_replace
    cluster_ingress_public_nodeport="30080"
    echo -en "=====>\nGive nodeport of http port of the mosip cluster public ingressgateway (without any whitespaces) (default is 30080) : "
    read to_replace
    cluster_ingress_public_nodeport=${to_replace:-$cluster_ingress_public_nodeport}
  fi
  if [ -z "$cluster_ingress_internal_nodeport" ]; then
    unset to_replace
    cluster_ingress_internal_nodeport="31080"
    echo -en "=====>\nGive nodeport of http port of the mosip cluster internal ingressgateway (without any whitespaces) (default is 31080) : "
    read to_replace
    cluster_ingress_internal_nodeport=${to_replace:-$cluster_ingress_internal_nodeport}
  fi
  if [ -z "$cluster_ingress_postgres_nodeport" ]; then
    unset to_replace
    cluster_ingress_postgres_nodeport="31432"
    echo -en "=====>\nGive nodeport of postgres port of the mosip cluster internal ingressgateway (without any whitespaces) (default is 31432) : "
    read to_replace
    cluster_ingress_postgres_nodeport=${to_replace:-$cluster_ingress_postgres_nodeport}
  fi
  if [ -z "$cluster_ingress_activemq_nodeport" ]; then
    unset to_replace
    cluster_ingress_activemq_nodeport="31616"
    echo -en "=====>\nGive nodeport of activemq port of the mosip cluster internal ingressgateway (without any whitespaces) (default is 31616) : "
    read to_replace
    cluster_ingress_activemq_nodeport=${to_replace:-$cluster_ingress_activemq_nodeport}
  fi
fi &&

if [ "$1" = "+wg" ] || [ "$1" = "wg" ]; then
  if [ -z "$wg_interface_ip" ]; then
    unset to_replace
    wg_interface_ip="10.13.0.1"
    echo -en "=====>\nGive Wireguard server interface ip. Default is 10.13.0.1\n"
    echo -en "But when running multiple replicas of nginx_wireguard node, one might want to choose an ip like 10.13.0.2. : "
    read to_replace
    wg_interface_ip=${to_replace:-$wg_interface_ip}
  fi
  if [ -z "$wg_peers_no" ]; then
    echo -en "=====>\nGive number of peers in wireguard: "
    read wg_peers_no
  fi
  if [ -z "$wg_peer_allowed_ips" ]; then
    unset to_replace
    wg_peer_allowed_ips="0.0.0.0/0"
    echo -en "=====>\nGive peers\' allowed ip range in wireguard (Default is 0.0.0.0/0) : "
    read wg_peer_allowed_ips
    wg_peer_allowed_ips=${to_replace:-$wg_peer_allowed_ips}
  fi
fi

# installing nginx
if [ "$1" != "wg" ]; then
  apt install -y nginx &&

  upstream_server_internal="" &&
  for ip in $(sed "s/,/\n/g" <<< $cluster_node_ips); do
    upstream_server_internal="${upstream_server_internal}server ${ip}:${cluster_ingress_internal_nodeport};\n\t\t"
  done &&
  upstream_server_public="" &&
  for ip in $(sed "s/,/\n/g" <<< $cluster_node_ips); do
    upstream_server_public="${upstream_server_public}server ${ip}:${cluster_ingress_public_nodeport};\n\t\t"
  done &&
  upstream_server_postgres="" &&
  for ip in $(sed "s/,/\n/g" <<< $cluster_node_ips); do
    upstream_server_postgres="${upstream_server_postgres}server ${ip}:${cluster_ingress_postgres_nodeport};\n\t\t"
  done &&
  upstream_server_activemq="" &&
  for ip in $(sed "s/,/\n/g" <<< $cluster_node_ips); do
    upstream_server_activemq="${upstream_server_activemq}server ${ip}:${cluster_ingress_activemq_nodeport};\n\t\t"
  done &&
  for domain in $(sed "s/,/\n/g" <<< $cluster_domain_names); do
    upstream_public_domain_names="${upstream_public_domain_names} ${domain}"
  done &&
  cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.orig &&
  cp nginx.conf.sample /etc/nginx/nginx.conf &&
  sed -i "s/<cluster-nodeport-public-of-all-nodes>/$upstream_server_public/g" /etc/nginx/nginx.conf &&
  sed -i "s/<cluster-nodeport-internal-of-all-nodes>/$upstream_server_internal/g" /etc/nginx/nginx.conf &&
  sed -i "s/<cluster-ssl-certificate>/$cluster_nginx_certs/g" /etc/nginx/nginx.conf &&
  sed -i "s/<cluster-ssl-certificate-key>/$cluster_nginx_cert_key/g" /etc/nginx/nginx.conf &&
  sed -i "s/<cluster-nginx-internal-ip>/$cluster_nginx_internal_ip/g" /etc/nginx/nginx.conf &&
  sed -i "s/<cluster-nginx-public-ip>/$cluster_nginx_public_ip/g" /etc/nginx/nginx.conf &&
  sed -i "s/<cluster-nodeport-postgres-of-all-nodes>/$upstream_server_postgres/g" /etc/nginx/nginx.conf &&
  sed -i "s/<cluster-nodeport-activemq-of-all-nodes>/$upstream_server_activemq/g" /etc/nginx/nginx.conf &&
  sed -i "s/<cluster-public-domain-names>/$upstream_public_domain_names/g" /etc/nginx/nginx.conf &&
#  systemctl restart nginx &&
#  echo "Nginx installed succesfully."
fi &&

# installing wireguard as docker
if [ "$1" = "+wg" ] || [ "$1" = "wg" ]; then
  if ! [ -d $WG_DIR/wgbaseconf ]; then
    IFS=. read -r i1 i2 i3 i4 <<< "$wg_interface_ip" &&
    docker run -d \
    --name=wireguard \
    --cap-add=NET_ADMIN \
    --cap-add=SYS_MODULE \
    -e PUID=1000 \
    -e PGID=1000 \
    -e TZ=Asia/Calcutta\
    -e PEERS=$wg_peers_no \
    -e INTERNAL_SUBNET="$i1.$i2.$i3.0" \
    -e ALLOWEDIPS="$wg_peer_allowed_ips" \
    -p 51820:51820/udp \
    -v $WG_DIR/wgbaseconf:/config \
    -v /lib/modules:/lib/modules \
    --sysctl="net.ipv4.conf.all.src_valid_mark=1" \
    --restart unless-stopped \
    ghcr.io/linuxserver/wireguard &&
    sleep 10s &&
    docker rm -f wireguard &&
    cd $WG_DIR/wgbaseconf &&
    sudo chown -R $USER:$USER .
    rm -rf peer*/*.conf peer*/*.png server templates &&
    rm -rf cored* custom-* &&
    cd $CURR_DIR
  fi &&
  cp -r $WG_DIR/wgbaseconf $WG_DIR/wgconf &&
  IFS=. read -r i1 i2 i3 i4 <<< "$wg_interface_ip" &&
  docker run -d \
  --name=wireguard \
  --cap-add=NET_ADMIN \
  --cap-add=SYS_MODULE \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Asia/Calcutta\
  -e PEERS=$wg_peers_no \
  -e INTERNAL_SUBNET="$i1.$i2.$i3.0" \
  -e ALLOWEDIPS="$wg_peer_allowed_ips" \
  -p 51820:51820/udp \
  -v $WG_DIR/wgconf:/config \
  -v /lib/modules:/lib/modules \
  --sysctl="net.ipv4.conf.all.src_valid_mark=1" \
  --restart unless-stopped \
  ghcr.io/linuxserver/wireguard &&
  sleep 10s &&
  cp rules.sh.sample $WG_DIR/wgconf/rules.sh &&
  sed -i "s/PostUp.*\n/PostUp = \/config\/rules.sh/g" $WG_DIR/wgconf/wg0.conf &&
  docker restart wireguard &&
  echo "Wireguard installation complete"
fi
