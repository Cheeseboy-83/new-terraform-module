/**************************************************************************
****************** Avalability Sets Creation ******************************
**************************************************************************/

module "availability_set" {
  depends_on = [module.resource_group]
  source     = "./modules/availability-sets/availability-sets-create"
  for_each = { for key, value in var.availability_sets : key => value
    if try(value.existing, false) == false
  }

  name                         = each.key
  location                     = try(var.global_settings.location, module.resource_group[each.value.resource_group_name].location, module.resource_group_existing[each.value.resource_group_name].location, each.value.location)
  resource_group_name          = try(each.value.resource_group_name, module.resource_group[each.value.resource_group_name].name, module.resource_group_existing[each.value.resource_group_name].name)
  platform_fault_domain_count  = lookup(each.value, "platform_fault_domain_count", 3)
  platform_update_domain_count = lookup(each.value, "platform_update_domain_count", 5)
  managed                      = lookup(each.value, "managed", true)

  tags = merge(try(each.value.tags, {}), var.global_settings.tags)
}

module "av_set_diagnostics" {
  depends_on = [module.availability_set]
  source     = "./modules/diagnostics-settings"
  for_each = { for key, value in var.availability_sets : key => value
    if try(value.diagnostics, false) == true
  }

  name                           = "${each.key}-diagnostics"
  target_resource_id             = module.availability_set[each.key].id
  log_analytics_workspace_id     = try(each.value.log_analytics_workspace_id, try(module.log_analytics[each.value.each.valueresource_group_name].id, module.log_analytics_existing[each.value.each.valueresource_group_name].id, module.log_analytics_existing_remote[each.value.each.valueresource_group_name].id, module.log_analytics_existing_remote2[each.value.each.valueresource_group_name].id, module.log_analytics_existing_remote3[each.value.each.valueresource_group_name].id, null))
  log_analytics_destination_type = lookup(each.value, "log_analytics_destination_type", "Dedicated")
  storage_account_id             = try(each.value.storage_account_id, try(module.storage_account[each.value.sa_key].id, module.storage_account_existing[each.value.sa_key].id, module.storage_account_existing_remote[each.value.sa_key].id, module.storage_account_existing_remote2[each.value.sa_key].id, module.storage_account_existing_remote3[each.value.sa_key].id, null))
  eventhub_name                  = try(each.value.eventhub_name, try(/*module.eventhub[each.value.each.value.eventhub_name].name, module.eventhub_existing[each.value.each.value.eventhub_name].name, module.eventhub_existing_remote[each.value.eventhub_name].name, module.eventhub_existing_remote2[each.value.eventhub_name].name, module.eventhub_existing_remote3[each.value.eventhub_name].name*/ null))
  eventhub_authorization_rule_id = try(each.value.eventhub_authorization_rule_id, try(/*module.eventhub[each.value.each.value.eventhub_name].authorization_rule_id, module.eventhub_existing[each.value.each.value.eventhub_name].authorization_rule_id, module.eventhub_existing_remote[each.value.each.value.eventhub_name].authorization_rule_id, module.eventhub_existing_remote2[each.value.each.value.eventhub_name].authorization_rule_id, module.eventhub_existing_remote3[each.value.each.value.eventhub_name].authorization_rule_id,*/ null))
  partner_solution_id            = try(each.value.partner_solution_id, null)
}

/**************************************************************************
****************** Avalability Sets Existing ******************************
**************************************************************************/

module "availability_set_existing" {
  depends_on = [module.resource_group]
  source     = "./modules/availability-sets/availability-sets-existing"
  for_each = { for key, value in var.availability_sets : key => value
    if try(value.existing, false) == true && !try(value.remote, false) == false && !try(value.remote2, false) == false && !try(value.remote3, false) == false
  }

  name                = each.key
  resource_group_name = try(each.value.resource_group_name, module.resource_group[each.value.resource_group_name].name, module.resource_group_existing[each.value.resource_group_name].name, module.resource_group_existing_remote[each.value.resource_group_name].name, module.resource_group_existing_remote2[each.value.resource_group_name].name, module.resource_group_existing_remote3[each.value.resource_group_name].name)
}

module "availability_set_existing_remote" {
  depends_on = [module.resource_group]
  source     = "./modules/availability-sets/availability-sets-existing"
  for_each = { for key, value in var.availability_sets : key => value
    if try(value.existing, false) == true && try(value.remote, false) == true && try(value.remote2, false) == false && try(value.remote3, false) == false
  }

  name                = each.key
  resource_group_name = try(each.value.resource_group_name, module.resource_group[each.value.resource_group_name].name, module.resource_group_existing[each.value.resource_group_name].name, module.resource_group_existing_remote[each.value.resource_group_name].name, module.resource_group_existing_remote2[each.value.resource_group_name].name, module.resource_group_existing_remote3[each.value.resource_group_name].name)

  providers = {
    azurerm = azurerm.remote
  }
}

module "availability_set_existing_remote2" {
  depends_on = [module.resource_group]
  source     = "./modules/availability-sets/availability-sets-existing"
  for_each = { for key, value in var.availability_sets : key => value
    if try(value.existing, false) == true && try(value.remote, false) == false && try(value.remote2, false) == true && try(value.remote3, false) == false
  }

  name                = each.key
  resource_group_name = try(each.value.resource_group_name, module.resource_group[each.value.resource_group_name].name, module.resource_group_existing[each.value.resource_group_name].name, module.resource_group_existing_remote[each.value.resource_group_name].name, module.resource_group_existing_remote2[each.value.resource_group_name].name, module.resource_group_existing_remote3[each.value.resource_group_name].name)

  providers = {
    azurerm = azurerm.remote2
  }
}

module "availability_set_existing_remote3" {
  depends_on = [module.resource_group]
  source     = "./modules/availability-sets/availability-sets-existing"
  for_each = { for key, value in var.availability_sets : key => value
    if try(value.existing, false) == true && try(value.remote, false) == false && try(value.remote2, false) == false && try(value.remote3, false) == true
  }

  name                = each.key
  resource_group_name = try(each.value.resource_group_name, module.resource_group[each.value.resource_group_name].name, module.resource_group_existing[each.value.resource_group_name].name, module.resource_group_existing_remote[each.value.resource_group_name].name, module.resource_group_existing_remote2[each.value.resource_group_name].name, module.resource_group_existing_remote3[each.value.resource_group_name].name)

  providers = {
    azurerm = azurerm.remote3
  }
}

locals {
  availability_sets = merge(module.availability_set, module.availability_set_existing, module.availability_set_existing_remote, module.availability_set_existing_remote2, module.availability_set_existing_remote3)
}

output "availability_sets" {
  value = local.availability_sets
}