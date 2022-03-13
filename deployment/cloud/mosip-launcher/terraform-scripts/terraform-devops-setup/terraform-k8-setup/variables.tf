variable "agent_count" {
    default = 1
}

variable "admin_username" {
    default = "ubuntu"
  
}

variable "vm_size" {
  default = "Standard_D2s_v3"
}

variable "os_type" {
    default = "Linux"
  
}

variable "environment" {
    default = "development"
}


variable "ssh_public_key" {
    default = "~/.ssh/id_rsa.pub"
}

variable "dns_prefix" {
    default = "tfk8test"
}

variable cluster_name {
    default = "tfk8test"
}

variable resource_group_name {
    default = "tfazurek8test"
}

variable location {
    default = "South India"
}

variable client_secret {
	default= "myClientSecret"
}

variable client_id {
	default= "myclientID"
}

variable "os_disk_size_gb" {
    default = "30"
}

