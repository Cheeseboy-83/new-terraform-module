variable "name" {
  description = "The name of the private endpoint"
  type        = string
}

variable "location" {
  description = "The location/region where the private endpoint will be created"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the private endpoint"
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet in which to create the private endpoint"
  type        = string
}

variable "private_dns_zone_ids" {
  description = "The ID of the private DNS zone to which the private endpoint will be connected"
  type        = list(string)
}

variable "private_connection_resource_id" {
  description = "The ID of the resource to which the private endpoint will be connected"
  type        = string
}

variable "subresource_names" {
  description = "The subresource names to which the private endpoint will be connected"
  type        = list(string)
}

variable "tags" {
  description = "The tags to associate with the private endpoint"
  type        = map(string)
}