#!/usr/bin/env bash
# Usage: ./install.sh [<nginx>/<wg>].
# WIP: Dont use ... yet
# If no argument then will install both.

# installing nginx
if [ $1 = "nginx" ] || [ -z $1 ]; then
  unset rancher_nginx_ip
  read -p "Give an ip for rancher.xyz.net " rancher_nginx_ip
  sudo apt install -y nginx &&
  sudo cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.orig &&
  sudo cp nginx.conf.sample /etc/nginx/nginx.conf &&
  sudo sed -i "s/<rancher-lb-ip>/$rancher_nginx_ip/g" /etc/nginx/nginx.conf &&
  sudo systemctl restart nginx &&
  echo "Nginx Installation succesful"
fi

# installing wireguard as docker
if [ $1 = "wg" ] || [ -z $1 ]; then
  read -p "Give number of peers in wireguard " wireguard_peers_no
  docker run -d \
  --name=wireguard \
  --cap-add=NET_ADMIN \
  --cap-add=SYS_MODULE \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Asia/Calcutta\
  -e PEERS=$wireguard_peers_no \
  -p 51820:51820/udp \
  -v $(pwd)/wgconf:/config \
  -v /lib/modules:/lib/modules \
  --sysctl="net.ipv4.conf.all.src_valid_mark=1" \
  --restart unless-stopped \
  ghcr.io/linuxserver/wireguard &&
  sleep 10s &&
  mv wgconf wgbaseconf &&
  sudo chown -R $USER:$USER wgbaseconf
  docker rm -f wireguard &&
  cd wgbaseconf &&
  rm -rf peer*/*.conf server templates &&
  rm -rf cored* custom-* &&
  cd .. &&
  cp -r wgbaseconf wgconf &&
  docker run -d \
  --name=wireguard \
  --cap-add=NET_ADMIN \
  --cap-add=SYS_MODULE \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Asia/Calcutta\
  -e PEERS=$wireguard_peers_no \
  -p 51820:51820/udp \
  -v $(pwd)/wgconf:/config \
  -v /lib/modules:/lib/modules \
  --sysctl="net.ipv4.conf.all.src_valid_mark=1" \
  --restart unless-stopped \
  ghcr.io/linuxserver/wireguard &&
  echo "Wireguard installation Complete"
fi
