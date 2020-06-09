variable "subscription_id" {
  default = "834c8af0-effa-4ca8-8bb6-1c499c21a323"
}

variable "hostname" {
  type    = list(string)
  default = ["console", "mzmaster", "dmzmaster", "mzworker0", "mzworker1", "mzworker2", "dmzworker0"]
}

variable "domain_name_label" {
  default = "test-machine"
}

variable "admin_username" {
  default = "mosipuser"
}

variable "admin_password" {
  default = "Password@123"
}

#This prefix is getting changed in resources (vnet,subnet,)
variable "prefix" {
#    type = "string"
    default = "test-machine"
}


variable "resource_group_name" {
  default = "test-today"
}

variable "location" {
  default = "South India"
}

variable "vm_size" {
  type    = list(string)
  default = ["Basic_A2", "Standard_F4s_v2", "Standard_D4_v3"]
}

variable "storage_account_type" {
  default = "Standard_LRS"
}


variable "ssh_public_key" {
    default = "~/.ssh/id_rsa.pub"
}

variable "tags" {
  default = "testing" 
    }
