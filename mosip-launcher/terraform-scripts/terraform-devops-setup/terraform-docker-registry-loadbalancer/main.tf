
variable "domain_name_label" {
    default = "docker-registry"
}

variable resource_group_name {
    default = "tfazurek8test"
}

variable location {
    default = "South India"
}

resource "azurerm_public_ip" "docker-registry-loadbalancer" {
  name                = "DockerRegistryLoadbalancerIP"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
  allocation_method   = "Static"
  domain_name_label   = "${var.domain_name_label}"
}

output "fully_qualified_domain_name" {
  value = "${azurerm_public_ip.docker-registry-loadbalancer.fqdn}"
}