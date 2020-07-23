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
  default = "console.sb"  // 
}

/* Recommended not to change names */
variable "kube_names" {
   type = list(string)
   default = [
     "mzmaster.sb",
     "mzworker0.sb",
     "mzworker1.sb",
     "mzworker2.sb",
     "mzworker3.sb",
     "mzworker4.sb",
     "mzworker5.sb",
     "mzworker6.sb",
     "mzworker7.sb",
     "mzworker8.sb",
     "dmzmaster.sb",
     "dmzworker0.sb"
   ]
}

/* Recommended not to change names */
variable "hosted_domain_name" {  // Do not change this name - has dependency on Ansible scripts 
  default = "sb"
}

