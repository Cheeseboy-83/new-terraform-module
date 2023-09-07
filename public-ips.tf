/**************************************************************************
*********************** Public IP Creation ********************************
**************************************************************************/

module "public_ip" {
  depends_on = [module.resource_group]
  source     = "./modules/network/public-ips/public-ips-create"
  for_each = { for key, value in var.public_ips : key => value
    if !try(value.existing, false) && !try(value.remote, false) && !try(value.remote2, false) && !try(value.remote3, false)
  }

  name                    = each.key
  resource_group_name     = try(each.value.resource_group_name, module.resource_group[each.value.resource_group_name].name, module.resource_group_existing[each.value.resource_group_name].name)
  location                = try(var.global_settings.location, module.resource_group[each.value.resource_group_name].location, module.resource_group_existing[each.value.resource_group_name].location, each.value.location)
  allocation_method       = lookup(each.value, "allocation_method", "Static")
  zones                   = lookup(each.value, "zones", null)
  domain_name_label       = lookup(each.value, "domain_name_label", null)
  sku                     = lookup(each.value, "sku", "Basic")
  sku_tier                = lookup(each.value, "sku_tier", null)
  ddos_protection_mode    = lookup(each.value, "ddos_protection_mode", null)
  ddos_protection_plan_id = lookup(each.value, "ddos_protection_plan_id", null)

  tags = merge(try(each.value.tags, {}), var.global_settings.tags)
}

/**************************************************************************
********************* Diagnostics Creation ********************************
**************************************************************************/

module "pip_diagnostics" {
  depends_on = [module.public_ip]
  source     = "./modules/diagnostics-settings"
  for_each = { for key, value in var.public_ips : key => value
    if try(value.diagnostics, false) == true
  }

  name                           = "${each.key}-diagnostics"
  target_resource_id             = module.public_ip[each.key].id
  log_analytics_workspace_id     = try(each.value.log_analytics_workspace_id, module.log_analytics[each.value.log_analytics_name].id, module.log_analytics_existing[each.value.log_analytics_name].id, module.log_analytics_existing_remote[each.value.log_analytics_name].id, module.log_analytics_existing_remote2[each.value.log_analytics_name].id, module.log_analytics_existing_remote3[each.value.log_analytics_name].id, null)
  log_analytics_destination_type = lookup(each.value, "log_analytics_destination_type", "Dedicated")
  storage_account_id             = try(each.value.storage_account_id, module.storage_account[each.value.storage_account_name].id, module.storage_account_existing[each.value.storage_account_name].id, module.storage_account_existing_remote[each.value.storage_account_name].id, module.storage_account_existing_remote2[each.value.storage_account_name].id, module.storage_account_existing_remote3[each.value.storage_account_name].id, null)
  eventhub_name                  = try(each.value.eventhub_name, /*module.eventhub[each.value.event_hub_name].name, module.eventhub_existing[each.value.event_hub_name].name,*/ null)
  eventhub_authorization_rule_id = try(each.value.eventhub_authorization_rule_id, /*module.eventhub[each.value.event_hub_name].authorization_rule_id, module.eventhub_existing[each.value.event_hub_name].authorization_rule_id,*/ null)
  partner_solution_id            = try(each.value.partner_solution_id, null)
}

/**************************************************************************
*********************** Public IP Existing ********************************
**************************************************************************/

module "public_ip_existing" {
  source = "./modules/network/public-ips/public-ips-existing"
  for_each = { for key, value in var.public_ips : key => value
    if try(value.existing, false) && !try(value.remote, false) && !try(value.remote2, false) && !try(value.remote3, false)
  }

  name                = each.key
  resource_group_name = try(each.value.resource_group_name, module.resource_group[each.value.resource_group_name].name, module.resource_group_existing[each.value.resource_group_name].name)
}

module "public_ip_existing_remote" {
  source = "./modules/network/public-ips/public-ips-existing"
  for_each = { for key, value in var.public_ips : key => value
    if try(value.existing, false) && try(value.remote, false) && !try(value.remote2, false) && !try(value.remote3, false)
  }

  name                = each.key
  resource_group_name = try(each.value.resource_group_name, module.resource_group[each.value.resource_group_name].name, module.resource_group_existing[each.value.resource_group_name].name)

  providers = {
    azurerm = azurerm.remote
  }
}

module "public_ip_existing_remote2" {
  source = "./modules/network/public-ips/public-ips-existing"
  for_each = { for key, value in var.public_ips : key => value
    if try(value.existing, false) && !try(value.remote, false) && try(value.remote2, false) && !try(value.remote3, false)
  }

  name                = each.key
  resource_group_name = try(each.value.resource_group_name, module.resource_group[each.value.resource_group_name].name, module.resource_group_existing[each.value.resource_group_name].name)

  providers = {
    azurerm = azurerm.remote2
  }
}

module "public_ip_existing_remote3" {
  source = "./modules/network/public-ips/public-ips-existing"
  for_each = { for key, value in var.public_ips : key => value
    if try(value.existing, false) && !try(value.remote, false) && !try(value.remote2, false) && try(value.remote3, false)
  }

  name                = each.key
  resource_group_name = try(each.value.resource_group_name, module.resource_group[each.value.resource_group_name].name, module.resource_group_existing[each.value.resource_group_name].name)

  providers = {
    azurerm = azurerm.remote3
  }
}

locals {
  public_ips = merge(
    module.public_ip,
    module.public_ip_existing,
    module.public_ip_existing_remote,
    module.public_ip_existing_remote2,
    module.public_ip_existing_remote3
  )
}

output "public_ips" {
  value = local.public_ips
}