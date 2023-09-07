variable "name" {
  description = "The name of the diagnostics setting"
  type        = string
}

variable "target_resource_id" {
  description = "The ID of the resource to configure diagnostics on"
  type        = string
}

variable "log_analytics_workspace_id" {
  description = "The ID of the log analytics workspace to send diagnostics to"
  type        = string
}

variable "log_analytics_destination_type" {
  description = "The type of the log analytics destination"
  type        = string
  default     = "Dedicated"
}

variable "storage_account_id" {
  description = "The ID of the storage account to send diagnostics to"
  type        = string
}

variable "eventhub_name" {
  description = "The name of the event hub to send diagnostics to"
  type        = string
}

variable "eventhub_authorization_rule_id" {
  description = "The ID of the event hub authorization rule to send diagnostics to"
  type        = string
}

variable "partner_solution_id" {
  description = "The ID of the partner solution to send diagnostics to"
  type        = string
}