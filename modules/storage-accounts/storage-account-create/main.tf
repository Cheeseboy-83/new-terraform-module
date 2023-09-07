resource "azurerm_storage_account" "storage" {
  name                              = var.name
  resource_group_name               = var.resource_group_name
  location                          = var.location
  account_kind                      = var.account_kind
  account_tier                      = var.account_tier
  account_replication_type          = var.account_replication_type
  access_tier                       = var.access_tier
  enable_https_traffic_only         = var.enable_https_traffic_only
  min_tls_version                   = var.min_tls_version
  public_network_access_enabled     = var.public_network_access_enabled
  allow_nested_items_to_be_public   = var.allow_nested_items_to_be_public
  infrastructure_encryption_enabled = var.infrastructure_encryption_enabled

  tags = var.tags
}

resource "azurerm_storage_account_network_rules" "network_rule" {
  for_each = var.network_rules

  storage_account_id = azurerm_storage_account.storage.id

  default_action             = "Deny"
  ip_rules                   = try(each.value.ip_rules, [])
  virtual_network_subnet_ids = try(each.value.virtual_network_subnet_ids, [])
  bypass                     = try(each.value.bypass, ["AzureServices", "Logging", "Metrics"])
}

# resource "azurerm_private_endpoint" "blob_pe" {
#   count = var.private_endpoint ? 1 : 0

#   name                = "${var.name}-blob-pe"
#   location            = var.location
#   resource_group_name = var.resource_group_name
#   subnet_id           = var.subnet_id

#   private_dns_zone_group {
#     name                 = "${var.name}-blob-pdzg"
#     private_dns_zone_ids = var.private_dns_zone_ids
#   }

#   private_service_connection {
#     name                           = "${var.name}-blob-psc"
#     private_connection_resource_id = azurerm_storage_account.storage.id
#     subresource_names              = ["blob"]
#     is_manual_connection           = false
#   }

#   tags = var.tags
# }