output "name" {
  value = azurerm_private_dns_zone_virtual_network_link.link.name
}

output "resource_group_name" {
  value = azurerm_private_dns_zone_virtual_network_link.link.resource_group_name
}

output "private_dns_zone_name" {
  value = azurerm_private_dns_zone_virtual_network_link.link.private_dns_zone_name
}

output "virtual_network_id" {
  value = azurerm_private_dns_zone_virtual_network_link.link.virtual_network_id
}