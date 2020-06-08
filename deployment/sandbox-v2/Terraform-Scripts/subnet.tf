resource "azurerm_subnet" "myterraformsubnet" {
  name                 = "Provide-Subnet"
  resource_group_name  = azurerm_resource_group.myterraformgroup.name
  virtual_network_name = azurerm_virtual_network.myterraformnetwork.name
  address_prefixes     = ["10.0.0.0/24"]
}

