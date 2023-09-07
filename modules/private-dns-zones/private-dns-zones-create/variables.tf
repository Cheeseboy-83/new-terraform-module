variable "name" {
  description = "The name of the private DNS zone"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the private DNS zone"
  type        = string
}