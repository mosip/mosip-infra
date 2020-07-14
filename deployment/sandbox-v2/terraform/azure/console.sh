#!/bin/bash
#need to change this to console machine password to execute all commands before running the terraform script.
PW=Password@123

echo "------------ Generating the SSH-Key on Console Machine -------------"

ssh-keygen -b 2048 -t rsa -f ~/.ssh/id_rsa -q -N ''

echo " ------------- Installing Ansible on Console Machine ---------------"

echo "$PW" | sudo -E -S yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
echo $PW | sudo yum install ansible -y

echo "------------- Installing GIT on Console Machine ------------"

echo $PW | sudo yum install -y git

echo "-------------- Disabling FirewallD -----------------"

echo $PW | sudo systemctl stop firewalld
echo $PW | sudo systemctl disable firewalld 

echo "------------------- Injecting Aliases ----------------------------"

echo "###################################################################################################" >> $HOME/.bashrc
echo "# Aliases" >> $HOME/.bashrc
echo "###################################################################################################" >> $HOME/.bashrc
echo "alias an='ansible-playbook -i hosts.ini'" >> $HOME/.bashrc
echo "alias kc1='kubectl --kubeconfig $HOME/.kube/mzcluster.config'" >> $HOME/.bashrc
echo "alias kc2='kubectl --kubeconfig $HOME/.kube/dmzcluster.config'" >> $HOME/.bashrc
echo "alias sb='cd $HOME/mosip-infra/deployment/sandbox-v2/'" >> $HOME/.bashrc
echo "alias helm1='helm --kubeconfig $HOME/.kube/mzcluster.config'" >> $HOME/.bashrc
echo "alias helm2='helm --kubeconfig $HOME/.kube/dmzcluster.config'" >> $HOME/.bashrc
source  ~/.bashrc

echo "----------------- Adding Mosipuser to Sudoers file -------------------------"

sudo -i <<'EOF'
ls
echo "I am root now"
echo 'mosipuser ALL=(ALL)  NOPASSWD: ALL' >> /etc/sudoers
yum install tmux -y
cp /utils/tmux.conf ~/.tmux.conf
mkdir -p ~/.ssh
touch ~/.ssh/authorized_keys
echo "-------------------- Copying mosipuser key to root --------------------------"
cat /home/mosipuser/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

exit
EOF


