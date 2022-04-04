# REDIS Server

## Overview
* Redis cache is used by packetmanager to temporarily store objets from Minio. 
* By default MOSIP installation comes with hazlecast cache, the same can be changed optionally with Redis Cache.

## Server Installation
1. Download the Redis tar file 
```
wget http://download.redis.io/redis-stable.tar.gz
```
2. Unzip the redis tar file and execute below commands:
```
tar xvzf redis-stable.tar.gz
cd redis-stable
sudo yum install make gcc tcl -y
```
3. Build the program using source code
```
make
## In case make fails use below command to fix the same.
make distclear
```
4. Move the Redis source code as system service using below commands:
```
mkdir -p /etc/redis/
cp src/redis-server /etc/redis
cp src/redis-cli /etc/redis
cp redis.conf /etc/redis
```
## Redis service creation and start
1. Create Redis service file using below commands:
```
nano /etc/systemd/system/redis.service
```
add below contents into the service file
```
[Unit]
 Description=Redis service
[Service]
 ExecStart=/etc/redis/redis-server /etc/redis/redis.conf
[Install]
 WantedBy=default.target
```
2. Change the permission of the file
```
chmod  664 /etc/system/system/redis.service
```
3. Reload all unit files to make systemd know about the new service
```
systemctl daemon-reload
```
4. Starting the service
```
systemctl start redis
```
5. Check the status
```
systemctl status redis
```
## Redis server Configuration
1. Changes to be done in `redis.conf` file
```
vim /etc/redis/redis.conf
```
2. Changes in redis.conf file
```
protected-mode no                                                                           ## Change protected mode yes to  no,
bind 0.0.0.0                                                                                ## Change/comment “bind 127.0.0.1 -::1” 
supervised auto                                                                             ## Uncomment the “supervised auto”
```
3. Save and restart the redis service
```
systemctl restart redis
```
4. Add below paramenters in `application-mz.properties` filr in mosip-config
```
redis.cache.hostname=<ip of redis server>
redis.cache.port=6379
# Time to live for 30 mins
spring.cache.redis.time-to-live=10800000
```
5. Update the cache provider URL in `groups_var/all.yml` as below
```
cache_provider_url: http://artifactory-service.default:80/artifactory/libs-release-local/cache/redis-cache-provider.jar
```
6. Make sure you have the latest artifactory `tag: 1.1.5.5` image being pulled by artifactory service. You can also restart the same to get the latest image and then redeploy the packetmanager.

## Reference:
1. Redis installation - https://redis.io/topics/quickstart
2. Making Redis Service - https://www.opentechguides.com/how-to/article/centos/169/systemd-custom-service.html
