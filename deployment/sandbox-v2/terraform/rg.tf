resource "azurerm_resource_group" "myterraformgroup" {
  name     = var.resource_group_name
  location = var.location
}
