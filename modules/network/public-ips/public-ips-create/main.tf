resource "azurerm_public_ip" "pip" {
  name                    = var.name
  resource_group_name     = var.resource_group_name
  location                = var.location
  allocation_method       = var.allocation_method
  zones                   = var.zones
  domain_name_label       = var.domain_name_label
  sku                     = var.sku
  sku_tier                = var.sku_tier
  ddos_protection_mode    = var.ddos_protection_mode
  ddos_protection_plan_id = var.ddos_protection_plan_id

  tags = var.tags
}