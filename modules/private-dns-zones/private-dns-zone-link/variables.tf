variable "name" {
  description = "The name of the private DNS zone"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the private DNS zone link"
  type        = string
}

variable "private_dns_zone_name" {
  description = "The name of the private DNS zone to which the link will be created"
  type        = string
}

variable "virtual_network_id" {
  description = "The ID of the virtual network to which the link will be created"
  type        = string
}