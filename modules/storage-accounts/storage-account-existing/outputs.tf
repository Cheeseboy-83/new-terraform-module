output "name" {
  value = data.azurerm_storage_account.storage.name
}

output "id" {
  value = data.azurerm_storage_account.storage.id
}

output "resource_group_name" {
  value = data.azurerm_storage_account.storage.resource_group_name
}

output "location" {
  value = data.azurerm_storage_account.storage.location
}

output "primary_access_key" {
  value = data.azurerm_storage_account.storage.primary_access_key
}

output "secondary_access_key" {
  value = data.azurerm_storage_account.storage.secondary_access_key
}

output "primary_connection_string" {
  value = data.azurerm_storage_account.storage.primary_connection_string
}

output "secondary_connection_string" {
  value = data.azurerm_storage_account.storage.secondary_connection_string
}