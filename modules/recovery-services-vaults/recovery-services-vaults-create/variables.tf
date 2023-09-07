variable "name" {
  description = "The name of the Recovery Services Vault"
}

variable "location" {
  description = "The location/region where the Recovery Services Vault is created"
}

variable "resource_group_name" {
  description = "The name of the resource group in which the Recovery Services Vault is created"
}

variable "sku" {
  description = "The SKU of the Recovery Services Vault"
}

variable "public_network_access_enabled" {
  description = "Is public network access enabled for the Recovery Services Vault"
}

variable "soft_delete_enabled" {
  description = "Is soft delete enabled for the Recovery Services Vault"
}

variable "tags" {
  description = "The tags to associate with the Recovery Services Vault"
}

variable "backup_policies" {
  description = "The backup policies to associate with the Recovery Services Vault"
}