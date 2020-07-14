resource "azurerm_network_interface" "myterraformnic" {
  name                = "${var.hostname[0]}-NIC"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "${var.hostname[0]}-NicConfiguration"
    subnet_id                     = azurerm_subnet.myterraformsubnet.id
    private_ip_address_allocation = "Dynamic"
    #private_ip_address		  = "10.0.0.4"
    public_ip_address_id          = azurerm_public_ip.myterraformpublicip.id
  }
}

resource "azurerm_network_interface" "myterraformnic1" {
  name                = "${var.hostname[1]}-NIC"
  location            = "southindia"
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "${var.hostname[1]}-NicConfiguration1"
    subnet_id                     = azurerm_subnet.myterraformsubnet.id
    private_ip_address_allocation = "Dynamic"
    #private_ip_address            = "10.0.0.5"
    public_ip_address_id          = azurerm_public_ip.myterraformpublicip1.id
  }
}

resource "azurerm_network_interface" "myterraformnic2" {
  name                = "${var.hostname[2]}-NIC"
  location            = "southindia"
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "${var.hostname[2]}-NicConfiguration2"
    subnet_id                     = azurerm_subnet.myterraformsubnet.id
    private_ip_address_allocation = "Dynamic"
    #private_ip_address            = "10.0.0.6"
    public_ip_address_id          = azurerm_public_ip.myterraformpublicip2.id
  }
}

resource "azurerm_network_interface" "myterraformnic3" {
  name                = "${var.hostname[6]}-NIC"
  location            = "southindia"
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "${var.hostname[6]}-NicConfiguration3"
    subnet_id                     = azurerm_subnet.myterraformsubnet.id
    private_ip_address_allocation = "Dynamic"
    #private_ip_address            = "10.0.0.7"
    public_ip_address_id          = azurerm_public_ip.myterraformpublicip3.id
  }
}

resource "azurerm_network_interface" "myterraformnic4" {
  name                = "${var.hostname[3]}-NIC"
  location            = "southindia"
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "${var.hostname[3]}-NicConfiguration4"
    subnet_id                     = azurerm_subnet.myterraformsubnet.id
    private_ip_address_allocation = "Dynamic"
    #private_ip_address            = "10.0.0.8"
    public_ip_address_id          = azurerm_public_ip.myterraformpublicip4.id
  }
}

resource "azurerm_network_interface" "myterraformnic5" {
  name                = "${var.hostname[4]}-NIC"
  location            = "southindia"
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "${var.hostname[4]}-NicConfiguration5"
    subnet_id                     = azurerm_subnet.myterraformsubnet.id
    private_ip_address_allocation = "Dynamic"
    #private_ip_address            = "10.0.0.9"
    public_ip_address_id          = azurerm_public_ip.myterraformpublicip5.id
  }
}

resource "azurerm_network_interface" "myterraformnic6" {
  name                = "${var.hostname[5]}-NIC"
  location            = "southindia"
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "${var.hostname[5]}-NicConfiguration6"
    subnet_id                     = azurerm_subnet.myterraformsubnet.id
    private_ip_address_allocation = "Dynamic"
    #private_ip_address            = "10.0.0.10"
    public_ip_address_id          = azurerm_public_ip.myterraformpublicip6.id
  }
}
