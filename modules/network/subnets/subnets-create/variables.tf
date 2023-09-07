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

variable "address_prefixes" {
  description = "The address prefixes to use for the subnet"
  type        = list(string)
}

variable "private_endpoint_network_policies_enabled" {
  description = "Whether network policies are enabled for the private endpoint in the subnet"
  type        = bool
  default     = false
}

variable "service_endpoints" {
  description = "The service endpoints to associate with the subnet"
  type        = list(string)
  default     = []
}

variable "delegations" {
  description = "The delegations to associate with the subnet"
  type = list(object({
    delegation_name            = string
    delegation_service_name    = string
    delegation_service_actions = list(string)
  }))
  default = []
}