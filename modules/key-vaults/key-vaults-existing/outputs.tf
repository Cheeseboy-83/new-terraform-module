output "name" {
  value = data.azurerm_key_vault.kv.name
}

output "id" {
  value = data.azurerm_key_vault.kv.id
}

output "location" {
  value = data.azurerm_key_vault.kv.location
}

output "resource_group_name" {
  value = data.azurerm_key_vault.kv.resource_group_name
}

output "sku_name" {
  value = data.azurerm_key_vault.kv.sku_name
}

output "tenant_id" {
  value = data.azurerm_key_vault.kv.tenant_id
}

output "purge_protection_enabled" {
  value = data.azurerm_key_vault.kv.purge_protection_enabled
}

output "enabled_for_disk_encryption" {
  value = data.azurerm_key_vault.kv.enabled_for_disk_encryption
}

output "enabled_for_deployment" {
  value = data.azurerm_key_vault.kv.enabled_for_deployment
}

output "enabled_for_template_deployment" {
  value = data.azurerm_key_vault.kv.enabled_for_template_deployment
}

output "enable_rbac_authorization" {
  value = data.azurerm_key_vault.kv.enable_rbac_authorization
}

output "public_network_access_enabled" {
  value = data.azurerm_key_vault.kv.public_network_access_enabled
}

output "tags" {
  value = data.azurerm_key_vault.kv.tags
}

output "vault_uri" {
  value = data.azurerm_key_vault.kv.vault_uri
}