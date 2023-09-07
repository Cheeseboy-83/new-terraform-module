output "name" {
  value = data.azurerm_resource_group.rg.name
}

output "location" {
  value = data.azurerm_resource_group.rg.location
}

output "tags" {
  value = data.azurerm_resource_group.rg.tags
}

output "id" {
  value = data.azurerm_resource_group.rg.id
}