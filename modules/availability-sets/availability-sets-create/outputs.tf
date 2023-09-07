output "name" {
  value = azurerm_availability_set.av_set.name
}

output "id" {
  value = azurerm_availability_set.av_set.id
}

output "location" {
  value = azurerm_availability_set.av_set.location
}

output "resource_group_name" {
  value = azurerm_availability_set.av_set.resource_group_name
}

output "platform_fault_domain_count" {
  value = azurerm_availability_set.av_set.platform_fault_domain_count
}

output "platform_update_domain_count" {
  value = azurerm_availability_set.av_set.platform_update_domain_count
}

output "managed" {
  value = azurerm_availability_set.av_set.managed
}

output "tags" {
  value = azurerm_availability_set.av_set.tags
}