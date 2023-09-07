variable "name" {
  description = "The name of the storage account"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the storage account"
  type        = string
}

variable "location" {
  description = "The location of the resource group in which to create the storage account"
  type        = string
}

variable "account_kind" {
  description = "Defines the Kind to use for this storage account"
  type        = string
  default     = "StorageV2"
}

variable "account_tier" {
  description = "Defines the Tier to use for this storage account"
  type        = string
  default     = "Standard"
}

variable "account_replication_type" {
  description = "Defines the replication type for this storage account"
  type        = string
  default     = "LRS"
}

variable "access_tier" {
  description = "Defines the access_tier of this storage account"
  type        = string
  default     = "Hot"
}

variable "enable_https_traffic_only" {
  description = "Force HTTPS traffic only to storage service if set to true"
  type        = bool
  default     = true
}

variable "min_tls_version" {
  description = "Sets the minimum TLS version for this storage account"
  type        = string
  default     = "TLS1_2"
}

variable "public_network_access_enabled" {
  description = "Whether or not public network access is allowed for this storage account"
  type        = bool
  default     = true
}

variable "allow_nested_items_to_be_public" {
  description = "Whether or not public network access is allowed for this storage account"
  type        = bool
  default     = true
}

variable "infrastructure_encryption_enabled" {
  description = "Whether or not infrastructure encryption is enabled for this storage account"
  type        = bool
  default     = true
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "network_rules" {
  description = "A network_rules block"
  default     = {}
}

variable "private_endpoint" {
  description = "Whether or not to create a private endpoint for this storage account"
  type        = bool
}

variable "subnet_id" {
  description = "The ID of the subnet in which to create the private endpoint"
  type        = string
  default     = null
}

variable "private_dns_zone_ids" {
  description = "A list of private DNS zone IDs to associate with the private endpoint"
  type        = list(string)
  default     = []
}