/**************************************************************************
********************* Windows VMs Creation ********************************
**************************************************************************/

module "windows_vm" {
  depends_on = [module.resource_group]
  source     = "./modules/compute/windows-vms/windows-vms-create"
  for_each = { for key, value in var.windows_vms : key => value
    if !try(value.existing, false) && !try(value.remote, false) && !try(value.remote2, false) && !try(value.remote3, false)
  }

  name                         = each.key
  computer_name                = lookup(each.value, "computer_name", lower(each.key))
  resource_group_name          = try(each.value.resource_group_name, module.resource_group[each.value.resource_group_name].name, module.resource_group_existing[each.value.resource_group_name].name)
  location                     = try(var.global_settings.location, module.resource_group[each.value.resource_group_name].location, module.resource_group_existing[each.value.resource_group_name].location, each.value.location)
  size                         = each.value.size
  admin_username               = var.admin_username
  admin_password               = var.admin_password
  zone                         = try(each.value.zone, null)
  encryption_at_host_enabled   = lookup(each.value, "encryption_at_host_enabled", false)
  license_type                 = lookup(each.value, "license_type", "None")
  secure_boot_enabled          = lookup(each.value, "secure_boot_enabled", false)
  vtpm_enabled                 = lookup(each.value, "vtpm_enabled", false)
  boot_diagnostics_enabled     = lookup(each.value.boot_diagnostics, "enabled", false)
  boot_diagnostics_storage_uri = lookup(each.value.boot_diagnostics, "storage_uri", try(module.storage_account[each.value.boot_diagnostics.storage_account_name].primary_blob_endpoint, module.storage_account_existing[each.value.boot_diagnostics.storage_account_name].primary_blob_endpoint, module.storage_account_existing_remote[each.value.boot_diagnostics.storage_account_name].primary_blob_endpoint, module.storage_account_existing_remote2[each.value.boot_diagnostics.storage_account_name].primary_blob_endpoint, module.storage_account_existing_remote3[each.value.boot_diagnostics.storage_account_name].primary_blob_endpoint, null))

  os_disk    = each.value.os_disk
  data_disks = try(each.value.data_disks, [])

  image_reference = lookup(each.value, "image_reference", {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  })

  availability_set_id = try(each.value.availability_set_id, module.availability_set[each.value.availability_set_id].id, module.availability_set_existing[each.value.availability_set_id].id, module.availability_set_existing_remote[each.value.availability_set_id].id, module.availability_set_existing_remote2[each.value.availability_set_id].id, module.availability_set_existing_remote3[each.value.availability_set_id].id, null)

  vnet                        = each.value.vnet
  vnet_rg                     = each.value.vnet_rg
  nics                        = lookup(each.value, "nics", {})
  log_analytics_id            = try(each.value.log_analytics_id, module.log_analytics[each.value.log_analytics_name].id, module.log_analytics_existing[each.value.log_analytics_name].id, module.log_analytics_existing_remote[each.value.log_analytics_name].id, module.log_analytics_existing_remote2[each.value.log_analytics_name].id, module.log_analytics_existing_remote3[each.value.log_analytics_name].id, null)
  log_analytics_workspace_id  = try(each.value.log_analytics_workspace_id, module.log_analytics[each.value.log_analytics_name].workspace_id, module.log_analytics_existing[each.value.log_analytics_name].workspace_id, module.log_analytics_existing_remote[each.value.log_analytics_name].workspace_id, module.log_analytics_existing_remote2[each.value.log_analytics_name].workspace_id, module.log_analytics_existing_remote3[each.value.log_analytics_name].workspace_id, null)
  log_analytics_workspace_key = try(each.value.log_analytics_workspace_key, module.log_analytics[each.value.log_analytics_name].primary_shared_key, module.log_analytics_existing[each.value.log_analytics_name].primary_shared_key, module.log_analytics_existing_remote[each.value.log_analytics_name].primary_shared_key, module.log_analytics_existing_remote2[each.value.log_analytics_name], module.log_analytics_existing_remote3[each.value.log_analytics_name].primary_shared_key, null)


  tags = merge(try(each.value.tags, {}), var.global_settings.tags)

  extensions = try(each.value.extensions, [])

  domain_name     = try(each.value.domain_name, null)
  ou_path         = try(each.value.ou_path, null)
  domain_user     = var.domain_user
  domain_password = var.domain_password
}

/**************************************************************************
********************* Diagnostics Creation ********************************
**************************************************************************/

module "windows_vm_diagnostics" {
  depends_on = [module.windows_vm]
  source     = "./modules/diagnostics-settings"
  for_each = { for key, value in var.windows_vms : key => value
    if try(value.diagnostics, false) == true
  }

  name                           = "${each.key}-diagnostics"
  target_resource_id             = module.windows_vm[each.key].id
  log_analytics_workspace_id     = try(each.value.log_analytics_id, module.log_analytics[each.value.log_analytics_name].id, module.log_analytics_existing[each.value.log_analytics_name].id, module.log_analytics_existing_remote[each.value.log_analytics_name].id, module.log_analytics_existing_remote2[each.value.log_analytics_name], module.log_analytics_existing_remote3[each.value.log_analytics_name].id, null)
  log_analytics_destination_type = lookup(each.value, "log_analytics_destination_type", "Dedicated")
  storage_account_id             = try(each.value.storage_account_id, module.storage_account[each.value.storage_account_name].id, module.storage_account_existing[each.value.storage_account_name].id, module.storage_account_existing_remote[each.value.storage_account_name].id, module.storage_account_existing_remote2[each.value.storage_account_name].id, module.storage_account_existing_remote3[each.value.storage_account_name].id, null)
  eventhub_name                  = try(each.value.eventhub_name, /*module.eventhub[each.value.event_hub_name].name, module.eventhub_existing[each.value.event_hub_name].name,*/ null)
  eventhub_authorization_rule_id = try(each.value.eventhub_authorization_rule_id, /*module.eventhub[each.value.event_hub_name].authorization_rule_id, module.eventhub_existing[each.value.event_hub_name].authorization_rule_id,*/ null)
  partner_solution_id            = try(each.value.partner_solution_id, null)
}

/**************************************************************************
*********************** Linux VMs Creation ********************************
**************************************************************************/

module "linux_vm" {
  depends_on = [module.resource_group]
  source     = "./modules/compute/linux-vms/linux-vms-create"
  for_each = { for key, value in var.linux_vms : key => value
    if !try(value.existing, false) && !try(value.remote, false) && !try(value.remote2, false) && !try(value.remote3, false)
  }

  name                            = each.key
  computer_name                   = lookup(each.value, "computer_name", lower(each.key))
  resource_group_name             = try(each.value.resource_group_name, module.resource_group[each.value.resource_group_name].name, module.resource_group_existing[each.value.resource_group_name].name)
  location                        = try(var.global_settings.location, module.resource_group[each.value.resource_group_name].location, module.resource_group_existing[each.value.resource_group_name].location, each.value.location)
  size                            = each.value.size
  admin_username                  = var.admin_username
  disable_password_authentication = lookup(each.value, "disable_password_authentication", true)
  admin_ssh_key                   = var.admin_ssh_key
  zone                            = try(each.value.zone, null)
  encryption_at_host_enabled      = lookup(each.value, "encryption_at_host_enabled", false)
  license_type                    = lookup(each.value, "license_type", null)
  secure_boot_enabled             = lookup(each.value, "secure_boot_enabled", false)
  vtpm_enabled                    = lookup(each.value, "vtpm_enabled", false)
  boot_diagnostics_enabled        = lookup(each.value.boot_diagnostics, "enabled", false)
  boot_diagnostics_storage_uri    = lookup(each.value.boot_diagnostics, "storage_uri", try(module.storage_account[each.value.boot_diagnostics.storage_account_name].primary_blob_endpoint, module.storage_account_existing[each.value.boot_diagnostics.storage_account_name].primary_blob_endpoint, module.storage_account_existing_remote[each.value.boot_diagnostics.storage_account_name].primary_blob_endpoint, module.storage_account_existing_remote2[each.value.boot_diagnostics.storage_account_name].primary_blob_endpoint, module.storage_account_existing_remote3[each.value.boot_diagnostics.storage_account_name].primary_blob_endpoint, null))

  os_disk    = each.value.os_disk
  data_disks = try(each.value.data_disks, [])

  image_reference = lookup(each.value, "image_reference", {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  })

  availability_set_id = try(each.value.availability_set_id, module.availability_set[each.value.availability_set_id].id, module.availability_set_existing[each.value.availability_set_id].id, module.availability_set_existing_remote[each.value.availability_set_id].id, module.availability_set_existing_remote2[each.value.availability_set_id].id, module.availability_set_existing_remote3[each.value.availability_set_id].id, null)

  vnet                        = each.value.vnet
  vnet_rg                     = each.value.vnet_rg
  nics                        = lookup(each.value, "nics", {})
  log_analytics_id            = try(each.value.log_analytics_id, module.log_analytics[each.value.log_analytics_name].id, module.log_analytics_existing[each.value.log_analytics_name].id, module.log_analytics_existing_remote[each.value.log_analytics_name].id, module.log_analytics_existing_remote2[each.value.log_analytics_name].id, module.log_analytics_existing_remote3[each.value.log_analytics_name].id, null)
  log_analytics_workspace_id  = try(each.value.log_analytics_workspace_id, module.log_analytics[each.value.log_analytics_name].workspace_id, module.log_analytics_existing[each.value.log_analytics_name].workspace_id, module.log_analytics_existing_remote[each.value.log_analytics_name].workspace_id, module.log_analytics_existing_remote2[each.value.log_analytics_name].workspace_id, module.log_analytics_existing_remote3[each.value.log_analytics_name].workspace_id, null)
  log_analytics_workspace_key = try(each.value.log_analytics_workspace_key, module.log_analytics[each.value.log_analytics_name].primary_shared_key, module.log_analytics_existing[each.value.log_analytics_name].primary_shared_key, module.log_analytics_existing_remote[each.value.log_analytics_name].primary_shared_key, module.log_analytics_existing_remote2[each.value.log_analytics_name], module.log_analytics_existing_remote3[each.value.log_analytics_name].primary_shared_key, null)


  tags = merge(try(each.value.tags, {}), var.global_settings.tags)

  extensions = try(each.value.extensions, [])
}

/**************************************************************************
********************* Diagnostics Creation ********************************
**************************************************************************/

module "linux_vm_diagnostics" {
  depends_on = [module.linux_vm]
  source     = "./modules/diagnostics-settings"
  for_each = { for key, value in var.linux_vms : key => value
    if try(value.diagnostics, false) == true
  }

  name                           = "${each.key}-diagnostics"
  target_resource_id             = module.linux_vm[each.key].id
  log_analytics_workspace_id     = try(each.value.log_analytics_id, module.log_analytics[each.value.log_analytics_name].id, module.log_analytics_existing[each.value.log_analytics_name].id, module.log_analytics_existing_remote[each.value.log_analytics_name].id, module.log_analytics_existing_remote2[each.value.log_analytics_name], module.log_analytics_existing_remote3[each.value.log_analytics_name].id, null)
  log_analytics_destination_type = lookup(each.value, "log_analytics_destination_type", "Dedicated")
  storage_account_id             = try(each.value.storage_account_id, module.storage_account[each.value.storage_account_name].id, module.storage_account_existing[each.value.storage_account_name].id, module.storage_account_existing_remote[each.value.storage_account_name].id, module.storage_account_existing_remote2[each.value.storage_account_name].id, module.storage_account_existing_remote3[each.value.storage_account_name].id, null)
  eventhub_name                  = try(each.value.eventhub_name, /*module.eventhub[each.value.event_hub_name].name, module.eventhub_existing[each.value.event_hub_name].name,*/ null)
  eventhub_authorization_rule_id = try(each.value.eventhub_authorization_rule_id, /*module.eventhub[each.value.event_hub_name].authorization_rule_id, module.eventhub_existing[each.value.event_hub_name].authorization_rule_id,*/ null)
  partner_solution_id            = try(each.value.partner_solution_id, null)
}