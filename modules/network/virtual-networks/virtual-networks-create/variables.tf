variable "name" {
  description = "The name of the virtual network"
  type        = string
}

variable "location" {
  description = "The location where the virtual network is created"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the virtual network"
  type        = string
}

variable "address_space" {
  description = "The address space that is used the virtual network"
  type        = list(string)
}

variable "dns_servers" {
  description = "The DNS servers that are used the virtual network"
  type        = list(string)
  default     = null
}

variable "ddos_protection_plan_id" {
  description = "The ID of the DDoS protection plan that is used the virtual network"
  type        = string
  default     = null
}

variable "subnets" {
  description = "The subnets that are used the virtual network"
  default     = {}
}

variable "tags" {
  description = "(Optional) The tags to associate with the virtual network"
  type        = map(string)
  default     = null
}