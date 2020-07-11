#All the changes you can do it in this config file
variable "subscription_id" {
  default = "834c8af0-effa-4ca8-8bb6-1c499c21a323"
}
#if want to add new vm, add here as list and pass this parameter in to vm.tf config file.
variable "hostname" {
  type    = list(string)
  default = ["console", "mzmaster", "dmzmaster", "mzworker0", "mzworker1", "mzworker2", "dmzworker0"]
}
#Change the domain name label according to our env need.
variable "domain_name_label" {
  default = "test-machine"
}

variable "admin_username" {
  default = "mosipuser"
}

variable "admin_password" {
  default = "Password@123"
}

#This prefix is using as parameter in resources (vnet,subnet,nsg)
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
  default = ["Standard_F2s_v2", "Standard_F4s_v2", "Standard_D4_v3"]
}

variable "storage_account_type" {
  default = "Standard_LRS"
}


variable "ssh_public_key" {
    default = "~/.ssh/id_rsa.pub"
}
#change your tag according to your needs.
variable "tags" {
  default = "testing" 
    }
