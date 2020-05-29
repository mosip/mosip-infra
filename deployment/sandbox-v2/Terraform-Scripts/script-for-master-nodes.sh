#!/bin/bash

PW=Provide password

echo "------------------- Disabling FirewallD ----------------------------"

echo "$PW" | sudo -E -S systemctl stop firewalld
echo "$PW" | sudo -E -S systemctl disable firewalld 

echo "------------------- Copying the SSH-Key to all the master and nodes root account ------------------"
sudo -i <<'EOF'
ls
echo "I am root now"
echo 'mosipuser ALL=(ALL)  NOPASSWD: ALL' >> /etc/sudoers
mkdir -p ~/.ssh
touch ~/.ssh/authorized_keys
echo "-------------------- Copying mosipuser key to root --------------------------"
cat /home/mosipuser/key >> ~/.ssh/authorized_keys
exit
EOF

