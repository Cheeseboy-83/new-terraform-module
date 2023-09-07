data "azurerm_network_watcher" "nw" {
  name                = var.name
  resource_group_name = var.resource_group_name
}