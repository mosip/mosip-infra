#!/usr/bin/env bash
# Usage: WG_DIR=<wg_dir> ./install.sh [+wg].
# If no argument then will install only nginx.

if [ -z $WG_DIR ]; then
  WG_DIR=.
fi
CURR_DIR=$(pwd)

if [ "$1" != "+wg" ]; then
  if [ -z "$rancher_nginx_certs" ]; then
    read -p "===>Give path for SSL Certificate for rancher.xyz.net (without any whitespaces) : " rancher_nginx_certs
    rancher_nginx_certs=$(sed 's/\//\\\//g' <<< $rancher_nginx_certs)
  fi
  if [ -z "$rancher_nginx_cert_key" ]; then
    read -p "===>Give path for SSL Certificate Key for rancher.xyz.net (without any whitespaces) : " rancher_nginx_cert_key
    rancher_nginx_cert_key=$(sed 's/\//\\\//g' <<< $rancher_nginx_cert_key)
  fi
  if [ -z "$rancher_cluster_node_ips" ]; then
    read -p "===>Give list of (comma seperated) ips of all nodes in the rancher cluster (without any whitespaces) : " rancher_cluster_node_ips
  fi
  if [ -z "$rancher_ingress_nodeport" ]; then
    unset to_replace
    rancher_ingress_nodeport="30080"
    read -p "===>Give nodeport of the rancher cluster ingresscontroller of rancher cluster (without any whitespaces) (default is 30080) : " to_replace
    rancher_ingress_nodeport=${to_replace:-$rancher_ingress_nodeport}
  fi
fi

if [ "$1" = "+wg" ]; then
  if [ -z "$wg_interface_ip" ]; then
    unset to_replace
    wg_interface_ip="10.13.0.1"
    echo -e "===>Give Wireguard server interface ip. Default is 10.13.0.1"
    read -p "But when running multiple replicas of nginx_wireguard node, one might want to choose an ip like 10.13.0.2. : " to_replace
    wg_interface_ip=${to_replace:-$wg_interface_ip}
  fi
  if [ -z "$wg_peers_no" ]; then
    read -p "===>Give number of peers in wireguard : " wg_peers_no
  fi
fi

# installing nginx
if [ "$1" != "+wg" ]; then
  cp dummy-ips-nginx.service /etc/systemd/system &&
  systemctl enable dummy-ips-nginx &&
  systemctl start dummy-ips-nginx &&
  apt install -y nginx &&
  while [ -z $rancher_nginx_ip ] ; do
    echo "Waiting For ip to get alloted"
    sleep 2s
    rancher_nginx_ip="$(ip -4 -o a show tap-nginx-lb0 | cut -d ' ' -f 7 | cut -d '/' -f 1)"
  done &&

  upstream_servers="" &&
  for ip in $(sed "s/,/\n/g" <<< $rancher_cluster_node_ips); do
    upstream_servers="${upstream_servers}server ${ip}:${rancher_ingress_nodeport};\n\t\t\t"
  done &&
  cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.orig &&
  cp nginx.conf.sample /etc/nginx/nginx.conf &&
  sed -i "s/<rancher-lb-ip>/$rancher_nginx_ip/g" /etc/nginx/nginx.conf &&
  sed -i "s/<rancher-ssl-certificate>/$rancher_nginx_certs/g" /etc/nginx/nginx.conf &&
  sed -i "s/<rancher-ssl-certificate-key>/$rancher_nginx_cert_key/g" /etc/nginx/nginx.conf &&
  sed -i "s/<rancher-nodeport-of-all-nodes>/$upstream_servers/g" /etc/nginx/nginx.conf &&
  systemctl restart nginx &&
  echo "Nginx Installation succesful"
fi

# installing wireguard as docker
if [ "$1" = "+wg" ]; then
  if ! [ -d $WG_DIR/wgbaseconf ]; then
    docker run -d \
    --name=wireguard \
    --cap-add=NET_ADMIN \
    --cap-add=SYS_MODULE \
    -e PUID=1000 \
    -e PGID=1000 \
    -e TZ=Asia/Calcutta\
    -e PEERS=$wg_peers_no \
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
  fi
  cp -r $WG_DIR/wgbaseconf $WG_DIR/wgconf &&
  docker run -d \
  --name=wireguard \
  --cap-add=NET_ADMIN \
  --cap-add=SYS_MODULE \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Asia/Calcutta\
  -e PEERS=$wg_peers_no \
  -p 51820:51820/udp \
  -v $WG_DIR/wgconf:/config \
  -v /lib/modules:/lib/modules \
  --sysctl="net.ipv4.conf.all.src_valid_mark=1" \
  --restart unless-stopped \
  ghcr.io/linuxserver/wireguard &&
  sleep 10s &&
  sed -i "s/Address.*/Address = $wg_interface_ip\/32/g" $WG_DIR/wgconf/wg0.conf &&
  sed -i "s/PostUp.*/PostUp = \/config\/rules.sh/g" $WG_DIR/wgconf/wg0.conf &&
  cp rules.sh.sample $WG_DIR/wgconf/rules.sh &&
  docker restart wireguard &&
  echo "Wireguard installation Complete"
fi
