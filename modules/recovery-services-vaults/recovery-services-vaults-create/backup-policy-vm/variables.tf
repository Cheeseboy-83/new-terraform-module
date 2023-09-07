variable "name" {
  description = "The name of the VM backup policy"
}

variable "resource_group_name" {
  description = "The name of the resource group in which the backup policy is created"
}

variable "recovery_vault_name" {
  description = "The name of the Recovery Services Vault in which the backup policy is created"
}

variable "timezone" {
  description = "The timezone of the backup policy"
}

variable "policy_type" {
  description = "The type of the backup policy"
}

variable "backup_frequency" {
  description = "The frequency of the backup policy"
}

variable "backup_time" {
  description = "The time of the backup policy"
}

variable "retention_daily" {
  description = "The retention policy for daily backups"
}

variable "retention_weekly" {
  description = "The retention policy for weekly backups"
}

variable "retention_monthly" {
  description = "The retention policy for monthly backups"
}

variable "retention_yearly" {
  description = "The retention policy for yearly backups"
}