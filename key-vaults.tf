/**************************************************************************
*********************** Key Vault Creation ********************************
**************************************************************************/

module "key_vault" {
  depends_on = [module.resource_group]
  source     = "./modules/key-vaults/key-vaults-create"
  for_each = { for key, value in var.key_vaults : key => value
    if !try(value.existing, false) && !try(value.remote, false) && !try(value.remote2, false) && !try(value.remote3, false)
  }

  name                            = each.key
  resource_group_name             = try(each.value.resource_group_name, module.resource_group[each.value.resource_group_name].name, module.resource_group_existing[each.value.resource_group_name].name)
  location                        = try(each.value.location, module.resource_group[each.value.resource_group_name].location, module.resource_group_existing[each.value.resource_group_name].location)
  sku_name                        = lookup(each.value, "sku_name", "standard")
  tenant_id                       = lookup(each.value, "tenant_id", data.azurerm_client_config.current.tenant_id)
  soft_delete_retention_days      = lookup(each.value, "soft_delete_retention_days", 90)
  purge_protection_enabled        = lookup(each.value, "purge_protection_enabled", true)
  enabled_for_disk_encryption     = lookup(each.value, "enabled_for_disk_encryption", false)
  enabled_for_deployment          = lookup(each.value, "enabled_for_deployment", false)
  enabled_for_template_deployment = lookup(each.value, "enabled_for_template_deployment", false)
  enable_rbac_authorization       = lookup(each.value, "enable_rbac_authorization", false)
  public_network_access_enabled   = lookup(each.value, "public_network_access_enabled", true)
  network_acls                    = lookup(each.value, "network_acls", {})
  access_policies                 = lookup(each.value, "access_policies", {})

  tags = merge(try(each.value.tags, {}), var.global_settings.tags)
}

/**************************************************************************
******************* Private Endpoint Creation *****************************
**************************************************************************/

module "kv_endpoint" {
  depends_on = [module.key_vault]
  source     = "./modules/private-endpoint"
  for_each = { for key, value in var.key_vaults : key => value
    if try(value.private_endpoint, false) == true
  }

  name                           = "${each.key}-vault"
  resource_group_name            = try(each.value.resource_group_name, module.resource_group[each.value.resource_group_name].name, module.resource_group_existing[each.value.resource_group_name].name)
  location                       = try(var.global_settings.location, module.resource_group[each.value.resource_group_name].location, module.resource_group_existing[each.value.resource_group_name].location, each.value.location)
  subnet_id                      = try(each.value.subnet_id, try(module.virtual_network[each.value.vnet].virtual_subnets[each.value.pe_subnet].id, module.subnets[each.value.pe_subnet].id, module.subnets_existing[each.value.pe_subnet].id))
  private_dns_zone_ids           = [try(module.dns["privatelink.vaultcore.azure.net"].id, module.dns_existing["privatelink.vaultcore.azure.net"].id, module.dns_existing_remote["privatelink.vaultcore.azure.net"].id, module.dns_existing_remote2["privatelink.vaultcore.azure.net"].id, module.dns_existing_remote3["privatelink.vaultcore.azure.net"].id, module.dns["privatelink.vaultcore.usgovcloudapi.net"].id, module.dns_existing["privatelink.vaultcore.usgovcloudapi.net"].id, module.dns_existing_remote["privatelink.vaultcore.usgovcloudapi.net"].id, module.dns_existing_remote2["privatelink.vaultcore.usgovcloudapi.net"].id, module.dns_existing_remote3["privatelink.vaultcore.usgovcloudapi.net"].id)]
  private_connection_resource_id = module.key_vault[each.key].id
  subresource_names              = ["vault"]
  tags                           = merge(try(each.value.tags, {}), var.global_settings.tags)
}

/**************************************************************************
********************* Diagnostics Creation ********************************
**************************************************************************/

module "key_vault_diagnostics" {
  depends_on = [module.key_vault]
  source     = "./modules/diagnostics-settings"
  for_each = { for key, value in var.key_vaults : key => value
    if try(value.diagnostics, false) == true
  }

  name                           = "${each.key}-diagnostics"
  target_resource_id             = module.key_vault[each.key].id
  log_analytics_workspace_id     = try(each.value.log_analytics_workspace_id, module.log_analytics[each.value.log_analytics_name].id, module.log_analytics_existing[each.value.log_analytics_name].id, module.log_analytics_existing_remote[each.value.log_analytics_name].id, module.log_analytics_existing_remote2[each.value.log_analytics_name].id, module.log_analytics_existing_remote3[each.value.log_analytics_name].id, null)
  log_analytics_destination_type = lookup(each.value, "log_analytics_destination_type", "Dedicated")
  storage_account_id             = try(each.value.storage_account_id, module.storage_account[each.value.storage_account_name].id, module.storage_account_existing[each.value.storage_account_name].id, module.storage_account_existing_remote[each.value.storage_account_name].id, module.storage_account_existing_remote2[each.value.storage_account_name].id, module.storage_account_existing_remote3[each.value.storage_account_name].id, null)
  eventhub_name                  = try(each.value.eventhub_name, /*module.eventhub[each.value.eh_key].name, module.eventhub_existing[each.value.eh_key].name,*/ null)
  eventhub_authorization_rule_id = try(each.value.eventhub_authorization_rule_id, /*module.eventhub[each.value.eh_key].authorization_rule_id, module.eventhub_existing[each.value.eh_key].authorization_rule_id,*/ null)
  partner_solution_id            = try(each.value.partner_solution_id, null)
}

/**************************************************************************
*********************** Key Vault Existing ********************************
**************************************************************************/

module "key_vault_existing" {
  depends_on = [module.resource_group]
  source     = "./modules/key-vaults/key-vaults-existing"
  for_each = { for key, value in var.key_vaults : key => value
    if try(value.existing, false) && !try(value.remote, false) && !try(value.remote2, false) && !try(value.remote3, false)
  }

  name                = each.key
  resource_group_name = try(each.value.resource_group_name, module.resource_group[each.value.resource_group_name].name, module.resource_group_existing[each.value.resource_group_name].name)
}

module "key_vault_existing_remote" {
  depends_on = [module.resource_group]
  source     = "./modules/key-vaults/key-vaults-existing"
  for_each = { for key, value in var.key_vaults : key => value
    if try(value.existing, false) && try(value.remote, false) && !try(value.remote2, false) && !try(value.remote3, false)
  }

  name                = each.key
  resource_group_name = try(each.value.resource_group_name, module.resource_group[each.value.resource_group_name].name, module.resource_group_existing[each.value.resource_group_name].name)

  providers = {
    azurerm = azurerm.remote
  }
}

module "key_vault_existing_remote2" {
  depends_on = [module.resource_group]
  source     = "./modules/key-vaults/key-vaults-existing"
  for_each = { for key, value in var.key_vaults : key => value
    if try(value.existing, false) && !try(value.remote, false) && try(value.remote2, false) && !try(value.remote3, false)
  }

  name                = each.key
  resource_group_name = try(each.value.resource_group_name, module.resource_group[each.value.resource_group_name].name, module.resource_group_existing[each.value.resource_group_name].name)

  providers = {
    azurerm = azurerm.remote2
  }
}

module "key_vault_existing_remote3" {
  depends_on = [module.resource_group]
  source     = "./modules/key-vaults/key-vaults-existing"
  for_each = { for key, value in var.key_vaults : key => value
    if try(value.existing, false) && !try(value.remote, false) && try(value.remote2, false) && try(value.remote3, false)
  }

  name                = each.key
  resource_group_name = try(each.value.resource_group_name, module.resource_group[each.value.resource_group_name].name, module.resource_group_existing[each.value.resource_group_name].name)

  providers = {
    azurerm = azurerm.remote3
  }
}

locals {
  key_vaults = merge(module.key_vault, module.key_vault_existing, module.key_vault_existing_remote, module.key_vault_existing_remote2, module.key_vault_existing_remote3)
}

output "key_vaults" {
  value = local.key_vaults
}