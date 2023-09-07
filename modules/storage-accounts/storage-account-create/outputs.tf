output "name" {
  value = azurerm_storage_account.storage.name
}

output "id" {
  value = azurerm_storage_account.storage.id
}

output "resource_group_name" {
  value = azurerm_storage_account.storage.resource_group_name
}

output "location" {
  value = azurerm_storage_account.storage.location
}

output "primary_access_key" {
  value = azurerm_storage_account.storage.primary_access_key
}

output "secondary_access_key" {
  value = azurerm_storage_account.storage.secondary_access_key
}

output "primary_connection_string" {
  value = azurerm_storage_account.storage.primary_connection_string
}

output "secondary_connection_string" {
  value = azurerm_storage_account.storage.secondary_connection_string
}