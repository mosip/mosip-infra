resource "azurerm_public_ip" "myterraformpublicip" {
  name                = "${var.hostname[0]}-PublicIP"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Dynamic"
  domain_name_label   = var.domain_name_label
}

resource "azurerm_public_ip" "myterraformpublicip1" {
  name                = "${var.hostname[1]}-PublicIP"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Dynamic"
}

resource "azurerm_public_ip" "myterraformpublicip2" {
  name                = "${var.hostname[2]}-PublicIP"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Dynamic"
}

resource "azurerm_public_ip" "myterraformpublicip3" {
  name                = "${var.hostname[6]}-PublicIP"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Dynamic"
}

resource "azurerm_public_ip" "myterraformpublicip4" {
  name                = "${var.hostname[3]}-PublicIP"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Dynamic"
}

resource "azurerm_public_ip" "myterraformpublicip5" {
  name                = "${var.hostname[4]}-PublicIP"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Dynamic"
}

resource "azurerm_public_ip" "myterraformpublicip6" {
  name                = "${var.hostname[5]}-PublicIP"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Dynamic"
}
