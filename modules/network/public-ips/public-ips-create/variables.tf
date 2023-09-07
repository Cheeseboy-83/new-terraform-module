variable "name" {
  description = "The name of the public IP address."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the public IP address."
  type        = string
}

variable "location" {
  description = "The Azure location where the public IP address should exist."
  type        = string
}

variable "allocation_method" {
  description = "Defines the allocation method for this IP address. Possible values are Static or Dynamic."
  type        = string
}

variable "zones" {
  description = "A list of Availability Zones which should be used for this Public IP Address."
  type        = list(string)
}

variable "domain_name_label" {
  description = "The Domain Name Label. Must be a valid DNS label and be unique in the region."
  type        = string
}

variable "sku" {
  description = "The SKU of the Public IP. Accepted values are Basic and Standard."
  type        = string
}

variable "sku_tier" {
  description = "The Tier of the SKU of the Public IP. This is only used for Standard SKU."
  type        = string
}

variable "ddos_protection_mode" {
  description = "The DDoS protection mode. Only Standard is supported."
  type        = string
}

variable "ddos_protection_plan_id" {
  description = "The ID of the DDoS protection plan which the Public IP Address should be associated with."
  type        = string
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
}