terraform {
  required_version = "= 1.5.5"
  required_providers {
    azurerm = {
      source                = "hashicorp/azurerm"
      version               = "= 3.65.0"
      configuration_aliases = [azurerm.remote, azurerm.remote2, azurerm.remote3]
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "= 2.41.0"
    }
  }
}

data "azurerm_client_config" "current" {}
data "azuread_client_config" "current" {}
data "azurerm_subscription" "current" {}

variable "admin_username" {}
variable "admin_password" {}
variable "domain_user" {}
variable "domain_password" {}
variable "admin_ssh_key" {}