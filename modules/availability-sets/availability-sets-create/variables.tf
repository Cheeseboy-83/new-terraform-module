variable "name" {
  description = "The name of the availability set"
  type        = string
}

variable "location" {
  description = "The location of the availability set"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the availability set"
  type        = string
}

variable "platform_fault_domain_count" {
  description = "The number of fault domains that the availability set can span"
  type        = number
  default     = 3
}

variable "platform_update_domain_count" {
  description = "The number of update domains that the availability set can span"
  type        = number
  default     = 5
}

variable "managed" {
  description = "Is the availability set managed?"
  type        = bool
  default     = true
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(any)
  default     = {}
}