/**************************************************************************
************** Recovery Services Vaults Creation **************************
**************************************************************************/

module "recovery_services_vault" {
  depends_on = [module.resource_group]
  source     = "./modules/recovery-services-vaults/recovery-services-vaults-create"
  for_each = { for key, value in var.recovery_services_vaults : key => value
    if !try(value.existing, false) && !try(value.remote, false) && !try(value.remote2, false) && !try(value.remote3, false)
  }

  name                          = each.key
  resource_group_name           = try(each.value.resource_group_name, module.resource_group[each.value.resource_group_name].name, module.resource_group_existing[each.value.resource_group_name].name)
  location                      = try(var.global_settings.location, module.resource_group[each.value.resource_group_name].location, module.resource_group_existing[each.value.resource_group_name].location, each.value.location)
  sku                           = each.value.sku
  public_network_access_enabled = lookup(each.value, "public_network_access_enabled", true)
  soft_delete_enabled           = lookup(each.value, "soft_delete_enabled", true)
  backup_policies               = lookup(each.value, "backup_policies", {})

  tags = merge(try(each.value.tags, {}), var.global_settings.tags)
}

/**************************************************************************
******************* Private Endpoint Creation *****************************
**************************************************************************/

module "rsv_endpoint" {
  depends_on = [module.recovery_services_vault]
  source     = "./modules/private-endpoint"
  for_each = { for key, value in var.recovery_services_vaults : key => value
    if try(value.private_endpoint, false) == true
  }

  name                           = "${each.key}-rsv"
  resource_group_name            = try(each.value.resource_group_name, module.resource_group[each.value.resource_group_name].name, module.resource_group_existing[each.value.resource_group_name].name)
  location                       = try(var.global_settings.location, module.resource_group[each.value.resource_group_name].location, module.resource_group_existing[each.value.resource_group_name].location, each.value.location)
  subnet_id                      = try(each.value.subnet_id, try(module.virtual_network[each.value.vnet].virtual_subnets[each.value.pe_subnet].id, module.subnets[each.value.pe_subnet].id, module.subnets_existing[each.value.pe_subnet].id))
  private_dns_zone_ids           = [try(module.dns["privatelink.${each.value.loc}.backup.windowsazure.com"].id, module.dns_existing["privatelink.${each.value.loc}.backup.windowsazure.com"].id, module.dns_existing_remote["privatelink.${each.value.loc}.backup.windowsazure.com"].id, module.dns_existing_remote2["privatelink.${each.value.loc}.backup.windowsazure.com"].id, module.dns_existing_remote3["privatelink.${each.value.loc}.backup.windowsazure.com"].id, module.dns["privatelink.${each.value.loc}.backup.windowsazure.us"].id, module.dns_existing["privatelink.${each.value.loc}.backup.windowsazure.us"].id, module.dns_existing_remote["privatelink.${each.value.loc}.backup.windowsazure.us"].id, module.dns_existing_remote2["privatelink.${each.value.loc}.backup.windowsazure.us"].id, module.dns_existing_remote3["privatelink.${each.value.loc}.backup.windowsazure.us"].id)]
  private_connection_resource_id = module.recovery_services_vault[each.key].id
  subresource_names              = ["AzureBackup"]

  tags = merge(try(each.value.tags, {}), var.global_settings.tags)
}

/**************************************************************************
********************* Diagnostics Creation ********************************
**************************************************************************/

module "rsv_diagnostics" {
  depends_on = [module.recovery_services_vault]
  source     = "./modules/diagnostics-settings"
  for_each = { for key, value in var.recovery_services_vaults : key => value
    if try(value.diagnostics, false) == true
  }

  name                           = "${each.key}-diagnostics"
  target_resource_id             = module.recovery_services_vault[each.key].id
  log_analytics_workspace_id     = try(each.value.log_analytics_workspace_id, module.log_analytics[each.value.log_analytics_name].id, module.log_analytics_existing[each.value.log_analytics_name].id, module.log_analytics_existing_remote[each.value.log_analytics_name].id, module.log_analytics_existing_remote2[each.value.log_analytics_name].id, module.log_analytics_existing_remote3[each.value.log_analytics_name].id, null)
  log_analytics_destination_type = lookup(each.value, "log_analytics_destination_type", "Dedicated")
  storage_account_id             = try(each.value.recovery_services_vault_id, module.storage_account[each.value.storage_account_name].id, module.storage_account_existing[each.value.storage_account_name].id, module.storage_account_existing_remote[each.value.storage_account_name].id, module.storage_account_existing_remote2[each.value.storage_account_name].id, module.storage_account_existing_remote3[each.value.storage_account_name].id, null)
  eventhub_name                  = try(each.value.eventhub_name, /*module.eventhub[each.value.event_hub_name].name, module.eventhub_existing[each.value.event_hub_name].name,*/ null)
  eventhub_authorization_rule_id = try(each.value.eventhub_authorization_rule_id, /*module.eventhub[each.value.event_hub_name].authorization_rule_id, module.eventhub_existing[each.value.event_hub_name].authorization_rule_id,*/ null)
  partner_solution_id            = try(each.value.partner_solution_id, null)
}

/**************************************************************************
************** Recovery Services Vaults Existing **************************
**************************************************************************/

module "rsv_existing" {
  source = "./modules/recovery-services-vaults/recovery-services-vaults-existing"
  for_each = { for key, value in var.recovery_services_vaults : key => value
    if try(value.existing, false) && !try(value.remote, false) && !try(value.remote2, false) && !try(value.remote3, false)
  }

  name                = each.key
  resource_group_name = each.value.resource_group_name
}

module "rsv_existing_remote" {
  source = "./modules/recovery-services-vaults/recovery-services-vaults-existing"
  for_each = { for key, value in var.recovery_services_vaults : key => value
    if try(value.existing, false) && try(value.remote, false) && !try(value.remote2, false) && !try(value.remote3, false)
  }

  name                = each.key
  resource_group_name = each.value.resource_group_name

  providers = {
    azurerm = azurerm.remote
  }
}

module "rsv_existing_remote2" {
  source = "./modules/recovery-services-vaults/recovery-services-vaults-existing"
  for_each = { for key, value in var.recovery_services_vaults : key => value
    if try(value.existing, false) && !try(value.remote, false) && try(value.remote2, false) && !try(value.remote3, false)
  }

  name                = each.key
  resource_group_name = each.value.resource_group_name

  providers = {
    azurerm = azurerm.remote2
  }
}

module "rsv_existing_remote3" {
  source = "./modules/recovery-services-vaults/recovery-services-vaults-existing"
  for_each = { for key, value in var.recovery_services_vaults : key => value
    if try(value.existing, false) && !try(value.remote, false) && !try(value.remote2, false) && try(value.remote3, false)
  }

  name                = each.key
  resource_group_name = each.value.resource_group_name

  providers = {
    azurerm = azurerm.remote3
  }
}

/**************************************************************************
**************** VM Backup Policies Existing ******************************
**************************************************************************/

module "vm_backup_policy_existing" {
  source = "./modules/recovery-services-vaults/backup-policies-vm-existing"
  for_each = { for key, value in var.vm_backup_policies : key => value
    if try(value.existing, false) && !try(value.remote, false) && !try(value.remote2, false) && !try(value.remote3, false)
  }

  name                = each.key
  resource_group_name = each.value.resource_group_name
  recovery_vault_name = each.value.recovery_vault_name
}

module "vm_backup_policy_existing_remote" {
  source = "./modules/recovery-services-vaults/backup-policies-vm-existing"
  for_each = { for key, value in var.vm_backup_policies : key => value
    if try(value.existing, false) && try(value.remote, false) && !try(value.remote2, false) && !try(value.remote3, false)
  }

  name                = each.key
  resource_group_name = each.value.resource_group_name
  recovery_vault_name = each.value.recovery_vault_name

  providers = {
    azurerm = azurerm.remote
  }
}

module "vm_backup_policy_existing_remote2" {
  source = "./modules/recovery-services-vaults/backup-policies-vm-existing"
  for_each = { for key, value in var.vm_backup_policies : key => value
    if try(value.existing, false) && try(value.remote2, false) && !try(value.remote3, false)
  }

  name                = each.key
  resource_group_name = each.value.resource_group_name
  recovery_vault_name = each.value.recovery_vault_name

  providers = {
    azurerm = azurerm.remote2
  }
}

module "vm_backup_policy_existing_remote3" {
  source = "./modules/recovery-services-vaults/backup-policies-vm-existing"
  for_each = { for key, value in var.vm_backup_policies : key => value
    if try(value.existing, false) && try(value.remote3, false)
  }

  name                = each.key
  resource_group_name = each.value.resource_group_name
  recovery_vault_name = each.value.recovery_vault_name

  providers = {
    azurerm = azurerm.remote3
  }
}