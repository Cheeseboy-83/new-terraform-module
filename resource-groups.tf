/**************************************************************************
****************** Resource Group Creation ********************************
**************************************************************************/

module "resource_group" {
  source = "./modules/resource-groups/resource-groups-create"
  for_each = { for key, value in var.resource_groups : key => value
    if try(value.existing, false) == false
  }

  name     = each.key
  location = try(var.global_settings.location, each.value.location)
  tags     = merge(try(each.value.tags, {}), var.global_settings.tags)
}

/**************************************************************************
****************** Resource Group Existing ********************************
**************************************************************************/

module "resource_group_existing" {
  depends_on = [module.resource_group]
  source     = "./modules/resource-groups/resource-groups-existing"
  for_each = { for key, value in var.resource_groups : key => value
    if try(value.existing, false) && !try(value.remote, false) && !try(value.remote2, false) && !try(value.remote3, false)
  }

  name = each.key
}

module "resource_group_existing_remote" {
  depends_on = [module.resource_group]
  source     = "./modules/resource-groups/resource-groups-existing"
  for_each = { for key, value in var.resource_groups : key => value
    if try(value.existing, false) && try(value.remote, false) && !try(value.remote2, false) && !try(value.remote3, false)
  }

  name = each.key

  providers = {
    azurerm = azurerm.remote
  }
}

module "resource_group_existing_remote2" {
  depends_on = [module.resource_group]
  source     = "./modules/resource-groups/resource-groups-existing"
  for_each = { for key, value in var.resource_groups : key => value
    if try(value.existing, false) && !try(value.remote, false) && try(value.remote2, false) && !try(value.remote3, false)
  }

  name = each.key

  providers = {
    azurerm = azurerm.remote2
  }
}

module "resource_group_existing_remote3" {
  depends_on = [module.resource_group]
  source     = "./modules/resource-groups/resource-groups-existing"
  for_each = { for key, value in var.resource_groups : key => value
    if try(value.existing, false) && !try(value.remote, false) && !try(value.remote2, false) && try(value.remote3, false)
  }

  name = each.key

  providers = {
    azurerm = azurerm.remote3
  }
}

locals {
  resource_groups = merge(module.resource_group, module.resource_group_existing, module.resource_group_existing_remote, module.resource_group_existing_remote2, module.resource_group_existing_remote3)
}

output "resource_groups" {
  value = local.resource_groups
}