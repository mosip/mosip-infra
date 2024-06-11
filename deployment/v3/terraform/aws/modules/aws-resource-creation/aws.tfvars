CLUSTER_NAME        = ""
AWS_PROVIDER_REGION = ""
SSH_KEY_NAME        = ""
K8S_INSTANCE_TYPE   = ""
NGINX_INSTANCE_TYPE = ""
MOSIP_DOMAIN        = ""
ZONE_ID             = ""
AMI                 = ""

SECURITY_GROUP = {
  NGINX_SECURITY_GROUP = [
    {
      description : "SSH login port"
      from_port : 22,
      to_port : 22,
      protocol : "TCP",
      cidr_blocks      = ["0.0.0.0/0"],
      ipv6_cidr_blocks = ["::/0"]
    },
    {
      description : "HTTP port"
      from_port : 80,
      to_port : 80,
      protocol : "TCP",
      cidr_blocks      = ["0.0.0.0/0"],
      ipv6_cidr_blocks = ["::/0"]
    },
    {
      description : "HTTPS port"
      from_port : 443,
      to_port : 443,
      protocol : "TCP",
      cidr_blocks      = ["0.0.0.0/0"],
      ipv6_cidr_blocks = ["::/0"]
    }
  ]
  K8S_SECURITY_GROUP = [
    {
      description : "K8s port"
      from_port : 6443,
      to_port : 6443,
      protocol : "TCP",
      cidr_blocks      = ["0.0.0.0/0"],
      ipv6_cidr_blocks = ["::/0"]
    },
    {
      description : "SSH login port"
      from_port : 22,
      to_port : 22,
      protocol : "TCP",
      cidr_blocks      = ["0.0.0.0/0"],
      ipv6_cidr_blocks = ["::/0"]
    },
    {
      description : "HTTP port"
      from_port : 80,
      to_port : 80,
      protocol : "TCP",
      cidr_blocks      = ["0.0.0.0/0"],
      ipv6_cidr_blocks = ["::/0"]
    },
    {
      description : "HTTPS port"
      from_port : 443,
      to_port : 443,
      protocol : "TCP",
      cidr_blocks      = ["0.0.0.0/0"],
      ipv6_cidr_blocks = ["::/0"]
    }
  ]
}
