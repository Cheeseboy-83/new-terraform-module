output "name" {
  value = azurerm_log_analytics_workspace.log_analytics.name
}

output "id" {
  value = azurerm_log_analytics_workspace.log_analytics.id
}

output "workspace_id" {
  value = azurerm_log_analytics_workspace.log_analytics.workspace_id
}

output "sku" {
  value = azurerm_log_analytics_workspace.log_analytics.sku
}

output "retention_in_days" {
  value = azurerm_log_analytics_workspace.log_analytics.retention_in_days
}

output "daily_quota_gb" {
  value = azurerm_log_analytics_workspace.log_analytics.daily_quota_gb
}

output "primary_shared_key" {
  value = azurerm_log_analytics_workspace.log_analytics.primary_shared_key
}

output "secondary_shared_key" {
  value = azurerm_log_analytics_workspace.log_analytics.secondary_shared_key
}