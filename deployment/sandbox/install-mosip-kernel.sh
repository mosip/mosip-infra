# ------------------------------------------------------------
# This shell script installs the MOSIP Kernel
# This script should be executed before other install scripts.
# ------------------------------------------------------------


hostIp=$(curl ifconfig.me)
sudo apt-get install software-properties-common
sudo apt-add-repository ppa:ansible/ansible -y
sudo apt-get update
sudo apt-get -y install ansible
echo "$hostIp"
sed -i "/VMIP=/ s/=.*/=$hostIp/" playbooks-properties/all-playbooks.properties
sed -i "s/<yourVMIP>/$hostIp/" dev
# sudo su <<HERE
echo "$HOME"
ansible-playbook  playbooks/mosip-sandbox-kernel-launcher.yml
# HERE
