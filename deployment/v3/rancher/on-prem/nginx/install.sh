#!/usr/bin/env bash
# Usage: WG_DIR=<wg_dir> ./install.sh [+wg].
# If no argument then will install only nginx.

if [ -z $WG_DIR ]; then
  WG_DIR=$(pwd)
fi
CURR_DIR=$(pwd)

if [ "$1" != "wg" ]; then
  if [ -z "$rancher_nginx_ip" ]; then
    echo -en "=====>\n The following internal ip will have to be DNS-mapped to rancher.xyz.net and iam.xyz.net.\n"
    echo -en "Give the internal interface ip of this node here. Run \`ip a\` to get all the interface addresses (without any whitespaces) : "
    read rancher_nginx_ip
  fi
  if [ -z "$rancher_nginx_certs" ]; then
    echo -en "=====>\nGive path for SSL Certificate for rancher.xyz.net (without any whitespaces) : "
    read rancher_nginx_certs
    rancher_nginx_certs=$(sed 's/\//\\\//g' <<< $rancher_nginx_certs)
  fi
  if [ -z "$rancher_nginx_cert_key" ]; then
    echo -en "=====>\nGive path for SSL Certificate Key for rancher.xyz.net (without any whitespaces) : "
    read rancher_nginx_cert_key
    rancher_nginx_cert_key=$(sed 's/\//\\\//g' <<< $rancher_nginx_cert_key)
  fi
  if [ -z "$rancher_cluster_node_ips" ]; then
    echo -en "=====>\nGive list of ips of all nodes in the rancher cluster (without any whitespaces, comma seperated) : "
    read rancher_cluster_node_ips
  fi
  if [ -z "$rancher_ingress_nodeport" ]; then
    unset to_replace
    rancher_ingress_nodeport="30080"
    echo -en "=====>\nGive nodeport of the ingresscontroller of rancher cluster (without any whitespaces) (default is 30080) : "
    read to_replace
    rancher_ingress_nodeport=${to_replace:-$rancher_ingress_nodeport}
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
    echo -en "=====>\nGive number of peers in wireguard : "
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

  upstream_servers="" &&
  for ip in $(sed "s/,/\n/g" <<< $rancher_cluster_node_ips); do
    upstream_servers="${upstream_servers}server ${ip}:${rancher_ingress_nodeport};\n\t\t"
  done &&
  cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.orig &&
  cp nginx.conf.sample /etc/nginx/nginx.conf &&
  sed -i "s/<rancher-lb-ip>/$rancher_nginx_ip/g" /etc/nginx/nginx.conf &&
  sed -i "s/<rancher-ssl-certificate>/$rancher_nginx_certs/g" /etc/nginx/nginx.conf &&
  sed -i "s/<rancher-ssl-certificate-key>/$rancher_nginx_cert_key/g" /etc/nginx/nginx.conf &&
  sed -i "s/<rancher-nodeport-of-all-nodes>/$upstream_servers/g" /etc/nginx/nginx.conf &&
  systemctl restart nginx &&
  echo "Nginx Installation succesful"
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
  echo "Wireguard installation Complete"
fi
