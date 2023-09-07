variable "name" {
  description = "The name of the resource group in which to create the DDoS protection plan"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the DDoS protection plan"
  type        = string
}

variable "location" {
  description = "The location where the DDoS protection plan is created"
  type        = string
}

variable "tags" {
  description = "(Optional) The tags to associate with the DDoS protection plan"
  type        = map(string)
  default     = null
}