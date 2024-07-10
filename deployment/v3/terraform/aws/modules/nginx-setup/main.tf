variable "NGINX_PUBLIC_IP" { type = string }
variable "MOSIP_DOMAIN" { type = string }
variable "MOSIP_K8S_CLUSTER_NODES_PRIVATE_IP_LIST" { type = string }
variable "MOSIP_PUBLIC_DOMAIN_LIST" { type = string }
variable "CERTBOT_EMAIL" { type = string }
variable "SSH_PRIVATE_KEY" { type = string }

locals {
  NGINX_CONFIG = {
    mosip_domain = var.MOSIP_DOMAIN
    env_var_file = "/etc/environment"
    cluster_nginx_certs="/etc/letsencrypt/live/${var.MOSIP_DOMAIN}/fullchain.pem"
    cluster_nginx_cert_key="/etc/letsencrypt/live/${var.MOSIP_DOMAIN}/privkey.pem"
    cluster_node_ips=var.MOSIP_K8S_CLUSTER_NODES_PRIVATE_IP_LIST
    cluster_public_domains=var.MOSIP_PUBLIC_DOMAIN_LIST
    cluster_ingress_public_nodeport="30080"
    cluster_ingress_internal_nodeport="31080"
    cluster_ingress_postgres_nodeport="31432"
    cluster_ingress_minio_nodeport="30900"
    cluster_ingress_activemq_nodeport="31616"
    certbot_email=var.CERTBOT_EMAIL
    k8s_infra_repo_url="https://github.com/mosip/k8s-infra.git"
    k8s_infra_branch="main"
    working_dir="/home/ubuntu/"
    nginx_location="./k8s-infra/mosip/on-prem/nginx"
  }

  nginx_env_vars = [
    for key, value in local.NGINX_CONFIG :
    "echo 'export ${key}=${value}' | sudo tee -a ${local.NGINX_CONFIG.env_var_file}"
  ]
}

resource "null_resource" "Nginx-setup" {
  triggers = {
    # node_count_or_hash = module.ec2-resource-creation.node_count
    # or if you used hash:
    node_hash = md5(var.MOSIP_K8S_CLUSTER_NODES_PRIVATE_IP_LIST)
    public_dns_hash = md5(var.MOSIP_PUBLIC_DOMAIN_LIST)
  }
  connection {
    type        = "ssh"
    host        = var.NGINX_PUBLIC_IP
    user        = "ubuntu" # Change based on the AMI used
    private_key = var.SSH_PRIVATE_KEY # content of your private key
  }
  provisioner file {
    source = "${path.module}/nginx-setup.sh"
    destination = "/tmp/nginx-setup.sh"
  }
  provisioner "remote-exec" {
    inline = concat(
        local.nginx_env_vars,
        [
          "echo \"export cluster_nginx_internal_ip=\"$(curl http://169.254.169.254/latest/meta-data/local-ipv4)\"\" | sudo tee -a ${local.NGINX_CONFIG.env_var_file}",
          "echo \"export cluster_nginx_public_ip=\"$(curl http://169.254.169.254/latest/meta-data/local-ipv4)\"\" | sudo tee -a ${local.NGINX_CONFIG.env_var_file}",
          "sudo chmod +x /tmp/nginx-setup.sh",
          "sudo bash /tmp/nginx-setup.sh"
        ]
      )
  }
}