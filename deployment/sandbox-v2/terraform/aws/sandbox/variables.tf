variable "sandbox_name" {
  default = "sandbox1"
}

variable "region" {
  default = "ap-south-1"
}

variable "vpc_cidr" {
  default  = "10.20.0.0/16"
}

variable "private_subnets" {
  type = map(string) 
  default = {
    "subnet_a" = "10.20.20.0/24"
  }
}

variable "console_name" {
  default = "console"
}

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

variable "hosted_domain_name" {
  default = "sb"
}

variable "site_domain_name" {
  default = "mosip.net"
}

variable "site_subdomain_name" {
  default = "qa.mosip.net"
}
