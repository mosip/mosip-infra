output "network_interface_ids" {
  description = "ids of the vm nics provisoned."
  value       = "${azurerm_network_interface.main.*.id}"
}

output "network_interface_private_ip" {
  description = "private ip addresses of the vm "
  value       = "${azurerm_network_interface.main.*.private_ip_address}"
}
