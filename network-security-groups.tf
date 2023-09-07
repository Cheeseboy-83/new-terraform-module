/**************************************************************************
**************** Network Security Groups Creation *************************
**************************************************************************/

module "network_security_group" {
  depends_on = [module.resource_group]
  source     = "./modules/network/network-security-groups/nsg-create"
  for_each = { for key, value in var.network_security_groups : key => value
    if !try(value.existing, false) && !try(value.remote, false) && !try(value.remote2, false) && !try(value.remote3, false)
  }

  subnet_name          = each.value.subnet
  virtual_network_name = each.value.vnet
  name                 = each.key
  resource_group_name  = try(each.value.resource_group_name, module.resource_group[each.value.resource_group_name].name, module.resource_group_existing[each.value.resource_group_name].name, module.resource_group_existing_remote[each.value.resource_group_name].name, module.resource_group_existing_remote2[each.value.resource_group_name].name, module.resource_group_existing_remote3[each.value.resource_group_name].name)
  location             = try(each.value.location, var.global_settings.location, module.resource_group[each.value.resource_group_name].location, module.resource_group_existing[each.value.resource_group_name].location, module.resource_group_existing_remote[each.value.resource_group_name].location, module.resource_group_existing_remote2[each.value.resource_group_name].location, module.resource_group_existing_remote3[each.value.resource_group_name].location)

  rules = try(each.value.rules, {})

  tags = merge(try(each.value.tags, {}), var.global_settings.tags)
}

/**************************************************************************
**************** Network Security Groups Existing *************************
**************************************************************************/

module "network_security_group_existing" {
  depends_on = [module.resource_group]
  source     = "./modules/network/network-security-groups/nsg-existing"
  for_each = { for key, value in var.network_security_groups : key => value
    if try(value.existing, false) && !try(value.remote, false) && !try(value.remote2, false) && !try(value.remote3, false)
  }

  name                = each.key
  resource_group_name = try(each.value.resource_group_name, module.resource_group[each.value.resource_group_name].name, module.resource_group_existing[each.value.resource_group_name].name, module.resource_group_existing_remote[each.value.resource_group_name].name, module.resource_group_existing_remote2[each.value.resource_group_name].name, module.resource_group_existing_remote3[each.value.resource_group_name].name)
}

module "network_security_group_existing_remote" {
  depends_on = [module.resource_group]
  source     = "./modules/network/network-security-groups/nsg-existing"
  for_each = { for key, value in var.network_security_groups : key => value
    if try(value.existing, false) && try(value.remote, false) && !try(value.remote2, false) && !try(value.remote3, false)
  }

  name                = each.key
  resource_group_name = try(each.value.resource_group_name, module.resource_group[each.value.resource_group_name].name, module.resource_group_existing[each.value.resource_group_name].name, module.resource_group_existing_remote[each.value.resource_group_name].name, module.resource_group_existing_remote2[each.value.resource_group_name].name, module.resource_group_existing_remote3[each.value.resource_group_name].name)

  providers = {
    azurerm = azurerm.remote
  }
}

module "network_security_group_existing_remote2" {
  depends_on = [module.resource_group]
  source     = "./modules/network/network-security-groups/nsg-existing"
  for_each = { for key, value in var.network_security_groups : key => value
    if try(value.existing, false) && !try(value.remote, false) && try(value.remote2, false) && !try(value.remote3, false)
  }

  name                = each.key
  resource_group_name = try(each.value.resource_group_name, module.resource_group[each.value.resource_group_name].name, module.resource_group_existing[each.value.resource_group_name].name, module.resource_group_existing_remote[each.value.resource_group_name].name, module.resource_group_existing_remote2[each.value.resource_group_name].name, module.resource_group_existing_remote3[each.value.resource_group_name].name)

  providers = {
    azurerm = azurerm.remote2
  }
}

module "network_security_group_existing_remote3" {
  depends_on = [module.resource_group]
  source     = "./modules/network/network-security-groups/nsg-existing"
  for_each = { for key, value in var.network_security_groups : key => value
    if try(value.existing, false) && !try(value.remote, false) && !try(value.remote2, false) && try(value.remote3, false)
  }

  name                = each.key
  resource_group_name = try(each.value.resource_group_name, module.resource_group[each.value.resource_group_name].name, module.resource_group_existing[each.value.resource_group_name].name, module.resource_group_existing_remote[each.value.resource_group_name].name, module.resource_group_existing_remote2[each.value.resource_group_name].name, module.resource_group_existing_remote3[each.value.resource_group_name].name)

  providers = {
    azurerm = azurerm.remote3
  }
}

locals {
  network_security_groups = merge(
    module.network_security_group,
    module.network_security_group_existing,
    module.network_security_group_existing_remote,
    module.network_security_group_existing_remote2,
    module.network_security_group_existing_remote3
  )
}

output "network_security_groups" {
  value = local.network_security_groups
}