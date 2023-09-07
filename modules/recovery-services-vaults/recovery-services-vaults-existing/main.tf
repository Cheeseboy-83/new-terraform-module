data "azurerm_recovery_services_vault" "rsv" {
  name                = var.name
  resource_group_name = var.resource_group_name
}