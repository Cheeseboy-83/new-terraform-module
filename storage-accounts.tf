/**************************************************************************
***************** Storage Account Creation ********************************
**************************************************************************/

module "storage_account" {
  depends_on = [module.resource_group]
  source     = "./modules/storage-accounts/storage-account-create"
  for_each = { for key, value in var.storage_accounts : key => value
    if try(value.existing, false) == false
  }

  name                              = each.key
  resource_group_name               = try(each.value.resource_group_name, module.resource_group[each.value.resource_group_name].name, module.resource_group_existing[each.value.resource_group_name].name)
  location                          = try(var.global_settings.location, module.resource_group[each.value.resource_group_name].location, module.resource_group_existing[each.value.resource_group_name].location, each.value.location)
  account_tier                      = lookup(each.value, "account_tier", "Standard")
  account_kind                      = lookup(each.value, "account_kind", "StorageV2")
  account_replication_type          = lookup(each.value, "account_replication_type", "LRS")
  access_tier                       = lookup(each.value, "access_tier", "Hot")
  enable_https_traffic_only         = lookup(each.value, "enable_https_traffic_only", true)
  min_tls_version                   = lookup(each.value, "min_tls_version", "TLS1_2")
  public_network_access_enabled     = lookup(each.value, "public_network_access_enabled", true)
  allow_nested_items_to_be_public   = lookup(each.value, "allow_nested_items_to_be_public", true)
  infrastructure_encryption_enabled = lookup(each.value, "infrastructure_encryption_enabled", false)
  network_rules                     = lookup(each.value, "network_rules", {})

  tags = merge(try(each.value.tags, {}), var.global_settings.tags)
}

/**************************************************************************
******************* Private Endpoint Creation *****************************
**************************************************************************/

# resource "azurerm_private_endpoint" "blob_pe" {
#   depends_on = [module.storage_account]
#   for_each = { for key, value in var.storage_accounts : key => value
#     if try(value.private_endpoint, false) == true
#   }

#   name                = "${each.key}-blob-pe"
#   location            = try(var.global_settings.location, module.resource_group[each.value.resource_group_name].location, module.resource_group_existing[each.value.resource_group_name].location, each.value.location)
#   resource_group_name = try(each.value.resource_group_name, module.resource_group[each.value.resource_group_name].name, module.resource_group_existing[each.value.resource_group_name].name)
#   subnet_id           = try(each.value.subnet_id, try(module.virtual_network[each.value.vnet].virtual_subnets[each.value.pe_subnet].id, module.subnets[each.value.pe_subnet].id, module.subnets_existing[each.value.pe_subnet].id))

#   private_dns_zone_group {
#     name                 = "${each.key}-blob-pe-pdzg"
#     private_dns_zone_ids = [try(module.dns["privatelink.blob.core.windows.net"].id, module.dns_existing["privatelink.blob.core.windows.net"].id, module.dns_existing_remote["privatelink.blob.core.windows.net"].id, module.dns_existing_remote2["privatelink.blob.core.windows.net"].id, module.dns_existing_remote3["privatelink.blob.core.windows.net"].id, module.dns["privatelink.blob.core.usgovlcoudapi.net"].id, module.dns_existing["privatelink.blob.core.usgovlcoudapi.net"].id, module.dns_existing_remote["privatelink.blob.core.usgovlcoudapi.net"].id, module.dns_existing_remote2["privatelink.blob.core.usgovlcoudapi.net"].id, module.dns_existing_remote3["privatelink.blob.core.usgovlcoudapi.net"].id)]
#   }

#   private_service_connection {
#     name                           = "${each.key}-blob-pe-psc"
#     private_connection_resource_id = module.storage_account[each.key].id
#     subresource_names              = ["blob"]
#     is_manual_connection           = false
#   }

#   tags = merge(try(each.value.tags, {}), var.global_settings.tags)

#   lifecycle {
#     ignore_changes = [
#       subnet_id,
#       private_service_connection
#     ]
#   }
# }

module "blob_endpoint" {
  depends_on = [module.storage_account]
  source     = "./modules/private-endpoint"
  for_each = { for key, value in var.storage_accounts : key => value
    if try(value.private_endpoint, false) == true
  }

  name                           = "${each.key}-blob"
  resource_group_name            = try(each.value.resource_group_name, module.resource_group[each.value.resource_group_name].name, module.resource_group_existing[each.value.resource_group_name].name)
  location                       = try(var.global_settings.location, module.resource_group[each.value.resource_group_name].location, module.resource_group_existing[each.value.resource_group_name].location, each.value.location)
  subnet_id                      = try(each.value.subnet_id, module.virtual_subnets[each.value.pe_subnet].id, module.subnets[each.value.pe_subnet].id, module.subnets_existing[each.value.pe_subnet].id)
  private_dns_zone_ids           = [try(module.dns["privatelink.blob.core.windows.net"].id, module.dns_existing["privatelink.blob.core.windows.net"].id, module.dns_existing_remote["privatelink.blob.core.windows.net"].id, module.dns_existing_remote2["privatelink.blob.core.windows.net"].id, module.dns_existing_remote3["privatelink.blob.core.windows.net"].id, module.dns["privatelink.blob.core.usgovlcoudapi.net"].id, module.dns_existing["privatelink.blob.core.usgovlcoudapi.net"].id, module.dns_existing_remote["privatelink.blob.core.usgovlcoudapi.net"].id, module.dns_existing_remote2["privatelink.blob.core.usgovlcoudapi.net"].id, module.dns_existing_remote3["privatelink.blob.core.usgovlcoudapi.net"].id)]
  private_connection_resource_id = module.storage_account[each.key].id
  subresource_names              = ["blob"]

  tags = merge(try(each.value.tags, {}), var.global_settings.tags)
}

module "table_endpoint" {
  depends_on = [module.storage_account]
  source     = "./modules/private-endpoint"
  for_each = { for key, value in var.storage_accounts : key => value
    if try(value.private_endpoint, false) == true
  }

  name                           = "${each.key}-table"
  resource_group_name            = try(each.value.resource_group_name, module.resource_group[each.value.resource_group_name].name, module.resource_group_existing[each.value.resource_group_name].name)
  location                       = try(var.global_settings.location, module.resource_group[each.value.resource_group_name].location, module.resource_group_existing[each.value.resource_group_name].location, each.value.location)
  subnet_id                      = try(each.value.subnet_id, module.virtual_subnets[each.value.pe_subnet].id, module.subnets[each.value.pe_subnet].id, module.subnets_existing[each.value.pe_subnet].id)
  private_dns_zone_ids           = [try(module.dns["privatelink.table.core.windows.net"].id, module.dns_existing["privatelink.table.core.windows.net"].id, module.dns_existing_remote["privatelink.table.core.windows.net"].id, module.dns_existing_remote2["privatelink.table.core.windows.net"].id, module.dns_existing_remote3["privatelink.table.core.windows.net"].id, module.dns["privatelink.table.core.usgovcloudapi.net"].id, module.dns_existing["privatelink.table.core.usgovcloudapi.net"].id, module.dns_existing_remote["privatelink.table.core.usgovcloudapi.net"].id, module.dns_existing_remote2["privatelink.table.core.usgovcloudapi.net"].id, module.dns_existing_remote3["privatelink.table.core.usgovcloudapi.net"].id)]
  private_connection_resource_id = module.storage_account[each.key].id
  subresource_names              = ["table"]

  tags = merge(try(each.value.tags, {}), var.global_settings.tags)
}

module "queue_endpoint" {
  depends_on = [module.storage_account]
  source     = "./modules/private-endpoint"
  for_each = { for key, value in var.storage_accounts : key => value
    if try(value.private_endpoint, false) == true
  }

  name                           = "${each.key}-queue"
  resource_group_name            = try(each.value.resource_group_name, module.resource_group[each.value.resource_group_name].name, module.resource_group_existing[each.value.resource_group_name].name)
  location                       = try(var.global_settings.location, module.resource_group[each.value.resource_group_name].location, module.resource_group_existing[each.value.resource_group_name].location, each.value.location)
  subnet_id                      = try(each.value.subnet_id, module.virtual_subnets[each.value.pe_subnet].id, module.subnets[each.value.pe_subnet].id, module.subnets_existing[each.value.pe_subnet].id)
  private_dns_zone_ids           = [try(module.dns["privatelink.queue.core.windows.net"].id, module.dns_existing["privatelink.queue.core.windows.net"].id, module.dns_existing_remote["privatelink.queue.core.windows.net"].id, module.dns_existing_remote2["privatelink.queue.core.windows.net"].id, module.dns_existing_remote3["privatelink.queue.core.windows.net"].id, module.dns["privatelink.queue.core.usgovcloudapi.net"].id, module.dns_existing["privatelink.queue.core.usgovcloudapi.net"].id, module.dns_existing_remote["privatelink.queue.core.usgovcloudapi.net"].id, module.dns_existing_remote2["privatelink.queue.core.usgovcloudapi.net"].id, module.dns_existing_remote3["privatelink.queue.core.usgovcloudapi.net"].id)]
  private_connection_resource_id = module.storage_account[each.key].id
  subresource_names              = ["queue"]

  tags = merge(try(each.value.tags, {}), var.global_settings.tags)
}

module "file_endpoint" {
  depends_on = [module.storage_account]
  source     = "./modules/private-endpoint"
  for_each = { for key, value in var.storage_accounts : key => value
    if try(value.private_endpoint, false) == true
  }

  name                           = "${each.key}-file"
  resource_group_name            = try(each.value.resource_group_name, module.resource_group[each.value.resource_group_name].name, module.resource_group_existing[each.value.resource_group_name].name)
  location                       = try(var.global_settings.location, module.resource_group[each.value.resource_group_name].location, module.resource_group_existing[each.value.resource_group_name].location, each.value.location)
  subnet_id                      = try(each.value.subnet_id, module.virtual_subnets[each.value.pe_subnet].id, module.subnets[each.value.pe_subnet].id, module.subnets_existing[each.value.pe_subnet].id)
  private_dns_zone_ids           = [try(module.dns["privatelink.file.blob.core.windows.net"].id, module.dns_existing["privatelink.file.blob.core.windows.net"].id, module.dns_existing_remote["privatelink.file.blob.core.windows.net"].id, module.dns_existing_remote2["privatelink.file.blob.core.windows.net"].id, module.dns_existing_remote3["privatelink.file.blob.core.windows.net"].id, module.dns["privatelink.file.blob.core.usgovcldoudapi.net"].id, module.dns_existing["privatelink.file.blob.core.usgovcldoudapi.net"].id, module.dns_existing_remote["privatelink.file.blob.core.usgovcldoudapi.net"].id, module.dns_existing_remote2["privatelink.file.blob.core.usgovcldoudapi.net"].id, module.dns_existing_remote3["privatelink.file.blob.core.usgovcldoudapi.net"].id)]
  private_connection_resource_id = module.storage_account[each.key].id
  subresource_names              = ["file"]

  tags = merge(try(each.value.tags, {}), var.global_settings.tags)
}

/**************************************************************************
********************* Diagnostics Creation ********************************
**************************************************************************/

module "storage_diagnostics" {
  depends_on = [module.storage_account]
  source     = "./modules/diagnostics-settings"
  for_each = { for key, value in var.storage_accounts : key => value
    if try(value.diagnostics, false) == true
  }

  name                           = "${each.key}-diagnostics"
  target_resource_id             = module.storage_account[each.key].id
  log_analytics_workspace_id     = try(each.value.log_analytics_workspace_id, module.log_analytics[each.value.log_analytics_name].id, module.log_analytics_existing[each.value.log_analytics_name].id, module.log_analytics_existing_remote[each.value.log_analytics_name].id, module.log_analytics_existing_remote2[each.value.log_analytics_name], module.log_analytics_existing_remote3[each.value.log_analytics_name].id, null)
  log_analytics_destination_type = lookup(each.value, "log_analytics_destination_type", "Dedicated")
  storage_account_id             = try(each.value.storage_account_id, module.storage_account[each.value.storage_account_name].id, module.storage_account_existing[each.value.storage_account_name].id, module.storage_account_existing_remote[each.value.storage_account_name].id, module.storage_account_existing_remote2[each.value.storage_account_name].id, module.storage_account_existing_remote3[each.value.storage_account_name].id, null)
  eventhub_name                  = try(each.value.eventhub_name, /*module.eventhub[each.value.event_hub_name].name, module.eventhub_existing[each.value.event_hub_name].name,*/ null)
  eventhub_authorization_rule_id = try(each.value.eventhub_authorization_rule_id, /*module.eventhub[each.value.event_hub_name].authorization_rule_id, module.eventhub_existing[each.value.event_hub_name].authorization_rule_id,*/ null)
  partner_solution_id            = try(each.value.partner_solution_id, null)
}

/**************************************************************************
********************* Storage Account Existing ****************************
**************************************************************************/

module "storage_account_existing" {
  depends_on = [module.resource_group]
  source     = "./modules/storage-accounts/storage-account-existing"
  for_each = { for key, value in var.storage_accounts : key => value
    if try(value.existing, false) && !try(value.remote, false) && !try(value.remote2, false) && !try(value.remote3, false)
  }

  name                = each.key
  resource_group_name = try(each.value.resource_group_name, module.resource_group[each.value.resource_group_name].name, module.resource_group_existing[each.value.resource_group_name].name, module.resource_group_existing_remote[each.value.resource_group_name].name, module.resource_group_existing_remote2[each.value.resource_group_name].name, module.resource_group_existing_remote3[each.value.resource_group_name].name)
}

module "storage_account_existing_remote" {
  depends_on = [module.resource_group]
  source     = "./modules/storage-accounts/storage-account-existing"
  for_each = { for key, value in var.storage_accounts : key => value
    if try(value.existing, false) && try(value.remote, false) && !try(value.remote2, false) && !try(value.remote3, false)
  }

  name                = each.key
  resource_group_name = try(each.value.resource_group_name, module.resource_group[each.value.resource_group_name].name, module.resource_group_existing[each.value.resource_group_name].name, module.resource_group_existing_remote[each.value.resource_group_name].name, module.resource_group_existing_remote2[each.value.resource_group_name].name, module.resource_group_existing_remote3[each.value.resource_group_name].name)

  providers = {
    azurerm = azurerm.remote
  }
}

module "storage_account_existing_remote2" {
  depends_on = [module.resource_group]
  source     = "./modules/storage-accounts/storage-account-existing"
  for_each = { for key, value in var.storage_accounts : key => value
    if try(value.existing, false) && !try(value.remote, false) && try(value.remote2, false) && !try(value.remote3, false)
  }

  name                = each.key
  resource_group_name = try(each.value.resource_group_name, module.resource_group[each.value.resource_group_name].name, module.resource_group_existing[each.value.resource_group_name].name, module.resource_group_existing_remote[each.value.resource_group_name].name, module.resource_group_existing_remote2[each.value.resource_group_name].name, module.resource_group_existing_remote3[each.value.resource_group_name].name)

  providers = {
    azurerm = azurerm.remote2
  }
}

module "storage_account_existing_remote3" {
  depends_on = [module.resource_group]
  source     = "./modules/storage-accounts/storage-account-existing"
  for_each = { for key, value in var.storage_accounts : key => value
    if try(value.existing, false) && !try(value.remote, false) && !try(value.remote2, false) && try(value.remote3, false)
  }

  name                = each.key
  resource_group_name = try(each.value.resource_group_name, module.resource_group[each.value.resource_group_name].name, module.resource_group_existing[each.value.resource_group_name].name, module.resource_group_existing_remote[each.value.resource_group_name].name, module.resource_group_existing_remote2[each.value.resource_group_name].name, module.resource_group_existing_remote3[each.value.resource_group_name].name)

  providers = {
    azurerm = azurerm.remote3
  }
}

locals {
  storage_accounts = merge(module.storage_account, module.storage_account_existing, module.storage_account_existing_remote, module.storage_account_existing_remote2, module.storage_account_existing_remote3)
}

output "storage_accounts" {
  value = local.storage_accounts
}