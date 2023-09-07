/**************************************************************************
****************** DDoS Protection Plan Creation **************************
**************************************************************************/

module "ddos_protection_plan" {
  depends_on = [module.resource_group]
  source     = "./modules/network/ddos-protection-plans/ddos-protection-plans-create"
  for_each = { for key, value in var.ddos_protection_plans : key => value
    if try(value.existing, false) == false
  }

  name                = each.key
  resource_group_name = try(each.value.resource_group_name, module.resource_group[each.value.resource_group_name].name, module.resource_group_existing[each.value.resource_group_name].name)
  location            = try(var.global_settings.location, module.resource_group[each.value.resource_group_name].location, module.resource_group_existing[each.value.resource_group_name].location, each.value.location)

  tags = merge(try(each.value.tags, {}), var.global_settings.tags)
}

/**************************************************************************
****************** DDoS Protection Plan Existing **************************
**************************************************************************/

module "ddos_protection_plan_existing" {
  depends_on = [module.resource_group]
  source     = "./modules/network/ddos-protection-plans/ddos-protection-plans-existing"

  for_each = { for key, value in var.ddos_protection_plans : key => value
    if try(value.existing, false) == true && try(value.remote, false) == false && try(value.remote2, false) == false && try(value.remote3, false) == false
  }

  name                = each.key
  resource_group_name = try(each.value.resource_group_name, module.resource_group[each.value.resource_group_name].name, module.resource_group_existing[each.value.resource_group_name].name, module.resource_group_existing_remote[each.value.resource_group_name].name, module.resource_group_existing_remote2[each.value.resource_group_name].name, module.resource_group_existing_remote3[each.value.resource_group_name].name)
}

module "ddos_protection_plan_existing_remote" {
  depends_on = [module.resource_group]
  source     = "./modules/network/ddos-protection-plans/ddos-protection-plans-existing"

  for_each = { for key, value in var.ddos_protection_plans : key => value
    if try(value.existing, false) == true && try(value.remote, false) == true && try(value.remote2, false) == false && try(value.remote3, false) == false
  }

  name                = each.key
  resource_group_name = try(each.value.resource_group_name, module.resource_group[each.value.resource_group_name].name, module.resource_group_existing[each.value.resource_group_name].name, module.resource_group_existing_remote[each.value.resource_group_name].name, module.resource_group_existing_remote2[each.value.resource_group_name].name, module.resource_group_existing_remote3[each.value.resource_group_name].name)

  providers = {
    azurerm = azurerm.remote
  }
}

module "ddos_protection_plan_existing_remote2" {
  depends_on = [module.resource_group]
  source     = "./modules/network/ddos-protection-plans/ddos-protection-plans-existing"

  for_each = { for key, value in var.ddos_protection_plans : key => value
    if try(value.existing, false) == true && try(value.remote, false) == false && try(value.remote2, false) == true && try(value.remote3, false) == false
  }

  name                = each.key
  resource_group_name = try(each.value.resource_group_name, module.resource_group[each.value.resource_group_name].name, module.resource_group_existing[each.value.resource_group_name].name, module.resource_group_existing_remote[each.value.resource_group_name].name, module.resource_group_existing_remote2[each.value.resource_group_name].name, module.resource_group_existing_remote3[each.value.resource_group_name].name)

  providers = {
    azurerm = azurerm.remote2
  }
}

module "ddos_protection_plan_existing_remote3" {
  depends_on = [module.resource_group]
  source     = "./modules/network/ddos-protection-plans/ddos-protection-plans-existing"

  for_each = { for key, value in var.ddos_protection_plans : key => value
    if try(value.existing, false) == true && try(value.remote, false) == false && try(value.remote2, false) == false && try(value.remote3, false) == true
  }

  name                = each.key
  resource_group_name = try(each.value.resource_group_name, module.resource_group[each.value.resource_group_name].name, module.resource_group_existing[each.value.resource_group_name].name, module.resource_group_existing_remote[each.value.resource_group_name].name, module.resource_group_existing_remote2[each.value.resource_group_name].name, module.resource_group_existing_remote3[each.value.resource_group_name].name)

  providers = {
    azurerm = azurerm.remote3
  }
}

locals {
  ddos_protection_plans = merge(module.ddos_protection_plan, module.ddos_protection_plan_existing, module.ddos_protection_plan_existing_remote, module.ddos_protection_plan_existing_remote2, module.ddos_protection_plan_existing_remote3)
}

output "ddos_protection_plans" {
  value = local.ddos_protection_plans
}