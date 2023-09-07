output "name" {
  description = "The name of the public IP address."
  value       = data.azurerm_public_ip.pip.name
}

output "id" {
  description = "The ID of the public IP address."
  value       = data.azurerm_public_ip.pip.id
}

output "resource_group_name" {
  description = "The name of the resource group in which the public IP address exists."
  value       = data.azurerm_public_ip.pip.resource_group_name
}

output "location" {
  description = "The location of the public IP address."
  value       = data.azurerm_public_ip.pip.location
}

output "ip_address" {
  description = "The IP address associated with the public IP address."
  value       = data.azurerm_public_ip.pip.ip_address
}

output "domain_name_label" {
  description = "The Domain Name Label associated with the public IP address."
  value       = data.azurerm_public_ip.pip.domain_name_label
}

output "fqdn" {
  description = "The FQDN associated with the public IP address."
  value       = data.azurerm_public_ip.pip.fqdn
}

output "sku" {
  description = "The SKU of the Public IP."
  value       = data.azurerm_public_ip.pip.sku
}

output "ip_version" {
  description = "The IP Version associated with the public IP address."
  value       = data.azurerm_public_ip.pip.ip_version
}

output "ddos_protection_mode" {
  description = "The DDoS protection mode."
  value       = data.azurerm_public_ip.pip.ddos_protection_mode
}

output "ddos_protection_plan_id" {
  description = "The ID of the DDoS protection plan which the Public IP Address should be associated with."
  value       = data.azurerm_public_ip.pip.ddos_protection_plan_id
}