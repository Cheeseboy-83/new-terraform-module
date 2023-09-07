output "name" {
  value = azurerm_network_security_group.nsg.name
}

output "id" {
  value = azurerm_network_security_group.nsg.id
}

output "location" {
  value = azurerm_network_security_group.nsg.location
}

output "resource_group_name" {
  value = azurerm_network_security_group.nsg.resource_group_name
}

output "security_rules" {
  value = values(azurerm_network_security_group.nsg.security_rule)
}

output "tags" {
  value = azurerm_network_security_group.nsg.tags
}