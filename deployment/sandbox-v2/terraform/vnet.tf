resource "azurerm_virtual_network" "myterraformnetwork" {
  name                = "${var.prefix}-Vnet"
  address_space       = ["10.0.0.0/16"]
  location            = "southindia"
  resource_group_name = azurerm_resource_group.myterraformgroup.name
}

