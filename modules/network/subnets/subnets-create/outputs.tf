output "name" {
  value = azurerm_subnet.subnet.name
}

output "id" {
  value = azurerm_subnet.subnet.id
}

output "resource_group_name" {
  value = azurerm_subnet.subnet.resource_group_name
}

output "address_prefixes" {
  value = azurerm_subnet.subnet.address_prefixes
}

output "service_endpoints" {
  value = azurerm_subnet.subnet.service_endpoints
}