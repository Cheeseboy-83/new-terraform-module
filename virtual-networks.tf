/**************************************************************************
********************* Virtual Network Creation*****************************
**************************************************************************/

module "virtual_network" {
  depends_on = [module.resource_group]
  source     = "./modules/network/virtual-networks/virtual-networks-create"
  for_each = { for key, value in var.virtual_networks : key => value
    if try(value.existing, false) == false
  }

  name                    = each.key
  resource_group_name     = try(each.value.resource_group_name, module.resource_group[each.value.resource_group_name].name, module.resource_group_existing[each.value.resource_group_name].name)
  location                = try(var.global_settings.location, module.resource_group[each.value.resource_group_name].location, module.resource_group_existing[each.value.resource_group_name].location, each.value.location)
  address_space           = each.value.address_space
  dns_servers             = lookup(each.value, "dns_servers", [])
  ddos_protection_plan_id = lookup(each.value, "ddos_protection_plan", try(each.value.ddos_protection_plan_id, module.ddos_protection_plan[each.value.ddos_key].id, module.ddos_protection_plan_existing[each.value.ddos_key].id, module.ddos_protection_plan_existing_remote[each.value.ddos_key].id, module.ddos_protection_plan_existing_remote2[each.value.ddos_key].id, module.ddos_protection_plan_existing_remote2[each.value.ddos_key].id, null))
  subnets                 = lookup(each.value, "subnets", {})

  tags = merge(try(each.value.tags, {}), var.global_settings.tags)
}

/**************************************************************************
********************* Diagnostics Settings ********************************
**************************************************************************/

module "vnet_diagnostics" {
  depends_on = [module.virtual_network]
  source     = "./modules/diagnostics-settings"
  for_each = { for key, value in var.virtual_networks : key => value
    if try(value.diagnostics_settings, false) == true
  }

  name                           = "${each.key}-diagnostics"
  target_resource_id             = module.virtual_network[each.key].id
  log_analytics_workspace_id     = try(each.value.log_analytics_workspace_id, module.log_analytics[each.value.log_analytics_name].id, module.log_analytics_existing[each.value.log_analytics_name].id, module.log_analytics_existing_remote[each.value.log_analytics_name].id, module.log_analytics_existing_remote2[each.value.log_analytics_name].id, module.log_analytics_existing_remote3[each.value.log_analytics_name].id, null)
  log_analytics_destination_type = lookup(each.value, "log_analytics_destination_type", try("Dedicated", "AzureDiagnostics"))
  storage_account_id             = try(each.value.storage_account_id, module.storage_account[each.value.storage_account_name].id, module.storage_account_existing[each.value.storage_account_name].id, module.storage_account_existing_remote[each.value.storage_account_name].id, module.storage_account_existing_remote2[each.value.storage_account_name].id, module.storage_account_existing_remote3[each.value.storage_account_name].id, null)
  eventhub_name                  = try(each.value.eventhub_name, /*module.eventhub[each.value.eh_key].name, module.eventhub_existing[each.value.eh_key].name,*/ null)
  eventhub_authorization_rule_id = try(each.value.eventhub_authorization_rule_id, /*module.eventhub[each.value.eh_key].authorization_rule_id, module.eventhub_existing[each.value.eh_key].authorization_rule_id,*/ null)
  partner_solution_id            = try(each.value.partner_solution_id, null)
}

/**************************************************************************
********************* Virtual Network Peering *****************************
**************************************************************************/

module "virtual_network_peering" {
  depends_on = [module.resource_group, module.virtual_network]
  source     = "./modules/network/virtual-networks/virtual-networks-peer"
  for_each = { for key, value in var.virtual_network_peerings : key => value
    if !try(value.remote, false) && !try(value.remote2, false) && !try(value.remote3, false)
  }

  name                         = "${try(module.virtual_network[each.value.vnet].name, module.virtual_network_existing[each.value.vnet].name, module.virtual_network_existing_remote[each.value.vnet].name, module.virtual_network_existing_remote2[each.value.vnet].name, module.virtual_network_existing_remote3[each.value.vnet].name)}-TO-${try(module.virtual_network[each.value.remote_vnet].name, module.virtual_network_existing[each.value.remote_vnet].name, module.virtual_network_existing_remote[each.value.remote_vnet].name, module.virtual_network_existing_remote2[each.value.remote_vnet].name, module.virtual_network_existing_remote3[each.value.remote_vnet].name)}"
  resource_group_name          = try(each.value.resource_group_name, module.virtual_network[each.value.vnet].resource_group_name, module.virtual_network_existing[each.value.vnet].resource_group_name, module.virtual_network_existing_remote[each.value.vnet].resource_group_name, module.virtual_network_existing_remote2[each.value.vnet].resource_group_name, module.virtual_network_existing_remote3[each.value.vnet].resource_group_name)
  virtual_network_name         = try(each.value.virtual_network_neme, module.virtual_network[each.value.vnet].name, module.virtual_network_existing[each.value.vnet].name, module.virtual_network_existing_remote[each.value.vnet].name, module.virtual_network_existing_remote2[each.value.vnet].name, module.virtual_network_existing_remote3[each.value.vnet].name)
  remote_virtual_network_id    = try(each.value.remote_virtual_network_id, module.virtual_network[each.value.remote_vnet].id, module.virtual_network_existing[each.value.remote_vnet].id, module.virtual_network_existing_remote[each.value.remote_vnet].id, module.virtual_network_existing_remote2[each.value.remote_vnet].id, module.virtual_network_existing_remote3[each.value.remote_vnet].id)
  allow_virtual_network_access = try(each.value.allow_virtual_network_access, true)
  allow_forwarded_traffic      = try(each.value.allow_forwarded_traffic, false)
  allow_gateway_transit        = try(each.value.allow_gateway_transit, false)
  use_remote_gateways          = try(each.value.use_remote_gateways, false)
}

module "virtual_network_peering_remote" {
  depends_on = [module.resource_group, module.virtual_network]
  source     = "./modules/network/virtual-networks/virtual-networks-peer"
  for_each = { for key, value in var.virtual_network_peerings : key => value
    if try(value.remote, false) && !try(value.remote2, false) && !try(value.remote3, false)
  }

  name                         = "${try(module.virtual_network[each.value.vnet].name, module.virtual_network_existing[each.value.vnet].name, module.virtual_network_existing_remote[each.value.vnet].name, module.virtual_network_existing_remote2[each.value.vnet].name, module.virtual_network_existing_remote3[each.value.vnet].name)}-TO-${try(module.virtual_network[each.value.remote_vnet].name, module.virtual_network_existing[each.value.remote_vnet].name, module.virtual_network_existing_remote[each.value.remote_vnet].name, module.virtual_network_existing_remote2[each.value.remote_vnet].name, module.virtual_network_existing_remote3[each.value.remote_vnet].name)}"
  resource_group_name          = try(each.value.resource_group_name, module.virtual_network[each.value.vnet].resource_group_name, module.virtual_network_existing[each.value.vnet].resource_group_name, module.virtual_network_existing_remote[each.value.vnet].resource_group_name, module.virtual_network_existing_remote2[each.value.vnet].resource_group_name, module.virtual_network_existing_remote3[each.value.vnet].resource_group_name)
  virtual_network_name         = try(each.value.virtual_network_neme, module.virtual_network[each.value.vnet].name, module.virtual_network_existing[each.value.vnet].name, module.virtual_network_existing_remote[each.value.vnet].name, module.virtual_network_existing_remote2[each.value.vnet].name, module.virtual_network_existing_remote3[each.value.vnet].name)
  remote_virtual_network_id    = try(each.value.remote_virtual_network_id, module.virtual_network[each.value.remote_vnet].id, module.virtual_network_existing[each.value.remote_vnet].id, module.virtual_network_existing_remote[each.value.remote_vnet].id, module.virtual_network_existing_remote2[each.value.remote_vnet].id, module.virtual_network_existing_remote3[each.value.remote_vnet].id)
  allow_virtual_network_access = try(each.value.allow_virtual_network_access, true)
  allow_forwarded_traffic      = try(each.value.allow_forwarded_traffic, false)
  allow_gateway_transit        = try(each.value.allow_gateway_transit, false)
  use_remote_gateways          = try(each.value.use_remote_gateways, false)

  providers = {
    azurerm = azurerm.remote
  }
}

module "virtual_network_peering_remote2" {
  depends_on = [module.resource_group, module.virtual_network]
  source     = "./modules/network/virtual-networks/virtual-networks-peer"
  for_each = { for key, value in var.virtual_network_peerings : key => value
    if !try(value.remote, false) && try(value.remote2, false) && !try(value.remote3, false)
  }

  name                         = "${try(module.virtual_network[each.value.vnet].name, module.virtual_network_existing[each.value.vnet].name, module.virtual_network_existing_remote[each.value.vnet].name, module.virtual_network_existing_remote2[each.value.vnet].name, module.virtual_network_existing_remote3[each.value.vnet].name)}-TO-${try(module.virtual_network[each.value.remote_vnet].name, module.virtual_network_existing[each.value.remote_vnet].name, module.virtual_network_existing_remote[each.value.remote_vnet].name, module.virtual_network_existing_remote2[each.value.remote_vnet].name, module.virtual_network_existing_remote3[each.value.remote_vnet].name)}"
  resource_group_name          = try(each.value.resource_group_name, module.virtual_network[each.value.vnet].resource_group_name, module.virtual_network_existing[each.value.vnet].resource_group_name, module.virtual_network_existing_remote[each.value.vnet].resource_group_name, module.virtual_network_existing_remote2[each.value.vnet].resource_group_name, module.virtual_network_existing_remote3[each.value.vnet].resource_group_name)
  virtual_network_name         = try(each.value.virtual_network_neme, module.virtual_network[each.value.vnet].name, module.virtual_network_existing[each.value.vnet].name, module.virtual_network_existing_remote[each.value.vnet].name, module.virtual_network_existing_remote2[each.value.vnet].name, module.virtual_network_existing_remote3[each.value.vnet].name)
  remote_virtual_network_id    = try(each.value.remote_virtual_network_id, module.virtual_network[each.value.remote_vnet].id, module.virtual_network_existing[each.value.remote_vnet].id, module.virtual_network_existing_remote[each.value.remote_vnet].id, module.virtual_network_existing_remote2[each.value.remote_vnet].id, module.virtual_network_existing_remote3[each.value.remote_vnet].id)
  allow_virtual_network_access = try(each.value.allow_virtual_network_access, true)
  allow_forwarded_traffic      = try(each.value.allow_forwarded_traffic, false)
  allow_gateway_transit        = try(each.value.allow_gateway_transit, false)
  use_remote_gateways          = try(each.value.use_remote_gateways, false)

  providers = {
    azurerm = azurerm.remote2
  }
}

module "virtual_network_peering_remote3" {
  depends_on = [module.resource_group, module.virtual_network]
  source     = "./modules/network/virtual-networks/virtual-networks-peer"
  for_each = { for key, value in var.virtual_network_peerings : key => value
    if !try(value.remote, false) && !try(value.remote2, false) && try(value.remote3, false)
  }

  name                         = "${try(module.virtual_network[each.value.vnet].name, module.virtual_network_existing[each.value.vnet].name, module.virtual_network_existing_remote[each.value.vnet].name, module.virtual_network_existing_remote2[each.value.vnet].name, module.virtual_network_existing_remote3[each.value.vnet].name)}-TO-${try(module.virtual_network[each.value.remote_vnet].name, module.virtual_network_existing[each.value.remote_vnet].name, module.virtual_network_existing_remote[each.value.remote_vnet].name, module.virtual_network_existing_remote2[each.value.remote_vnet].name, module.virtual_network_existing_remote3[each.value.remote_vnet].name)}"
  resource_group_name          = try(each.value.resource_group_name, module.virtual_network[each.value.vnet].resource_group_name, module.virtual_network_existing[each.value.vnet].resource_group_name, module.virtual_network_existing_remote[each.value.vnet].resource_group_name, module.virtual_network_existing_remote2[each.value.vnet].resource_group_name, module.virtual_network_existing_remote3[each.value.vnet].resource_group_name)
  virtual_network_name         = try(each.value.virtual_network_neme, module.virtual_network[each.value.vnet].name, module.virtual_network_existing[each.value.vnet].name, module.virtual_network_existing_remote[each.value.vnet].name, module.virtual_network_existing_remote2[each.value.vnet].name, module.virtual_network_existing_remote3[each.value.vnet].name)
  remote_virtual_network_id    = try(each.value.remote_virtual_network_id, module.virtual_network[each.value.remote_vnet].id, module.virtual_network_existing[each.value.remote_vnet].id, module.virtual_network_existing_remote[each.value.remote_vnet].id, module.virtual_network_existing_remote2[each.value.remote_vnet].id, module.virtual_network_existing_remote3[each.value.remote_vnet].id)
  allow_virtual_network_access = try(each.value.allow_virtual_network_access, true)
  allow_forwarded_traffic      = try(each.value.allow_forwarded_traffic, false)
  allow_gateway_transit        = try(each.value.allow_gateway_transit, false)
  use_remote_gateways          = try(each.value.use_remote_gateways, false)

  providers = {
    azurerm = azurerm.remote3
  }
}

/**************************************************************************
********************* Virtual Network Existing*****************************
**************************************************************************/

module "virtual_network_existing" {
  depends_on = [module.resource_group]
  source     = "./modules/network/virtual-networks/virtual-networks-existing"
  for_each = { for key, value in var.virtual_networks : key => value
    if try(value.existing, false) && !try(value.remote, false) && !try(value.remote2, false) && !try(value.remote3, false)
  }

  name                = each.key
  resource_group_name = try(each.value.resource_group_name, module.resource_group[each.value.resource_group_name].name, module.resource_group_existing[each.value.resource_group_name].name, module.resource_group_existing_remote[each.value.resource_group_name].name, module.resource_group_existing_remote2[each.value.resource_group_name].name, module.resource_group_existing_remote3[each.value.resource_group_name].name)
}

module "virtual_network_existing_remote" {
  depends_on = [module.resource_group]
  source     = "./modules/network/virtual-networks/virtual-networks-existing"
  for_each = { for key, value in var.virtual_networks : key => value
    if try(value.existing, false) && try(value.remote, false) && !try(value.remote2, false) && !try(value.remote3, false)
  }

  name                = each.key
  resource_group_name = try(each.value.resource_group_name, module.resource_group[each.value.resource_group_name].name, module.resource_group_existing[each.value.resource_group_name].name, module.resource_group_existing_remote[each.value.resource_group_name].name, module.resource_group_existing_remote2[each.value.resource_group_name].name, module.resource_group_existing_remote3[each.value.resource_group_name].name)

  providers = {
    azurerm = azurerm.remote
  }
}

module "virtual_network_existing_remote2" {
  depends_on = [module.resource_group]
  source     = "./modules/network/virtual-networks/virtual-networks-existing"
  for_each = { for key, value in var.virtual_networks : key => value
    if try(value.existing, false) && try(value.remote2, false) && !try(value.remote3, false)
  }

  name                = each.key
  resource_group_name = try(each.value.resource_group_name, module.resource_group[each.value.resource_group_name].name, module.resource_group_existing[each.value.resource_group_name].name, module.resource_group_existing_remote[each.value.resource_group_name].name, module.resource_group_existing_remote2[each.value.resource_group_name].name, module.resource_group_existing_remote3[each.value.resource_group_name].name)

  providers = {
    azurerm = azurerm.remote2
  }
}

module "virtual_network_existing_remote3" {
  depends_on = [module.resource_group]
  source     = "./modules/network/virtual-networks/virtual-networks-existing"
  for_each = { for key, value in var.virtual_networks : key => value
    if try(value.existing, false) && try(value.remote3, false)
  }

  name                = each.key
  resource_group_name = try(each.value.resource_group_name, module.resource_group[each.value.resource_group_name].name, module.resource_group_existing[each.value.resource_group_name].name, module.resource_group_existing_remote[each.value.resource_group_name].name, module.resource_group_existing_remote2[each.value.resource_group_name].name, module.resource_group_existing_remote3[each.value.resource_group_name].name)

  providers = {
    azurerm = azurerm.remote3
  }
}

/**************************************************************************
********************* Subnet Creation *************************************
**************************************************************************/

module "virtual_subnets" {
  depends_on = [module.resource_group, module.virtual_network]
  source     = "./modules/network/subnets/subnets-create"
  for_each = merge([for vnet_key, vnet_value in var.virtual_networks : {
    for subnet_key, subnet_value in vnet_value.subnets : "${subnet_key}" => merge(
      subnet_value, {
        vnet_name = vnet_key, resource_group_name = vnet_value.resource_group_name, virtual_network_name = vnet_key
      }
    )
  }]...)

  name                                      = each.key
  resource_group_name                       = each.value.resource_group_name
  virtual_network_name                      = each.value.virtual_network_name
  address_prefixes                          = each.value.address_prefixes
  private_endpoint_network_policies_enabled = lookup(each.value, "private_endpoint", false)
  service_endpoints                         = lookup(each.value, "service_endpoints", ["Microsoft.Storage", "Microsoft.KeyVault"])
  delegations                               = lookup(each.value, "delegations", [])
}

module "subnets" {
  depends_on = [module.module.virtual_network]
  source     = "./modules/network/subnets/subnets-create"
  for_each = { for key, value in var.subnets : key => value
    if var.subnets != {} && !try(value.existing, false) && !try(value.remote, false) && !try(value.remote2, false) && !try(value.remote3, false)
  }

  name                                      = each.key
  resource_group_name                       = try(each.value.resource_group_name, module.resource_group[each.value.resource_group_name].name, module.resource_group_existing[each.value.resource_group_name].name)
  virtual_network_name                      = try(each.value.virtual_network_name, module.virtual_network[each.value.vnet].name, module.virtual_network_existing[each.value.vnet].name)
  address_prefixes                          = each.value.address_prefixes
  private_endpoint_network_policies_enabled = lookup(each.value, "private_endpoint", false)
  service_endpoints                         = lookup(each.value, "service_endpoints", ["Microsoft.Storage", "Microsoft.KeyVault"])
  delegations                               = lookup(each.value, "delegations", [])
}

/**************************************************************************
********************* Subnet Existing *************************************
**************************************************************************/

module "subnets_existing" {
  depends_on = [module.resource_group, module.virtual_network]
  source     = "./modules/network/subnets/subnets-existing"
  for_each = { for key, value in var.subnets : key => value
    if var.subnets != {} && try(value.existing, false) && !try(value.remote, false) && !try(value.remote2, false) && !try(value.remote3, false)
  }

  name                 = each.key
  resource_group_name  = try(each.value.resource_group_name, module.resource_group[each.value.resource_group_name].name, module.resource_group_existing[each.value.resource_group_name].name)
  virtual_network_name = try(each.value.virtual_network_name, module.virtual_network[each.value.vnet].name, module.virtual_network_existing[each.value.vnet].name)
}

module "subnets_existing_remote" {
  depends_on = [module.resource_group, module.virtual_network]
  source     = "./modules/network/subnets/subnets-existing"
  for_each = { for key, value in var.subnets : key => value
    if var.subnets != {} && try(value.existing, false) && try(value.remote, false) && !try(value.remote2, false) && !try(value.remote3, false)
  }

  name                 = each.key
  resource_group_name  = try(each.value.resource_group_name, module.resource_group[each.value.resource_group_name].name, module.resource_group_existing[each.value.resource_group_name].name)
  virtual_network_name = try(each.value.virtual_network_name, module.virtual_network[each.value.vnet].name, module.virtual_network_existing[each.value.vnet].name)

  providers = {
    azurerm = azurerm.remote
  }
}

module "subnets_existing_remote2" {
  depends_on = [module.resource_group, module.virtual_network]
  source     = "./modules/network/subnets/subnets-existing"
  for_each = { for key, value in var.subnets : key => value
    if var.subnets != {} && try(value.existing, false) && !try(value.remote, false) && try(value.remote2, false) && !try(value.remote3, false)
  }

  name                 = each.key
  resource_group_name  = try(each.value.resource_group_name, module.resource_group[each.value.resource_group_name].name, module.resource_group_existing[each.value.resource_group_name].name)
  virtual_network_name = try(each.value.virtual_network_name, module.virtual_network[each.value.vnet].name, module.virtual_network_existing[each.value.vnet].name)

  providers = {
    azurerm = azurerm.remote2
  }
}

module "subnets_existing_remote3" {
  depends_on = [module.resource_group, module.virtual_network]
  source     = "./modules/network/subnets/subnets-existing"
  for_each = { for key, value in var.subnets : key => value
    if var.subnets != {} && try(value.existing, false) && !try(value.remote, false) && !try(value.remote2, false) && try(value.remote3, false)
  }

  name                 = each.key
  resource_group_name  = try(each.value.resource_group_name, module.resource_group[each.value.resource_group_name].name, module.resource_group_existing[each.value.resource_group_name].name)
  virtual_network_name = try(each.value.virtual_network_name, module.virtual_network[each.value.vnet].name, module.virtual_network_existing[each.value.vnet].name)

  providers = {
    azurerm = azurerm.remote3
  }
}

locals {
  virtual_networks         = merge(module.virtual_network, module.virtual_network_existing, module.virtual_network_existing_remote, module.virtual_network_existing_remote2, module.virtual_network_existing_remote3)
  subnets                  = merge(module.subnets_existing, module.subnets, module.subnets_existing_remote, module.subnets_existing_remote2, module.subnets_existing_remote3, module.subnets)
  virtual_network_peerings = merge(module.virtual_network_peering, module.virtual_network_peering_remote, module.virtual_network_peering_remote2, module.virtual_network_peering_remote3)
}

output "virtual_networks" {
  value = local.virtual_networks
}

output "subnets" {
  value = local.subnets
}

output "virtual_network_peerings" {
  value = local.virtual_network_peerings
}