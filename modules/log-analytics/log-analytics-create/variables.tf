variable "name" {
  description = "The name of the log analytics workspace"
  type        = string
}

variable "location" {
  description = "The location of the log analytics workspace"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which the log analytics workspace will be created"
  type        = string
}

variable "sku" {
  description = "The SKU (pricing tier) of the log analytics workspace"
  type        = string
}

variable "retention_in_days" {
  description = "The retention period in days for the logs in the log analytics workspace"
  type        = number
}

variable "daily_quota_gb" {
  description = "The daily quota in GB for the ingestion of data into the log analytics workspace"
  type        = number
}

variable "internet_ingestion_enabled" {
  description = "Is internet ingestion enabled for the log analytics workspace"
  type        = bool
}

variable "internet_query_enabled" {
  description = "Is internet query enabled for the log analytics workspace"
  type        = bool
}

variable "tags" {
  description = "The tags to associate with the log analytics workspace"
  type        = map(string)
}