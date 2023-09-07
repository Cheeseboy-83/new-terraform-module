output "name" {
  value = data.azurerm_virtual_network.vnet.name
}

output "id" {
  value = data.azurerm_virtual_network.vnet.id
}

output "resource_group_name" {
  value = data.azurerm_virtual_network.vnet.resource_group_name
}

output "address_space" {
  value = data.azurerm_virtual_network.vnet.address_space
}

output "location" {
  value = data.azurerm_virtual_network.vnet.location
}