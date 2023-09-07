output "name" {
  value = data.azurerm_network_watcher.nw.name
}

output "location" {
  value = data.azurerm_network_watcher.nw.location
}

output "resource_group_name" {
  value = data.azurerm_network_watcher.nw.resource_group_name
}

output "tags" {
  value = data.azurerm_network_watcher.nw.tags
}

output "id" {
  value = data.azurerm_network_watcher.nw.id
}