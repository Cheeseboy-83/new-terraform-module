variable "subnet_name" {
  description = "The name of the subnet to associate with the network security group."
  type        = string
}

variable "virtual_network_name" {
  description = "The name of the virtual network to associate with the network security group."
  type        = string
}

variable "name" {
  description = "The name of the network security group."
  type        = string
}

variable "location" {
  description = "The location/region where the network security group is created. Changing this forces a new resource to be created."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the network security group. Changing this forces a new resource to be created."
  type        = string
}

variable "rules" {
  description = "A list of security rules associated with the network security group."
  default     = []
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(any)
  default     = {}
}