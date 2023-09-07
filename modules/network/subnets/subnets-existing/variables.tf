variable "name" {
  description = "The name of the subnet to be deployed"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the subnet"
  type        = string
}

variable "virtual_network_name" {
  description = "The name of the virtual network in which to create the subnet"
  type        = string
}