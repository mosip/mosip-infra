resource "azurerm_subnet" "myterraformsubnet" {
  name                 = "${var.prefix}-Subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.myterraformnetwork.name
  address_prefixes     = ["10.0.0.0/24"]
}

