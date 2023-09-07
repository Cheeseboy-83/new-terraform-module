/**************************************************************************
********************* Network Watcher Creation ****************************
**************************************************************************/

module "network_watcher" {
  depends_on = [module.resource_group]
  source     = "./modules/network/network-watchers/network-watcher-create"
  for_each = { for key, value in var.network_watchers : key => value
    if try(value.existing, false) == false
  }

  name                = each.key
  resource_group_name = try(each.value.resource_group_name, module.resource_group[each.value.resource_group_name].name, module.resource_group_existing[each.value.resource_group_name].name)
  location            = try(var.global_settings.location, module.resource_group[each.value.resource_group_name].location, module.resource_group_existing[each.value.resource_group_name].location, each.value.location)

  tags = merge(try(each.value.tags, {}), var.global_settings.tags)
}

/**************************************************************************
********************* Network Watcher Existing ****************************
**************************************************************************/

module "network_watcher_existing" {
  depends_on = [module.resource_group]
  source     = "./modules/network/network-watchers/network-watcher-existing"
  for_each = { for key, value in var.network_watchers : key => value
    if try(value.existing, false) == true
  }

  name                = each.key
  resource_group_name = try(each.value.resource_group_name, module.resource_group[each.value.resource_group_name].name, module.resource_group_existing[each.value.resource_group_name].name)
}