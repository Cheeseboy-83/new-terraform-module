data "azurerm_key_vault" "kv" {
  name                = var.name
  resource_group_name = var.resource_group_name
}