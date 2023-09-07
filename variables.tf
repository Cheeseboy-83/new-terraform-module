variable "global_settings" {
  description = "Global tags to be applied to all resources"
  type = object({
    location = string
    tags     = map(string)
  })
  default = null
}

variable "resource_groups" {
  description = "Configuration for the resource groups"
  default     = {}
}

variable "private_dns_zones" {
  description = "Configuration for the private DNS zones"
  default     = {}
}

variable "ddos_protection_plans" {
  description = "Configuration for the DDoS protection plans"
  default     = {}
}

variable "virtual_networks" {
  description = "Configuration for the virtual networks"
  default     = {}
}

variable "subnets" {
  description = "Configuration for the subnets"
  default     = {}
}

variable "storage_accounts" {
  description = "Configuration for the storage accounts"
  default     = {}
}

variable "log_analytics" {
  description = "Configuration for the log analytics workspaces"
  default     = {}
}

variable "network_watchers" {
  description = "Configuration for the network watchers"
  default     = {}
}

variable "virtual_network_peerings" {
  description = "Configuration for the virtual network peerings"
  default     = {}
}

variable "key_vaults" {
  description = "Configuration for the key vaults"
  default     = {}
}

variable "availability_sets" {
  description = "Configuration for the availability sets"
  default     = {}
}

variable "recovery_services_vaults" {
  description = "Configuration for the recovery services vaults"
  default     = {}
}

variable "windows_vms" {
  description = "Configuration for the Windows VMs"
  default     = {}
}

variable "vm_backup_policies" {
  description = "Configuration for the VM backup policies"
  default     = {}
}

variable "linux_vms" {
  description = "Configuration for the Linux VMs"
  default     = {}
}

variable "network_security_groups" {
  description = "Configuration for the network security groups"
  default     = {}
}

variable "route_tables" {
  description = "Configuration for the route tables"
  default     = {}
}

variable "public_ips" {
  description = "Configuration for the public IPs"
  default     = {}
}