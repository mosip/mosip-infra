resource "azurerm_public_ip" "myterraformpublicip" {
  name                = "console-PublicIP"
  location            = "southindia"
  resource_group_name = azurerm_resource_group.myterraformgroup.name
  allocation_method   = "Dynamic"
  domain_name_label   = "test-machine"
}

resource "azurerm_public_ip" "myterraformpublicip1" {
  name                = "mzmaster-PublicIP"
  location            = "southindia"
  resource_group_name = azurerm_resource_group.myterraformgroup.name
  allocation_method   = "Dynamic"
  domain_name_label   = "mzmaster"
}

resource "azurerm_public_ip" "myterraformpublicip2" {
  name                = "dmzmaster-PublicIP"
  location            = "southindia"
  resource_group_name = azurerm_resource_group.myterraformgroup.name
  allocation_method   = "Dynamic"
  domain_name_label   = "dmzmaster"
}

resource "azurerm_public_ip" "myterraformpublicip3" {
  name                = "dmzworker0-PublicIP"
  location            = "southindia"
  resource_group_name = azurerm_resource_group.myterraformgroup.name
  allocation_method   = "Dynamic"
  domain_name_label   = "dmzworker0"
}

resource "azurerm_public_ip" "myterraformpublicip4" {
  name                = "mzworker0-PublicIP"
  location            = "southindia"
  resource_group_name = azurerm_resource_group.myterraformgroup.name
  allocation_method   = "Dynamic"
  domain_name_label   = "mzworker0"
}

resource "azurerm_public_ip" "myterraformpublicip5" {
  name                = "mzworker1-PublicIP"
  location            = "southindia"
  resource_group_name = azurerm_resource_group.myterraformgroup.name
  allocation_method   = "Dynamic"
  domain_name_label   = "mzworker1"
}

resource "azurerm_public_ip" "myterraformpublicip6" {
  name                = "mzworker2-PublicIP"
  location            = "southindia"
  resource_group_name = azurerm_resource_group.myterraformgroup.name
  allocation_method   = "Dynamic"
  domain_name_label   = "mzworker2"
}
