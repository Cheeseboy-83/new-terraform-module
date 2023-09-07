resource "azurerm_subnet" "subnet" {
  name                                      = var.name
  resource_group_name                       = var.resource_group_name
  virtual_network_name                      = var.virtual_network_name
  address_prefixes                          = var.address_prefixes
  private_endpoint_network_policies_enabled = var.private_endpoint_network_policies_enabled
  service_endpoints                         = var.service_endpoints

  dynamic "delegation" {
    for_each = var.delegations != null ? var.delegations : []
    content {
      name = delegation.value.delegation_name

      service_delegation {
        name    = delegation.value.delegation_service_name
        actions = delegation.value.delegation_service_actions
      }
    }
  }
}