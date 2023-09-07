output "name" {
  value = azurerm_virtual_network.vnet.name
}

output "id" {
  value = azurerm_virtual_network.vnet.id
}

output "resource_group_name" {
  value = azurerm_virtual_network.vnet.resource_group_name
}

output "address_space" {
  value = azurerm_virtual_network.vnet.address_space
}

output "location" {
  value = azurerm_virtual_network.vnet.location
}

output "tags" {
  value = azurerm_virtual_network.vnet.tags
}