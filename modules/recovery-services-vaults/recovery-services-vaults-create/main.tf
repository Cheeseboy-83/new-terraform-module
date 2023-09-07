resource "azurerm_recovery_services_vault" "rsv" {
  name                          = var.name
  location                      = var.location
  resource_group_name           = var.resource_group_name
  sku                           = var.sku
  public_network_access_enabled = var.public_network_access_enabled
  soft_delete_enabled           = var.soft_delete_enabled

  tags = var.tags
}

module "vm_backup_policies" {
  for_each = { for key, value in var.backup_policies : key => value }
  source   = "./backup-policy-vm"

  name                = each.key
  resource_group_name = var.resource_group_name
  recovery_vault_name = azurerm_recovery_services_vault.rsv.name
  timezone            = try(each.value.timezone, "UTC")
  policy_type         = try(each.value.policy_type, "V1")
  backup_frequency    = each.value.backup_frequency
  backup_time         = each.value.backup_time
  retention_daily     = lookup(each.value, "retention_daily", {})
  retention_weekly    = lookup(each.value, "retention_weekly", {})
  retention_monthly   = lookup(each.value, "retention_monthly", {})
  retention_yearly    = lookup(each.value, "retention_yearly", {})

  depends_on = [
    azurerm_recovery_services_vault.rsv
  ]
}