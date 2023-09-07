output "name" {
  value = azurerm_private_endpoint.pe.name
}

output "id" {
  value = azurerm_private_endpoint.pe.id
}

output "private_dns_zone_group" {
  value = azurerm_private_endpoint.pe.private_dns_zone_group
}

output "private_service_connection" {
  value = azurerm_private_endpoint.pe.private_service_connection
}

output "location" {
  value = azurerm_private_endpoint.pe.location
}

output "resource_group_name" {
  value = azurerm_private_endpoint.pe.resource_group_name
}