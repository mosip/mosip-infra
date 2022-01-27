#!/bin/sh

sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo yum install -y ansible
ansible-galaxy collection install ansible.netcommon
ansible-galaxy collection install community.crypto
sudo yum install -y tmux 
sudo yum install -y vim
sudo yum install -y nano
cp $HOME/mosip-infra/deployment/sandbox-v2/utils/tmux.conf $HOME/.tmux.conf

echo "alias an='ansible-playbook -i hosts.ini --ask-vault-pass -e @secrets.yml'" >> $HOME/.bashrc
echo "alias av='ansible-vault'" >> $HOME/.bashrc
echo "alias kc1='kubectl --kubeconfig $HOME/.kube/mzcluster.config'" >> $HOME/.bashrc
echo "alias kc2='kubectl --kubeconfig $HOME/.kube/dmzcluster.config'" >> $HOME/.bashrc
echo "alias kcp='kubectl -n packetmanager --kubeconfig $HOME/.kube/mzcluster.config'" >> $HOME/.bashrc
echo "alias sb='cd $HOME/mosip-infra/deployment/sandbox-v2/'" >> $HOME/.bashrc
echo "alias helm1='helm --kubeconfig $HOME/.kube/mzcluster.config'" >> $HOME/.bashrc
echo "alias helm2='helm --kubeconfig $HOME/.kube/dmzcluster.config'" >> $HOME/.bashrc
echo "alias helmm='helm --kubeconfig $HOME/.kube/mzcluster.config -n monitoring'" >> $HOME/.bashrc
echo "alias helmp='helm --kubeconfig $HOME/.kube/mzcluster.config -n packetmanager'" >> $HOME/.bashrc
echo "alias kcm='kubectl -n monitoring --kubeconfig $HOME/.kube/mzcluster.config'" >> $HOME/.bashrc
