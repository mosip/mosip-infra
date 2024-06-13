terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.48.0"
    }
  }
}

# provider "aws" {
# Profile `default` means it will take credentials AWS_SITE_KEY & AWS_SECRET_EKY from ~/.aws/config under `default` section.
# profile = "default"
# region = "ap-south-1"
# }
provider "aws" {
  region = var.AWS_PROVIDER_REGION
}

module "aws-resource-creation" {
  source = "./modules/aws-resource-creation"
  CLUSTER_NAME        = var.CLUSTER_NAME
  AWS_PROVIDER_REGION = var.AWS_PROVIDER_REGION
  SSH_KEY_NAME        = var.SSH_KEY_NAME
  K8S_INSTANCE_TYPE   = var.K8S_INSTANCE_TYPE
  NGINX_INSTANCE_TYPE = var.NGINX_INSTANCE_TYPE
  MOSIP_DOMAIN        = var.MOSIP_DOMAIN
  ZONE_ID             = var.ZONE_ID
  AMI                 = var.AMI

  SECURITY_GROUP = local.SECURITY_GROUP
}

module "nginx-setup" {
  depends_on                              = [module.aws-resource-creation]
  source                                  = "./modules/nginx-setup"
  NGINX_PUBLIC_IP                         = module.aws-resource-creation.NGINX_PUBLIC_IP
  MOSIP_DOMAIN                            = var.MOSIP_DOMAIN
  MOSIP_K8S_CLUSTER_NODES_PRIVATE_IP_LIST = module.aws-resource-creation.MOSIP_K8S_CLUSTER_NODES_PRIVATE_IP_LIST
  MOSIP_PUBLIC_DOMAIN_LIST                = module.aws-resource-creation.MOSIP_PUBLIC_DOMAIN_LIST
  CERTBOT_EMAIL                           = var.MOSIP_EMAIL_ID
  SSH_PRIVATE_KEY = var.SSH_PRIVATE_KEY
}
