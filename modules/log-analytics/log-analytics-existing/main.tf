data "azurerm_log_analytics_workspace" "log_analytics" {
  name                = var.name
  resource_group_name = var.resource_group_name
}