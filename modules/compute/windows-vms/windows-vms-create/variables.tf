variable "name" {
  description = "The name of the virtual machine"
  type        = string
}

variable "computer_name" {
  description = "The computer name of the virtual machine"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the virtual machine"
  type        = string
}

variable "location" {
  description = "The location where the virtual machine is created"
  type        = string
}

variable "size" {
  description = "The size of the virtual machine"
  type        = string
}

variable "admin_username" {
  description = "The username of the local administrator to be created on the virtual machine"
  type        = string
}

variable "admin_password" {
  description = "The password of the local administrator to be created on the virtual machine"
  type        = string
}

variable "encryption_at_host_enabled" {
  description = "Whether to enable encryption at host for the virtual machine"
  type        = bool
  default     = false
}

variable "license_type" {
  description = "The license type of the virtual machine"
  type        = string
  default     = "None"
}

variable "secure_boot_enabled" {
  description = "Whether to enable secure boot for the virtual machine"
  type        = bool
  default     = false
}

variable "vtpm_enabled" {
  description = "Whether to enable vTPM for the virtual machine"
  type        = bool
  default     = false
}

variable "os_disk" {
  description = "The OS disk of the virtual machine"
  default     = {}
}

variable "image_reference" {
  description = "The image reference of the virtual machine"
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
}

variable "availability_set_id" {
  description = "The ID of the availability set in which to create the virtual machine"
  type        = string
}

variable "nics" {
  description = "The configuration of the network interfaces to associate with the virtual machine"
  default     = {}
}

variable "vnet" {
  description = "The name of the virtual network in which to create the virtual machine"
  type        = string
}

variable "vnet_rg" {
  description = "The name of the resource group in which the virtual network exists"
  type        = string
}

variable "tags" {
  description = "The tags to associate with the virtual machine"
  type        = map(string)
}

variable "boot_diagnostics_enabled" {
  description = "Whether to enable boot diagnostics for the virtual machine"
  type        = bool
}

variable "boot_diagnostics_storage_uri" {
  description = "The URI of the storage account to use for boot diagnostics"
  type        = string
}

variable "data_disks" {
  description = "The data disks of the virtual machine"
  default     = []
}

variable "zone" {
  description = "The zone in which to create the virtual machine"
  type        = string
  default     = null
}

variable "log_analytics_id" {
  description = "The ID of the log analytics workspace to use for diagnostics"
  type        = string
  default     = null
}

variable "log_analytics_workspace_id" {
  description = "The workspace ID of the log analytics workspace to use for diagnostics"
  type        = string
  default     = null
}

variable "log_analytics_workspace_key" {
  description = "The key of the log analytics workspace to use for diagnostics"
  type        = string
  default     = null
}

variable "storage_account_id" {
  description = "The ID of the storage account to use for diagnostics"
  type        = string
  default     = null
}

variable "eventhub_name" {
  description = "The name of the event hub to use for diagnostics"
  type        = string
  default     = null
}

variable "eventhub_authorization_rule_id" {
  description = "The ID of the event hub authorization rule to use for diagnostics"
  type        = string
  default     = null
}

variable "partner_solution_id" {
  description = "The ID of the partner solution to use for diagnostics"
  type        = string
  default     = null
}

variable "extensions" {
  description = "The extensions to install on the virtual machine"
  default     = []
}

variable "domain_name" {
  description = "The domain name to use for domain join"
  type        = string
}

variable "domain_user" {
  description = "The domain user to use for domain join"
  type        = string
}

variable "ou_path" {
  description = "The OU path to use for domain join"
  type        = string
}

variable "domain_password" {
  description = "The domain password to use for domain join"
  type        = string
}