#### Data Blocks for NIC Subnets ####

data "azurerm_subnet" "subnet" {
  for_each             = var.nics
  name                 = each.value.subnet_name
  virtual_network_name = var.vnet
  resource_group_name  = var.vnet_rg
}

#### Resource Blocks for NICs ####

resource "azurerm_network_interface" "network_interface" {
  for_each            = var.nics
  name                = "${var.name}-${each.key}"
  resource_group_name = var.resource_group_name
  location            = var.location

  ip_configuration {
    name                          = "${each.key}-ipconfig"
    subnet_id                     = data.azurerm_subnet.subnet[each.key].id
    private_ip_address_allocation = lookup(each.value, "private_ip_address_allocation", null)
    private_ip_address            = lookup(each.value, "private_ip_address", null)
    public_ip_address_id          = lookup(each.value, "public_ip_address", null)
  }

  tags = var.tags
}

#### Windows VM Creation ####

resource "azurerm_windows_virtual_machine" "windows_vm" {
  name                = var.name
  computer_name       = var.computer_name
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  zone                = var.zone
  boot_diagnostics {
    storage_account_uri = var.boot_diagnostics_enabled ? var.boot_diagnostics_storage_uri : null
  }

  encryption_at_host_enabled = var.encryption_at_host_enabled
  license_type               = var.license_type # None, Windows_Client, Windows_Server
  secure_boot_enabled        = var.secure_boot_enabled
  vtpm_enabled               = var.vtpm_enabled

  network_interface_ids = values(azurerm_network_interface.network_interface)[*].id

  os_disk {
    name                             = "${lower(var.name)}_os"
    caching                          = try(var.os_disk.caching, "ReadWrite")
    storage_account_type             = try(var.os_disk.storage_account_type, "Standard_LRS")
    disk_size_gb                     = try(var.os_disk.disk_size_gb, 128)
    disk_encryption_set_id           = try(var.os_disk.disk_encryption_set_id, null)
    secure_vm_disk_encryption_set_id = try(var.os_disk.secure_vm_disk_encryption_set_id, null)
    write_accelerator_enabled        = try(var.os_disk.write_accelerator_enabled, false)
  }

  source_image_reference {
    publisher = var.image_reference.publisher
    offer     = var.image_reference.offer
    sku       = var.image_reference.sku
    version   = var.image_reference.version
  }

  availability_set_id = var.availability_set_id

  tags = var.tags
}

#### Managed Disk Creation ####

resource "azurerm_managed_disk" "data_disk" {
  depends_on = [azurerm_windows_virtual_machine.windows_vm]
  count      = length(var.data_disks)

  name                          = "${lower(var.name)}_data${count.index}"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  storage_account_type          = try(var.data_disks[count.index].storage_account_type, "Standard_LRS")
  disk_size_gb                  = try(var.data_disks[count.index].disk_size_gb, 128)
  zone                          = var.zone
  public_network_access_enabled = try(var.data_disks[count.index].public_network_access_enabled, false)
  create_option                 = try(var.data_disks[count.index].create_option, "Empty")

  tags = var.tags
}

resource "azurerm_virtual_machine_data_disk_attachment" "data_disk" {
  count = length(var.data_disks)

  managed_disk_id           = azurerm_managed_disk.data_disk[count.index].id
  virtual_machine_id        = azurerm_windows_virtual_machine.windows_vm.id
  lun                       = try(var.data_disks[count.index].lun, count.index)
  caching                   = try(var.data_disks[count.index].caching, "ReadWrite")
  write_accelerator_enabled = try(var.data_disks[count.index].write_accelerator_enabled, false)
}

/**************************************************************************
******************** NIC Diagnostics Creation *****************************
**************************************************************************/

module "windows_vm_nics_diagnostics" {
  depends_on = [azurerm_network_interface.network_interface]
  source     = "../../../diagnostics-settings"
  for_each   = var.nics

  name                           = "${var.name}-${each.key}-diagnostics"
  target_resource_id             = azurerm_network_interface.network_interface[each.key].id
  log_analytics_workspace_id     = try(var.log_analytics_id, null)
  log_analytics_destination_type = lookup(each.value, "log_analytics_destination_type", "Dedicated")
  storage_account_id             = try(var.storage_account_id, null)
  eventhub_name                  = try(var.eventhub_name, null)
  eventhub_authorization_rule_id = try(var.eventhub_authorization_rule_id, null)
  partner_solution_id            = try(var.partner_solution_id, null)
}

/**************************************************************************
************************** VM Extensions **********************************
**************************************************************************/

resource "azurerm_virtual_machine_extension" "DomainJoin" {
  count                      = contains(var.extensions, "DomainJoin") ? 1 : 0
  name                       = "DomainJoin"
  virtual_machine_id         = azurerm_windows_virtual_machine.windows_vm.id
  publisher                  = "Microsoft.Compute"
  type                       = "JsonADDomainExtension"
  type_handler_version       = "1.3"
  auto_upgrade_minor_version = true
  settings                   = <<SETTINGS
    {
        "Name": "${var.domain_name}",
        "OUPath": "${var.ou_path}",
        "User": "${var.domain_user}",
        "Restart": "true",
        "Options": "3",
        "Domain": "${var.domain_name}",
        "JoinOption": "0"
    }
  SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
    {
        "Password": "${var.domain_password}"
    }
  PROTECTED_SETTINGS
  lifecycle {
    ignore_changes = [
      virtual_machine_id
    ]
  }
}

resource "azurerm_virtual_machine_extension" "AzureNetworkWatcherExtension" {
  count                      = contains(var.extensions, "AzureNetworkWatcherExtension") ? 1 : 0
  name                       = "AzureNetworkWatcherExtension"
  virtual_machine_id         = azurerm_windows_virtual_machine.windows_vm.id
  publisher                  = "Microsoft.Azure.NetworkWatcher"
  type                       = "NetworkWatcherAgentWindows"
  type_handler_version       = "1.4"
  auto_upgrade_minor_version = true
  lifecycle {
    ignore_changes = [
      virtual_machine_id
    ]
  }
}

resource "azurerm_virtual_machine_extension" "DependencyAgentWindows" {
  count                      = contains(var.extensions, "DependencyAgentWindows") ? 1 : 0
  name                       = "DependencyAgentWindows"
  virtual_machine_id         = azurerm_windows_virtual_machine.windows_vm.id
  publisher                  = "Microsoft.Azure.Monitoring.DependencyAgent"
  type                       = "DependencyAgentWindows"
  type_handler_version       = "9.10"
  auto_upgrade_minor_version = true
  lifecycle {
    ignore_changes = [
      virtual_machine_id
    ]
  }
}

resource "azurerm_virtual_machine_extension" "AzureMonitorWindowsAgent" {
  count                      = contains(var.extensions, "AzureMonitorWindowsAgent") ? 1 : 0
  name                       = "AzureMonitorWindowsAgent"
  virtual_machine_id         = azurerm_windows_virtual_machine.windows_vm.id
  publisher                  = "Microsoft.Azure.Monitor"
  type                       = "AzureMonitorWindowsAgent"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = true
  lifecycle {
    ignore_changes = [
      virtual_machine_id
    ]
  }
}