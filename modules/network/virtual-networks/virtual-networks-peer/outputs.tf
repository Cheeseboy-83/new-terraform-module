output "name" {
  description = "The name of the virtual network peering"
  value       = azurerm_virtual_network_peering.vnet_peer.name
}

output "resource_group_name" {
  description = "The name of the resource group in which to create the virtual network peering"
  value       = azurerm_virtual_network_peering.vnet_peer.resource_group_name
}

output "virtual_network_name" {
  description = "The name of the virtual network in which to create the virtual network peering"
  value       = azurerm_virtual_network_peering.vnet_peer.virtual_network_name
}

output "remote_virtual_network_id" {
  description = "The ID of the remote virtual network to peer with"
  value       = azurerm_virtual_network_peering.vnet_peer.remote_virtual_network_id
}

output "allow_virtual_network_access" {
  description = "Controls if the VMs in the remote virtual network can access VMs in the local virtual network"
  value       = azurerm_virtual_network_peering.vnet_peer.allow_virtual_network_access
}

output "allow_forwarded_traffic" {
  description = "Controls if forwarded traffic from VMs in the remote virtual network is allowed"
  value       = azurerm_virtual_network_peering.vnet_peer.allow_forwarded_traffic
}

output "use_remote_gateways" {
  description = "Controls if remote gateways can be used on the local virtual network"
  value       = azurerm_virtual_network_peering.vnet_peer.use_remote_gateways
}

output "id" {
  description = "The ID of the virtual network peering"
  value       = azurerm_virtual_network_peering.vnet_peer.id
}