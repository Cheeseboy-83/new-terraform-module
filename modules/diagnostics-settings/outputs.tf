output "name" {
  value = azurerm_monitor_diagnostic_setting.diagnostics.name
}

output "id" {
  value = azurerm_monitor_diagnostic_setting.diagnostics.id
}

output "log_analytics_workspace_id" {
  value = azurerm_monitor_diagnostic_setting.diagnostics.log_analytics_workspace_id
}

output "eventhub_authorization_rule_id" {
  value = azurerm_monitor_diagnostic_setting.diagnostics.eventhub_authorization_rule_id
}

output "eventhub_name" {
  value = azurerm_monitor_diagnostic_setting.diagnostics.eventhub_name
}

output "storage_account_id" {
  value = azurerm_monitor_diagnostic_setting.diagnostics.storage_account_id
}

output "metrics" {
  value = azurerm_monitor_diagnostic_setting.diagnostics.metric
}