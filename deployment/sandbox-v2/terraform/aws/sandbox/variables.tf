variable "sandbox_name" {
  default = "qa"
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

variable "key_name" {
  default = "mosip-aws"
}

/* Recommended not to change names */
variable "console_name" {
  default = "console"
}

/* Recommended not to change names */
variable "kube_names" {
   type = list(string)
   default = [
     "mzmaster",
     "mzworker0",
     "mzworker1",
     "mzworker2",
     "mzworker3",
     "mzworker4",
     "mzworker5",
     "mzworker6",
     "mzworker7",
     "mzworker8",
     "dmzmaster",
     "dmzworker0"
   ]
}

/* Recommended not to change names */
variable "hosted_domain_name" {
  default = "sb"
}

