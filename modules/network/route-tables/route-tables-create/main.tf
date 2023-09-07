data "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  virtual_network_name = var.virtual_network_name
  resource_group_name  = var.resource_group_name
}

resource "azurerm_route_table" "route_table" {
  name                          = var.name
  location                      = var.location
  resource_group_name           = var.resource_group_name
  disable_bgp_route_propagation = var.disable_bgp_route_propagation

  dynamic "route" {
    for_each = var.routes
    content {
      name                   = try(route.value.name, null)
      address_prefix         = try(route.value.address_prefix, null)
      next_hop_type          = try(route.value.next_hop_type, null)
      next_hop_in_ip_address = try(route.value.next_hop_in_ip_address, null)
    }
  }

  tags = var.tags
}

resource "azurerm_subnet_route_table_association" "rt_association" {
  subnet_id      = data.azurerm_subnet.subnet.id
  route_table_id = azurerm_route_table.route_table.id
}