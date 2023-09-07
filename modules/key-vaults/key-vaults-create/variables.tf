variable "name" {
  description = "The name of the key vault"
  type        = string
}

variable "location" {
  description = "The location of the key vault"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the key vault"
  type        = string
}

variable "sku_name" {
  description = "The SKU name of the key vault"
  type        = string
  default     = "standard"
}

variable "tenant_id" {
  description = "The Azure Active Directory tenant ID that should be used for authenticating requests to the key vault"
  type        = string
}

variable "soft_delete_retention_days" {
  description = "The number of days that items should be retained for once soft deleted"
  type        = number
  default     = 90
}

variable "purge_protection_enabled" {
  description = "Is purge protection enabled for this Key Vault?"
  type        = bool
  default     = false
}

variable "enabled_for_disk_encryption" {
  description = "Is the Key Vault permitted to encrypt VM disks?"
  type        = bool
  default     = false
}

variable "enabled_for_deployment" {
  description = "Is the Key Vault permitted to retrieve secrets from Azure Resource Manager?"
  type        = bool
  default     = false
}

variable "enabled_for_template_deployment" {
  description = "Is the Key Vault permitted to retrieve secrets from Azure Resource Manager during a template deployment?"
  type        = bool
  default     = false
}

variable "enable_rbac_authorization" {
  description = "Is RBAC authorization enabled for this Key Vault?"
  type        = bool
  default     = false
}

variable "public_network_access_enabled" {
  description = "Is public network access allowed for this Key Vault?"
  type        = bool
  default     = true
}

variable "network_acls" {
  description = "A map of network ACLs"
  default     = {}
}

variable "access_policies" {
  description = "A map of access policies"
  default     = {}
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}