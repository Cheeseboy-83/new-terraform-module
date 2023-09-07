resource "azurerm_key_vault" "kv" {
  name                            = var.name
  location                        = var.location
  resource_group_name             = var.resource_group_name
  sku_name                        = var.sku_name
  tenant_id                       = var.tenant_id
  soft_delete_retention_days      = var.soft_delete_retention_days
  purge_protection_enabled        = var.purge_protection_enabled
  enabled_for_disk_encryption     = var.enabled_for_disk_encryption
  enabled_for_deployment          = var.enabled_for_deployment
  enabled_for_template_deployment = var.enabled_for_template_deployment
  enable_rbac_authorization       = var.enable_rbac_authorization
  public_network_access_enabled   = var.public_network_access_enabled

  dynamic "network_acls" {
    for_each = var.network_acls != null ? [1] : []
    content {
      default_action             = try(var.network_acls.default_action, "Deny")
      bypass                     = try(var.network_acls.bypass, "AzureServices")
      ip_rules                   = try(var.network_acls.ip_rules, [])
      virtual_network_subnet_ids = try(var.network_acls.virtual_network_subnet_ids, [])
    }
  }

  tags = var.tags

  lifecycle {
    ignore_changes = [
      network_acls,
      access_policy,
      resource_group_name,
      location
    ]
  }
}

resource "azurerm_key_vault_access_policy" "kv_ap" {
  for_each = { for key, value in var.access_policies : key => value
    if try(var.enable_rbac_authorization, false) == false
  }

  key_vault_id            = azurerm_key_vault.kv.id
  tenant_id               = each.value.tenant_id
  object_id               = each.value.object_id
  secret_permissions      = each.value.secret_permissions
  key_permissions         = each.value.key_permissions
  certificate_permissions = each.value.certificate_permissions
}