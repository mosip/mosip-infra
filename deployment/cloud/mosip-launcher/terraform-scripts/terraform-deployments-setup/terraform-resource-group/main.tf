resource "azurerm_resource_group" "deployments" {
  name     = "${var.resource_group_name}"
  location = "${var.location}"
}
