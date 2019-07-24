output "network_interface_ids" {
  description = "ids of the vm nics provisoned."
  value       = "${azurerm_network_interface.main.*.id}"
}
