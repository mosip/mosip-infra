variable "AWS_PROVIDER_REGION" { type = string }
variable "CLUSTER_NAME" { type = string }
variable "SSH_KEY_NAME" { type = string }
variable "K8S_INSTANCE_COUNT" { type = number }
variable "SECURITY_GROUP" {
  type = map(list(object({
    description      = string
    from_port        = number
    to_port          = number
    protocol         = string
    cidr_blocks      = list(string)
    ipv6_cidr_blocks = list(string)
    }
  )))
}
variable "K8S_INSTANCE_TYPE" {
  type = string
  validation {
    condition     = can(regex("^[a-z0-9]+\\..*", var.K8S_INSTANCE_TYPE))
    error_message = "Invalid instance type format. Must be in the form 'series.type'."
  }
}
variable "AMI" {
  type = string
  validation {
    condition     = can(regex("^ami-[a-f0-9]{17}$", var.AMI))
    error_message = "Invalid AMI format. It should be in the format 'ami-xxxxxxxxxxxxxxxxx'"
  }
}
variable "NGINX_INSTANCE_TYPE" {
  type = string
  validation {
    condition     = can(regex("^[a-z0-9]+\\..*", var.NGINX_INSTANCE_TYPE))
    error_message = "Invalid instance type format. Must be in the form 'series.type'."
  }
}
variable "MOSIP_DOMAIN" { type = string }
variable "ZONE_ID" { type = string }

variable "DNS_RECORDS" {
  description = "A map of DNS records to create"
  type = map(object({
    name             = string
    type             = string
    zone_id          = string
    ttl              = number
    records          = string
    allow_overwrite  = bool
    # health_check_id = string // Uncomment if using health checks
  }))
}
locals {
  MAP_DNS_TO_IP = {
    API_DNS = {
      name    = "api.${var.MOSIP_DOMAIN}"
      type    = "A"
      zone_id = var.ZONE_ID
      ttl     = 300
      records = aws_instance.NGINX_EC2_INSTANCE.tags.Name == local.TAG_NAME.NGINX_TAG_NAME ? aws_instance.NGINX_EC2_INSTANCE.public_ip : ""
      #health_check_id = true
      allow_overwrite = true
    }
    API_INTERNAL_DNS = {
      name    = "api-internal.${var.MOSIP_DOMAIN}"
      type    = "A"
      zone_id = var.ZONE_ID
      ttl     = 300
      records = aws_instance.NGINX_EC2_INSTANCE.tags.Name == local.TAG_NAME.NGINX_TAG_NAME ? aws_instance.NGINX_EC2_INSTANCE.private_ip : ""
      #health_check_id = true
      allow_overwrite = true
    }
  }
}

# NGINX TAG NAME VARIABLE
locals {
  TAG_NAME = {
    NGINX_TAG_NAME = "${var.CLUSTER_NAME}-NGINX-NODE"
  }
}


# EC2 INSTANCE DATA: NGINX & K8S NODES
locals {
  NGINX_INSTANCE = {
    ami                         = var.AMI
    instance_type               = var.NGINX_INSTANCE_TYPE
    associate_public_ip_address = true
    key_name                    = var.SSH_KEY_NAME
    user_data =<<-EOF
#!/bin/bash

# Log file path
echo "[ Set Log File ] : "
LOG_FILE="/tmp/ebs-volume-mount.log"

# Redirect stdout and stderr to log file
exec > >(tee -a "$LOG_FILE") 2>&1

# set commands for error handling.
set -e
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errtrace  # trace ERR through 'time command' and other functions
set -o pipefail  # trace ERR through pipes

## Mount EBS volume
echo "[ Mount EBS volume to /srv/nfs directory ] : "
file -s /dev/xvdb
mkfs -t xfs /dev/xvdb
mkdir -p /srv/nfs
echo "/dev/xvdb    /srv/nfs xfs  defaults,nofail  0  2" >> /etc/fstab
mount -a
EOF
    tags = {
      Name    = local.TAG_NAME.NGINX_TAG_NAME
      Cluster = var.CLUSTER_NAME
    }
    security_groups = [
      aws_security_group.security-group["NGINX_SECURITY_GROUP"].id
    ]

    root_block_device = {
      volume_size           = 30
      volume_type           = "gp3"
      delete_on_termination = true
      encrypted             = false
      tags = {
        Name    = local.TAG_NAME.NGINX_TAG_NAME
        Cluster = var.CLUSTER_NAME
      }
    }
    ebs_block_device = [{
      device_name           = "/dev/sdb"
      volume_size           = 10
      volume_type           = "gp3"
      delete_on_termination = true
      encrypted             = false
      tags = {
        Name    = local.TAG_NAME.NGINX_TAG_NAME
        Cluster = var.CLUSTER_NAME
      }
    }]
  }
  K8S_EC2_NODE = {
    ami                         = var.AMI
    instance_type               = var.K8S_INSTANCE_TYPE
    associate_public_ip_address = true
    key_name                    = var.SSH_KEY_NAME
    count                       = var.K8S_INSTANCE_COUNT
    tags = {
      Name    = "${var.CLUSTER_NAME}-node"
      Cluster = var.CLUSTER_NAME
    }
    security_groups = [
      aws_security_group.security-group["K8S_SECURITY_GROUP"].id
    ]

    root_block_device = {
      volume_size           = 30
      volume_type           = "gp3"
      delete_on_termination = true
      encrypted             = false

    }
  }
}
