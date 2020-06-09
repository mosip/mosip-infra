resource "azurerm_network_interface" "myterraformnic" {
  name                = "console-NIC"
  location            = "southindia"
  resource_group_name = azurerm_resource_group.myterraformgroup.name

  ip_configuration {
    name                          = "myNicConfiguration"
    subnet_id                     = azurerm_subnet.myterraformsubnet.id
    private_ip_address_allocation = "Dynamic"
    #private_ip_address		  = "10.0.0.4"
    public_ip_address_id          = azurerm_public_ip.myterraformpublicip.id
  }
}

resource "azurerm_network_interface" "myterraformnic1" {
  name                = "mzmaster-NIC"
  location            = "southindia"
  resource_group_name = azurerm_resource_group.myterraformgroup.name

  ip_configuration {
    name                          = "myNicConfiguration1"
    subnet_id                     = azurerm_subnet.myterraformsubnet.id
    private_ip_address_allocation = "Dynamic"
    #private_ip_address            = "10.0.0.5"
    public_ip_address_id          = azurerm_public_ip.myterraformpublicip1.id
  }
}

resource "azurerm_network_interface" "myterraformnic2" {
  name                = "dmzmaster-NIC"
  location            = "southindia"
  resource_group_name = azurerm_resource_group.myterraformgroup.name

  ip_configuration {
    name                          = "myNicConfiguration2"
    subnet_id                     = azurerm_subnet.myterraformsubnet.id
    private_ip_address_allocation = "Dynamic"
    #private_ip_address            = "10.0.0.6"
    public_ip_address_id          = azurerm_public_ip.myterraformpublicip2.id
  }
}

resource "azurerm_network_interface" "myterraformnic3" {
  name                = "dmzworker0-NIC"
  location            = "southindia"
  resource_group_name = azurerm_resource_group.myterraformgroup.name

  ip_configuration {
    name                          = "myNicConfiguration3"
    subnet_id                     = azurerm_subnet.myterraformsubnet.id
    private_ip_address_allocation = "Dynamic"
    #private_ip_address            = "10.0.0.7"
    public_ip_address_id          = azurerm_public_ip.myterraformpublicip3.id
  }
}

resource "azurerm_network_interface" "myterraformnic4" {
  name                = "mzworker0-NIC"
  location            = "southindia"
  resource_group_name = azurerm_resource_group.myterraformgroup.name

  ip_configuration {
    name                          = "myNicConfiguration4"
    subnet_id                     = azurerm_subnet.myterraformsubnet.id
    private_ip_address_allocation = "Dynamic"
    #private_ip_address            = "10.0.0.8"
    public_ip_address_id          = azurerm_public_ip.myterraformpublicip4.id
  }
}

resource "azurerm_network_interface" "myterraformnic5" {
  name                = "mzworker1-NIC"
  location            = "southindia"
  resource_group_name = azurerm_resource_group.myterraformgroup.name

  ip_configuration {
    name                          = "myNicConfiguration5"
    subnet_id                     = azurerm_subnet.myterraformsubnet.id
    private_ip_address_allocation = "Dynamic"
    #private_ip_address            = "10.0.0.9"
    public_ip_address_id          = azurerm_public_ip.myterraformpublicip5.id
  }
}

resource "azurerm_network_interface" "myterraformnic6" {
  name                = "mzworker2-NIC"
  location            = "southindia"
  resource_group_name = azurerm_resource_group.myterraformgroup.name

  ip_configuration {
    name                          = "myNicConfiguration6"
    subnet_id                     = azurerm_subnet.myterraformsubnet.id
    private_ip_address_allocation = "Dynamic"
    #private_ip_address            = "10.0.0.10"
    public_ip_address_id          = azurerm_public_ip.myterraformpublicip6.id
  }
}
