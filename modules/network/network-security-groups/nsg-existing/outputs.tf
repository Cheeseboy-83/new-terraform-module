output "name" {
  value = data.azurerm_network_security_group.nsg.name
}

output "id" {
  value = data.azurerm_network_security_group.nsg.id
}

output "location" {
  value = data.azurerm_network_security_group.nsg.location
}

output "resource_group_name" {
  value = data.azurerm_network_security_group.nsg.resource_group_name
}

output "security_rules" {
  value = values(data.azurerm_network_security_group.nsg.security_rule)
}