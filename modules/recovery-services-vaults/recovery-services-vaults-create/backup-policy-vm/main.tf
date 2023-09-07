resource "azurerm_backup_policy_vm" "policy" {
  name                = var.name
  resource_group_name = var.resource_group_name
  recovery_vault_name = var.recovery_vault_name
  timezone            = var.timezone
  policy_type         = var.policy_type
  backup {
    frequency = var.backup_frequency
    time      = var.backup_time
  }
  dynamic "retention_daily" {
    for_each = var.retention_daily != {} ? [1] : []

    content {
      count = var.retention_daily.count
    }
  }
  dynamic "retention_weekly" {
    for_each = var.retention_weekly != {} ? [1] : []

    content {
      count    = var.retention_weekly.count
      weekdays = var.retention_weekly.weekdays
    }
  }
  dynamic "retention_monthly" {
    for_each = var.retention_monthly != {} ? [1] : []

    content {
      count    = var.retention_monthly.count
      weekdays = var.retention_monthly.weekdays
      weeks    = var.retention_monthly.weeks
    }
  }
  dynamic "retention_yearly" {
    for_each = var.retention_yearly != {} ? [1] : []

    content {
      count    = var.retention_yearly.count
      weekdays = var.retention_yearly.weekdays
      weeks    = var.retention_yearly.weeks
      months   = var.retention_yearly.months
    }
  }
}