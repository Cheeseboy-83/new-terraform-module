/**************************************************************************

This locals block restructures the data so that this module can consume it in a more compact fashion.
The private_dns_zones variable is a map of objects, where each object has the following schema:

  resource_group_name = string
  vnet                = optional(string)
  existing            = optional(bool)
  remote              = optional(bool)
  remote2             = optional(bool)
  remote3             = optional(bool)
  zones               = list(string)

This terraform file calls the various values of the "zones" list in a loop to create the private DNS
zones in the same resource group, reference them with data blocks if the "existing" value is set to
true, link them to the vnet specified if it is defined in the "private_dns_zones" variable, and bring
them into the state file via modules that call data blocks on various remote providers whose aliases
correspond to the remote, remote2, and remote3 objects (azurerm.remote, azurerm.remote2, or azurerm.remote3)

**************************************************************************/

locals {
  resource_group_name = try(var.private_dns_zones.resource_group_name, null)
  vnet_name           = try(var.private_dns_zones.vnet, null)
  existing            = try(var.private_dns_zones.existing, false)
  remote              = try(var.private_dns_zones.remote, false)
  remote2             = try(var.private_dns_zones.remote2, false)
  remote3             = try(var.private_dns_zones.remote3, false)
  zones               = try(var.private_dns_zones.zones, [])
}

/**************************************************************************
********************* Private DNS Creation ********************************
**************************************************************************/

module "dns" {
  depends_on = [module.resource_group]
  source     = "./modules/private-dns-zones/private-dns-zones-create"
  for_each = { for zone in local.zones : zone => zone
    if !local.existing && !local.remote && !local.remote2 && !local.remote3
  }

  name                = each.value
  resource_group_name = local.resource_group_name
}

/**************************************************************************
********************* Private DNS Link ************************************
**************************************************************************/

module "dns_link" {
  depends_on = [module.dns]
  source     = "./modules/private-dns-zones/private-dns-zone-link"
  for_each = { for zone in local.zones : zone => zone
    if local.vnet_name != null && !local.remote && !local.remote2 && !local.remote3
  }

  name                  = each.value
  resource_group_name   = local.resource_group_name
  private_dns_zone_name = each.value
  virtual_network_id    = try(module.virtual_network[local.vnet_name].id, module.virtual_network_existing[local.vnet_name].id, module.virtual_network_existing_remote[local.vnet_name].id, module.virtual_network_existing_remote2[local.vnet_name].id, module.virtual_network_existing_remote3[local.vnet_name].id)
}

module "dns_link_remote" {
  depends_on = [module.dns]
  source     = "./modules/private-dns-zones/private-dns-zone-link"
  for_each = { for zone in local.zones : zone => zone
    if local.vnet_name != null && local.remote && !local.remote2 && !local.remote3
  }

  name                  = each.value
  resource_group_name   = local.resource_group_name
  private_dns_zone_name = each.value
  virtual_network_id    = try(module.virtual_network[local.vnet_name].id, module.virtual_network_existing[local.vnet_name].id, module.virtual_network_existing_remote[local.vnet_name].id, module.virtual_network_existing_remote2[local.vnet_name].id, module.virtual_network_existing_remote3[local.vnet_name].id)

  providers = {
    azurerm = azurerm.remote
  }
}

module "dns_link_remote2" {
  depends_on = [module.dns]
  source     = "./modules/private-dns-zones/private-dns-zone-link"
  for_each = { for zone in local.zones : zone => zone
    if local.vnet_name != null && !local.remote && local.remote2 && !local.remote3
  }

  name                  = each.value
  resource_group_name   = local.resource_group_name
  private_dns_zone_name = each.value
  virtual_network_id    = try(module.virtual_network[local.vnet_name].id, module.virtual_network_existing[local.vnet_name].id, module.virtual_network_existing_remote[local.vnet_name].id, module.virtual_network_existing_remote2[local.vnet_name].id, module.virtual_network_existing_remote3[local.vnet_name].id)

  providers = {
    azurerm = azurerm.remote2
  }
}

module "dns_link_remote3" {
  depends_on = [module.dns]
  source     = "./modules/private-dns-zones/private-dns-zone-link"
  for_each = { for zone in local.zones : zone => zone
    if local.vnet_name != null && !local.remote && !local.remote2 && local.remote3
  }

  name                  = each.value
  resource_group_name   = local.resource_group_name
  private_dns_zone_name = each.value
  virtual_network_id    = try(module.virtual_network[local.vnet_name].id, module.virtual_network_existing[local.vnet_name].id, module.virtual_network_existing_remote[local.vnet_name].id, module.virtual_network_existing_remote2[local.vnet_name].id, module.virtual_network_existing_remote3[local.vnet_name].id)

  providers = {
    azurerm = azurerm.remote3
  }
}

/**************************************************************************
********************* Private DNS Existing ********************************
**************************************************************************/

module "dns_existing" {
  source = "./modules/private-dns-zones/private-dns-zones-existing"
  for_each = { for zone in local.zones : zone => zone
    if local.existing && !local.remote && !local.remote2 && !local.remote3
  }

  name                = each.value
  resource_group_name = local.resource_group_name
}

module "dns_existing_remote" {
  source = "./modules/private-dns-zones/private-dns-zones-existing"
  for_each = { for zone in local.zones : zone => zone
    if local.existing && local.remote && !local.remote2 && !local.remote3
  }

  name                = each.value
  resource_group_name = local.resource_group_name

  providers = {
    azurerm = azurerm.remote
  }
}

module "dns_existing_remote2" {
  source = "./modules/private-dns-zones/private-dns-zones-existing"
  for_each = { for zone in local.zones : zone => zone
    if local.existing && !local.remote && local.remote2 && !local.remote3
  }

  name                = each.value
  resource_group_name = local.resource_group_name

  providers = {
    azurerm = azurerm.remote2
  }
}

module "dns_existing_remote3" {
  source = "./modules/private-dns-zones/private-dns-zones-existing"
  for_each = { for zone in local.zones : zone => zone
    if local.existing && !local.remote && !local.remote2 && local.remote3
  }

  name                = each.value
  resource_group_name = local.resource_group_name

  providers = {
    azurerm = azurerm.remote3
  }
}

locals {
  dns = merge(module.dns, module.dns_existing, module.dns_existing_remote, module.dns_existing_remote2, module.dns_existing_remote3)
}

output "dns" {
  value = local.dns
}