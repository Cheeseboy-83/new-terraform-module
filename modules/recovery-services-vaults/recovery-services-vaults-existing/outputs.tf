output "name" {
  value = data.azurerm_recovery_services_vault.rsv.name
}

output "id" {
  value = data.azurerm_recovery_services_vault.rsv.id
}

output "location" {
  value = data.azurerm_recovery_services_vault.rsv.location
}

output "resource_group_name" {
  value = data.azurerm_recovery_services_vault.rsv.resource_group_name
}

output "sku" {
  value = data.azurerm_recovery_services_vault.rsv.sku
}

output "tags" {
  value = data.azurerm_recovery_services_vault.rsv.tags
}