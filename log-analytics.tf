/**************************************************************************
******************** Log Analytics Creation *******************************
**************************************************************************/

module "log_analytics" {
  depends_on = [module.resource_group]
  source     = "./modules/log-analytics/log-analytics-create"
  for_each = { for key, value in var.log_analytics : key => value
    if try(value.existing, false) == false
  }

  name                       = each.key
  resource_group_name        = try(each.value.resource_group_name, module.resource_group[each.value.resource_group_name].name, module.resource_group_existing[each.value.resource_group_name].name)
  location                   = try(var.global_settings.location, module.resource_group[each.value.resource_group_name].location, module.resource_group_existing[each.value.resource_group_name].location, each.value.location)
  sku                        = lookup(each.value, "sku", "PerGB2018")
  retention_in_days          = lookup(each.value, "retention_in_days", 30)
  daily_quota_gb             = lookup(each.value, "daily_quota_gb", -1)
  internet_ingestion_enabled = lookup(each.value, "internet_ingestion_enabled", false)
  internet_query_enabled     = lookup(each.value, "internet_query_enabled", false)

  tags = merge(try(each.value.tags, {}), var.global_settings.tags)
}

/**************************************************************************
******************** Log Analytics Existing *******************************
**************************************************************************/

module "log_analytics_existing" {
  depends_on = [module.resource_group]
  source     = "./modules/log-analytics/log-analytics-existing"
  for_each = { for key, value in var.log_analytics : key => value
    if try(value.existing, false) && !try(value.remote, false) && !try(value.remote2, false) && !try(value.remote3, false)
  }

  name                = each.key
  resource_group_name = try(each.value.resource_group_name, module.resource_group[each.value.resource_group_name].name, module.resource_group_existing[each.value.resource_group_name].name, module.resource_group_existing_remote[each.value.resource_group_name].name, module.resource_group_existing_remote2[each.value.resource_group_name].name, module.resource_group_existing_remote3[each.value.resource_group_name].name)
}

module "log_analytics_existing_remote" {
  depends_on = [module.resource_group]
  source     = "./modules/log-analytics/log-analytics-existing"
  for_each = { for key, value in var.log_analytics : key => value
    if try(value.existing, false) && try(value.remote, false) && !try(value.remote2, false) && !try(value.remote3, false)
  }

  name                = each.key
  resource_group_name = try(each.value.resource_group_name, module.resource_group[each.value.resource_group_name].name, module.resource_group_existing[each.value.resource_group_name].name, module.resource_group_existing_remote[each.value.resource_group_name].name, module.resource_group_existing_remote2[each.value.resource_group_name].name, module.resource_group_existing_remote3[each.value.resource_group_name].name)

  providers = {
    azurerm = azurerm.remote
  }
}

module "log_analytics_existing_remote2" {
  depends_on = [module.resource_group]
  source     = "./modules/log-analytics/log-analytics-existing"
  for_each = { for key, value in var.log_analytics : key => value
    if try(value.existing, false) && !try(value.remote, false) && try(value.remote2, false) && !try(value.remote3, false)
  }

  name                = each.key
  resource_group_name = try(each.value.resource_group_name, module.resource_group[each.value.resource_group_name].name, module.resource_group_existing[each.value.resource_group_name].name, module.resource_group_existing_remote[each.value.resource_group_name].name, module.resource_group_existing_remote2[each.value.resource_group_name].name, module.resource_group_existing_remote3[each.value.resource_group_name].name)

  providers = {
    azurerm = azurerm.remote2
  }
}

module "log_analytics_existing_remote3" {
  depends_on = [module.resource_group]
  source     = "./modules/log-analytics/log-analytics-existing"
  for_each = { for key, value in var.log_analytics : key => value
    if try(value.existing, false) && !try(value.remote, false) && !try(value.remote2, false) && try(value.remote3, false)
  }

  name                = each.key
  resource_group_name = try(each.value.resource_group_name, module.resource_group[each.value.resource_group_name].name, module.resource_group_existing[each.value.resource_group_name].name, module.resource_group_existing_remote[each.value.resource_group_name].name, module.resource_group_existing_remote2[each.value.resource_group_name].name, module.resource_group_existing_remote3[each.value.resource_group_name].name)

  providers = {
    azurerm = azurerm.remote3
  }
}

locals {
  log_analytics = merge(module.log_analytics, module.log_analytics_existing, module.log_analytics_existing_remote, module.log_analytics_existing_remote2, module.log_analytics_existing_remote3)
}

output "log_analytics" {
  value = local.log_analytics
}