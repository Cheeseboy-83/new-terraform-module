/**************************************************************************
********************** Route Tables Creation ******************************
**************************************************************************/

module "route_table" {
  depends_on = [module.resource_group]
  source     = "./modules/network/route-tables/route-tables-create"
  for_each = { for key, value in var.route_tables : key => value
    if !try(value.existing, false) && !try(value.remote, false) && !try(value.remote2, false) && !try(value.remote3, false)
  }

  subnet_name                   = each.value.subnet
  virtual_network_name          = each.value.vnet
  name                          = each.key
  resource_group_name           = try(each.value.resource_group_name, module.resource_group[each.value.resource_group_name].name, module.resource_group_existing[each.value.resource_group_name].name, module.resource_group_existing_remote[each.value.resource_group_name].name, module.resource_group_existing_remote2[each.value.resource_group_name].name, module.resource_group_existing_remote3[each.value.resource_group_name].name)
  location                      = try(each.value.location, var.global_settings.location, module.resource_group[each.value.resource_group_name].location, module.resource_group_existing[each.value.resource_group_name].location, module.resource_group_existing_remote[each.value.resource_group_name].location, module.resource_group_existing_remote2[each.value.resource_group_name].location, module.resource_group_existing_remote3[each.value.resource_group_name].location)
  disable_bgp_route_propagation = try(each.value.disable_bgp_route_propagation, false)

  routes = try(each.value.routes, {})

  tags = merge(try(each.value.tags, {}), var.global_settings.tags)
}

/**************************************************************************
********************** Route Tables Existing ******************************
**************************************************************************/

module "route_table_existing" {
  depends_on = [module.resource_group]
  source     = "./modules/network/route-tables/route-tables-existing"
  for_each = { for key, value in var.route_tables : key => value
    if try(value.existing, false) && !try(value.remote, false) && !try(value.remote2, false) && !try(value.remote3, false)
  }

  name                = each.key
  resource_group_name = try(each.value.resource_group_name, module.resource_group[each.value.resource_group_name].name, module.resource_group_existing[each.value.resource_group_name].name, module.resource_group_existing_remote[each.value.resource_group_name].name, module.resource_group_existing_remote2[each.value.resource_group_name].name, module.resource_group_existing_remote3[each.value.resource_group_name].name)
}

module "route_table_existing_remote" {
  depends_on = [module.resource_group]
  source     = "./modules/network/route-tables/route-tables-existing"
  for_each = { for key, value in var.route_tables : key => value
    if try(value.existing, false) && try(value.remote, false) && !try(value.remote2, false) && !try(value.remote3, false)
  }

  name                = each.key
  resource_group_name = try(each.value.resource_group_name, module.resource_group[each.value.resource_group_name].name, module.resource_group_existing[each.value.resource_group_name].name, module.resource_group_existing_remote[each.value.resource_group_name].name, module.resource_group_existing_remote2[each.value.resource_group_name].name, module.resource_group_existing_remote3[each.value.resource_group_name].name)

  providers = {
    azurerm = azurerm.remote
  }
}

module "route_table_existing_remote2" {
  depends_on = [module.resource_group]
  source     = "./modules/network/route-tables/route-tables-existing"
  for_each = { for key, value in var.route_tables : key => value
    if try(value.existing, false) && !try(value.remote, false) && try(value.remote2, false) && !try(value.remote3, false)
  }

  name                = each.key
  resource_group_name = try(each.value.resource_group_name, module.resource_group[each.value.resource_group_name].name, module.resource_group_existing[each.value.resource_group_name].name, module.resource_group_existing_remote[each.value.resource_group_name].name, module.resource_group_existing_remote2[each.value.resource_group_name].name, module.resource_group_existing_remote3[each.value.resource_group_name].name)

  providers = {
    azurerm = azurerm.remote2
  }
}

module "route_table_existing_remote3" {
  depends_on = [module.resource_group]
  source     = "./modules/network/route-tables/route-tables-existing"
  for_each = { for key, value in var.route_tables : key => value
    if try(value.existing, false) && !try(value.remote, false) && !try(value.remote2, false) && try(value.remote3, false)
  }

  name                = each.key
  resource_group_name = try(each.value.resource_group_name, module.resource_group[each.value.resource_group_name].name, module.resource_group_existing[each.value.resource_group_name].name, module.resource_group_existing_remote[each.value.resource_group_name].name, module.resource_group_existing_remote2[each.value.resource_group_name].name, module.resource_group_existing_remote3[each.value.resource_group_name].name)

  providers = {
    azurerm = azurerm.remote3
  }
}

locals {
  route_tables = merge(
    module.route_table,
    module.route_table_existing,
    module.route_table_existing_remote,
    module.route_table_existing_remote2,
    module.route_table_existing_remote3
  )
}

output "route_tables" {
  value = local.route_tables
}