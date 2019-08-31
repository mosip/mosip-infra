variable "application_name" {
  default = "tfvmex"
}

variable "hostname" {
  default = "default-host"
}

variable "username" {
  default = "mosip-user"
}

variable "public_ip_id" {
  default = "null"
}


variable "subnet_id" {
  default = "null"
}


variable resource_group_name {
  default = "tfazurek8test"
}

variable location {
  default = "South India"
}

variable "vm_size" {
  default = "Standard_D2s_v3"
}

variable "ssh_public_key" {
    default = "~/.ssh/id_rsa.pub"
}