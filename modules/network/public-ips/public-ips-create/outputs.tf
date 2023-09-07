output "name" {
  description = "The name of the public IP address."
  value       = azurerm_public_ip.pip.name
}

output "resource_group_name" {
  description = "The name of the resource group in which to create the public IP address."
  value       = azurerm_public_ip.pip.resource_group_name
}

output "location" {
  description = "The Azure location where the public IP address should exist."
  value       = azurerm_public_ip.pip.location
}

output "allocation_method" {
  description = "Defines the allocation method for this IP address. Possible values are Static or Dynamic."
  value       = azurerm_public_ip.pip.allocation_method
}

output "domain_name_label" {
  description = "The Domain Name Label. Must be a valid DNS label and be unique in the region."
  value       = azurerm_public_ip.pip.domain_name_label
}

output "sku" {
  description = "The SKU of the Public IP. Accepted values are Basic and Standard."
  value       = azurerm_public_ip.pip.sku
}

output "sku_tier" {
  description = "The Tier of the SKU of the Public IP. This is only used for Standard SKU."
  value       = azurerm_public_ip.pip.sku_tier
}

output "ddos_protection_mode" {
  description = "The DDoS protection mode. Only Standard is supported."
  value       = azurerm_public_ip.pip.ddos_protection_mode
}

output "ddos_protection_plan_id" {
  description = "The ID of the DDoS protection plan which the Public IP Address should be associated with."
  value       = azurerm_public_ip.pip.ddos_protection_plan_id
}

output "ip_address" {
  description = "The IP address associated with the public IP address."
  value       = azurerm_public_ip.pip.ip_address
}

output "fqdn" {
  description = "The FQDN associated with the public IP address."
  value       = azurerm_public_ip.pip.fqdn
}

output "ip_version" {
  description = "The IP Version associated with the public IP address."
  value       = azurerm_public_ip.pip.ip_version
}

output "tags" {
  description = "A mapping of tags to assign to the resource."
  value       = azurerm_public_ip.pip.tags
}