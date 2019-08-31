
variable "domain_name_label" {
    default = "test"
}

variable resource_group_name {
    default = "tfazurek8test"
}

variable location {
    default = "South India"
}

resource "azurerm_public_ip" "public-ip" {
  name                = "PublicIP"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
  allocation_method   = "Static"
  domain_name_label   = "${var.domain_name_label}"
}

output "domain_name" {
  value = "${azurerm_public_ip.public-ip.fqdn}"
}

output "public_ip" {
  value = "${azurerm_public_ip.public-ip.ip_address}"
}