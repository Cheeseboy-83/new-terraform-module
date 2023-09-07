output "name" {
  description = "The name of the virtual machine"
  value       = azurerm_linux_virtual_machine.linux_vm.name
}

output "id" {
  description = "The ID of the virtual machine"
  value       = azurerm_linux_virtual_machine.linux_vm.id
}

output "computer_name" {
  description = "The computer name of the virtual machine"
  value       = azurerm_linux_virtual_machine.linux_vm.computer_name
}
output "private_ip_address" {
  description = "The private IP address of the virtual machine"
  value       = azurerm_linux_virtual_machine.linux_vm.private_ip_address
}

output "public_ip_address" {
  description = "The public IP address of the virtual machine"
  value       = azurerm_linux_virtual_machine.linux_vm.public_ip_address
}

output "virtual_machine_id" {
  description = "The ID of the virtual machine"
  value       = azurerm_linux_virtual_machine.linux_vm.virtual_machine_id
}

output "nic_ids" {
  description = "The IDs of the network interfaces attached to the virtual machine"
  value       = values(azurerm_network_interface.network_interface)[*].id
}