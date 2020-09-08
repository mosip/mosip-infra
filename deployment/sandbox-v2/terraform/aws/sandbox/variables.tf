variable "sandbox_name" { //Change this to your sandbox name.
  default = "qa"  // This is informational.  A tag will be added with this name.
}

variable "region" {
  default = "ap-south-1"
}

variable "vpc_cidr" {
  default  = "10.20.0.0/16"
}

variable "private_subnet" {
  default = "10.20.20.0/24"
}

/* CentOS 7.8 image from AWS */
variable "install_image" {
  default = "ami-0dd861ee19fd50a16"
}

/* 4 CPU, 16 GB */
variable "instance_type" {
  default = "m5a.xlarge"
}

variable "private_key" {
  type = map(string)
  default = {
    "name" = "mosip-aws"  // Name as given while creating keys on AWS console 
    "local_path" = "~/.ssh/mosip-aws.pem" // Location on the machine from where you are running terraform
  } 
}

/* Recommended not to change names */
variable "console_name" {
  default =  {
    "name" : "console.sb",
    "private_ip": "10.20.20.10"
  }
}

/* Recommended not to change names */
variable "kube_names" {
   type = map(string)

   default = {
     "mzmaster.sb": "10.20.20.99",
     "mzworker0.sb": "10.20.20.100",
     "mzworker1.sb": "10.20.20.101",
     "mzworker2.sb": "10.20.20.102",
     "mzworker3.sb": "10.20.20.103",
     "mzworker4.sb": "10.20.20.104",
     "mzworker5.sb": "10.20.20.105",
     "mzworker6.sb": "10.20.20.106",
     "mzworker7.sb": "10.20.20.107",
     "mzworker8.sb": "10.20.20.108",
     "dmzmaster.sb": "10.20.20.199",
     "dmzworker0.sb": "10.20.20.200"
   }
}


/* Recommended not to change names */
variable "hosted_domain_name" {  // Do not change this name - has dependency on Ansible scripts 
  default = "sb"
}

