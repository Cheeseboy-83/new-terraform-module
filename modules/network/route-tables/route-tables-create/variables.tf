variable "subnet_name" {
  description = "The name of the subnet to associate with the route table."
  type        = string
}

variable "virtual_network_name" {
  description = "The name of the virtual network to associate with the route table."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the route table."
  type        = string
}

variable "name" {
  description = "The name of the route table."
  type        = string
}

variable "location" {
  description = "The Azure Region in which to create the route table."
  type        = string
}

variable "disable_bgp_route_propagation" {
  description = "Should BGP route propagation be disabled?"
  type        = bool
  default     = false
}

variable "routes" {
  description = "A list of routes to associate with the route table."
  default     = []
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}