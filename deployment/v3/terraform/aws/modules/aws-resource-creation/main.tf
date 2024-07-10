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

resource "aws_security_group" "security-group" {
  for_each = var.SECURITY_GROUP
  tags = {
    Name    = "${var.CLUSTER_NAME}-${each.key}"
    Cluster = var.CLUSTER_NAME
  }
  description = "Rules which allow the outgoing traffic from the instances associated with the security group ${each.key}"

  dynamic "ingress" {
    for_each = each.value
    iterator = port
    content {
      description      = port.value.description
      from_port        = port.value.from_port
      to_port          = port.value.to_port
      protocol         = port.value.protocol
      cidr_blocks      = port.value.cidr_blocks
      ipv6_cidr_blocks = port.value.ipv6_cidr_blocks
    }
  }
  egress {
    description      = "Rules which allow the incoming traffic to the instances associated with the security group."
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_instance" "NGINX_EC2_INSTANCE" {

  ami                         = local.NGINX_INSTANCE.ami
  instance_type               = local.NGINX_INSTANCE.instance_type
  associate_public_ip_address = lookup(local.NGINX_INSTANCE, "associate_public_ip_address", false)
  key_name                    = local.NGINX_INSTANCE.key_name
  user_data                   = lookup(local.NGINX_INSTANCE, "user_data", "")
  vpc_security_group_ids      = local.NGINX_INSTANCE.security_groups

  ## for ssl certificate generation
  iam_instance_profile = aws_iam_instance_profile.certbot_profile.name


  root_block_device {
    volume_size           = local.NGINX_INSTANCE.root_block_device.volume_size
    volume_type           = local.NGINX_INSTANCE.root_block_device.volume_type
    delete_on_termination = local.NGINX_INSTANCE.root_block_device.delete_on_termination
    encrypted             = local.NGINX_INSTANCE.root_block_device.encrypted
    tags                  = local.NGINX_INSTANCE.root_block_device.tags
  }

  dynamic "ebs_block_device" {
    for_each = local.NGINX_INSTANCE.ebs_block_device
    iterator = ebs_volume
    content {
      device_name           = ebs_volume.value.device_name
      volume_size           = ebs_volume.value.volume_size
      volume_type           = ebs_volume.value.volume_type
      delete_on_termination = ebs_volume.value.delete_on_termination
      encrypted             = ebs_volume.value.encrypted
      tags                  = ebs_volume.value.tags
    }
  }

  tags = {
    Name    = local.NGINX_INSTANCE.tags.Name
    Cluster = local.NGINX_INSTANCE.tags.Cluster
  }
}
resource "aws_instance" "K8S_CLUSTER_EC2_INSTANCE" {

  ami                         = local.K8S_EC2_NODE.ami
  instance_type               = local.K8S_EC2_NODE.instance_type
  associate_public_ip_address = lookup(local.K8S_EC2_NODE, "associate_public_ip_address", false)
  key_name                    = local.K8S_EC2_NODE.key_name
  user_data                   = lookup(local.K8S_EC2_NODE, "user_data", "")
  vpc_security_group_ids      = local.K8S_EC2_NODE.security_groups
  count                       = local.K8S_EC2_NODE.count

  root_block_device {
    volume_size           = local.K8S_EC2_NODE.root_block_device.volume_size
    volume_type           = local.K8S_EC2_NODE.root_block_device.volume_type
    delete_on_termination = local.K8S_EC2_NODE.root_block_device.delete_on_termination
    encrypted             = local.K8S_EC2_NODE.root_block_device.encrypted
    tags = {
      Name    = "${local.K8S_EC2_NODE.tags.Name}-${count.index + 1}"
      Cluster = local.K8S_EC2_NODE.tags.Cluster
    }
  }

  tags = {
    Name    = "${local.K8S_EC2_NODE.tags.Name}-${count.index + 1}"
    Cluster = local.K8S_EC2_NODE.tags.Cluster
  }
}

resource "aws_route53_record" "DNS_RECORDS" {
  for_each =  merge(local.MAP_DNS_TO_IP, var.DNS_RECORDS)
  name     = each.value.name
  type     = each.value.type
  zone_id  = each.value.zone_id
  ttl      = each.value.ttl
  records  = [each.value.records]
  # health_check_id = each.value.health_check_id // Uncomment if using health checks
  allow_overwrite = each.value.allow_overwrite
}
