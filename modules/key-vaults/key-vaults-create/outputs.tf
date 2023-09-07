output "name" {
  value = azurerm_key_vault.kv.name
}

output "id" {
  value = azurerm_key_vault.kv.id
}

output "location" {
  value = azurerm_key_vault.kv.location
}

output "resource_group_name" {
  value = azurerm_key_vault.kv.resource_group_name
}

output "sku_name" {
  value = azurerm_key_vault.kv.sku_name
}

output "tenant_id" {
  value = azurerm_key_vault.kv.tenant_id
}

output "soft_delete_retention_days" {
  value = azurerm_key_vault.kv.soft_delete_retention_days
}

output "purge_protection_enabled" {
  value = azurerm_key_vault.kv.purge_protection_enabled
}

output "enabled_for_disk_encryption" {
  value = azurerm_key_vault.kv.enabled_for_disk_encryption
}

output "enabled_for_deployment" {
  value = azurerm_key_vault.kv.enabled_for_deployment
}

output "enabled_for_template_deployment" {
  value = azurerm_key_vault.kv.enabled_for_template_deployment
}

output "enable_rbac_authorization" {
  value = azurerm_key_vault.kv.enable_rbac_authorization
}

output "public_network_access_enabled" {
  value = azurerm_key_vault.kv.public_network_access_enabled
}

output "tags" {
  value = azurerm_key_vault.kv.tags
}

output "vault_uri" {
  value = azurerm_key_vault.kv.vault_uri
}