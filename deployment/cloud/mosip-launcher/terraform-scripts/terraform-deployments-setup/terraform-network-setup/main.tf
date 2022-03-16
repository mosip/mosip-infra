resource "azurerm_virtual_network" "main" {
  name                = "${var.application_name}-network"
  address_space       = ["10.0.0.0/16"]
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = "${var.resource_group_name}"
  virtual_network_name = "${azurerm_virtual_network.main.name}"
  address_prefix      = "10.0.2.0/24" # if you plan to change the ip here change it in the setup-configuration-for-config-server-and-helm-charts module as well under configurations setup-environment-variables-jenkins.j2 - 10.0.2.240
}