## Introduction
WireGuard is a secure network tunnel, operating at layer 3, implemented as a kernel virtual network
interface for Linux, which aims to replace both IPsec for most use cases, as well as popular user space and/or TLS-based solutions like OpenVPN, while being more secure, more performant, and easier to use.  
In current sandbox-v2 installation, we're providing a mechanism to configure and use WireGuard to secure sandbox from external access.  

## Prerequisites
- A load-balancing node to facilitate server: ```console.sb``` in our case
- Kernel : 3.10.0-1160.15.2.el7.centos.plus.x86_64
- OS: CentOS 7
**Note**: OS and Kernel version requirement is met from terraform.

## Procedure
### At server:
1. Install WireGuard:  
A signed module is available as built-in to CentOS's kernel-plus. Run these sequence of commands:
	```
	$ sudo yum install yum-utils epel-release
	$ sudo yum-config-manager --setopt=centosplus.includepkgs=kernel-plus --enablerepo=centosplus --save
	$ sudo sed -e 's/^DEFAULTKERNEL=kernel$/DEFAULTKERNEL=kernel-plus/' -i /etc/sysconfig/kernel
	$ sudo yum install kernel-plus wireguard-tools
	$ sudo reboot
	```

2. Generate private and public keys:
	 ```
	 $ umask 077
	 $ wg genkey | tee server_private_key | wg pubkey > server_public_key
	(store them):
			a. private_key: <encoded-text>
			b. public_key: <encoded-text>
3. Generate server configuration file:
	```$ vi /etc/wireguard/wg0.conf```  
	The configuration file should be over-written with below set of lines:
	```
	[Interface]
	Address = 10.100.100.1/24
	SaveConfig = true
	PrivateKey = <private-key-of-server>
	ListenPort = 51820
	PostUp = iptables -A FORWARD -i %i -j ACCEPT; iptables -A FORWARD -o %i -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

	PostDown = iptables -D FORWARD -i %i -j ACCEPT; iptables -D FORWARD -o %i -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE

	[Peer]
	PublicKey = <public-key-of-client>
	AllowedIPs = 10.100.100.2/32
	```
	**Note**: 
	- Peers here can be multiple, as many clients we want to add.
	- Default port for wireguard is 51820, it's an UDP port not TCP.

4. Enable IPv4 Forwarding:  
Enable IPv4 forwarding so that we can access the rest of the LAN and not just the server itself.  
Open ```/etc/sysctl.conf``` and comment out the following line  ```net.ipv4.ip_forward=1```  

5. Restart the server, or use the following commands for the IP forwarding to take effect without restarting the server:
	```
	$ sysctl -p  
	$ echo 1 > /proc/sys/net/ipv4/ip_forward
	```
6. Start WireGuard on the Server and enable WireGuard to start automatically when the server starts.
	```
	$ sudo chown -v root:root /etc/wireguard/wg0.conf
	$ sudo chmod -v 600 /etc/wireguard/wg0.conf
	$ wg-quick up wg0
	$ sudo systemctl enable wg-quick@wg0.service
	```
### At client:
1. Install wireguard:  
Client OS may be different from CentOS 7, so whichever OS is it, you may install WireGuard for any OS from [here](https://www.wireguard.com/install/) .
2. Generate private and public keys:
	 ```
	 $ wg genkey | tee client_private_key | wg pubkey > client_public_key
	(store them):
			a. private_key: <encoded-text>
			b. public_key: <encoded-text>
	```  
3. Generate client configuration file:
	```$ vi /etc/wireguard/wg0-client.conf```  
	The configuration file should be over-written with below set of lines:
	```
		[Interface]
		Address = 10.100.100.2/32
		PrivateKey = <private-key-of-client>  
		
		[Peer]
		PublicKey = <public-key-of-server>
		Endpoint = <private-ip-of-server>:51820
		AllowedIPs = 0.0.0.0/0
		PersistentKeepalive = 21
	```
**Note**:
 - Endpoint is optional here. It'll be updated automatically at the time of handshake.
 - Allowed IPs with value ```0.0.0.0/0``` will route all the traffic through the wireguard interface and will disable SSH if client is a VM.
 - Allowed IPs may be replaced with alternate address available as follows:  
      - If client is inside subnet of server: internal IP of server may be used.
      - If client is outside subnet in some other network: external IP of server may be used. 

4. Start wireguard on client : ``` $ sudo wg-quick up wg0-client```

### Note:
- To stop WireGuard on server: 
	``` $ sudo wg-quick down  wg0```
- To show WireGuard status and clients' list:
   ```$ sudo wg show```
-  To stop WireGuard on client / disconnect client from server: 
	``` $ sudo wg-quick down wg0-client```
