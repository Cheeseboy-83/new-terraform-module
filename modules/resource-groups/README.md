# Resource Groups

To create resource groups in a deployment, make sure that you call the module with this syntax in your `main.tf`:

```
module "azure-terraform" {
  source = "git::git@ssh.dev.azure.com:v3<<oranizationName>>/<<projectName>>/<<moduleName>>" # or other git path to module if hosted on a platform other than Azure DevOps

  resource_groups = var.resource_groups

  providers = {
    azurerm.remote  = azurerm
    azurerm.remote2 = azurerm
    azurerm.remote3 = azurerm
  }
}
```

The line to add the resource_groups variable is essential to this deployment. Be sure to also define it in your `variables.tf` file with this block:

```
variable "resource_groups" {
  description = "Configuration for the resource groups"
  default     = {}
}
```

Here is a sample definition to include in your `terraform.tfvars` file:

```
resource_groups = {
  example_resource_group                  = {}
  example_resource_group_existing = {
    existing = true
  }
  example_resource_group_existing_remote = {
    existing = true
    remote   = true
  }
  example_resource_group_existing_remote2 = {
    existing = true
    remote2  = true
  }
  example_resource_group_existing_remote3 = {
    existing = true
    remote3  = true
  }
}
```

The first resource group listed here would be deployed on the primary subscription. The second would reference an existing resource group via a module that calls a terraform data block on the same subscription. The third would reference a resource group on the subscription whose alias is `azurerm.remote`. The fourth would reference one deployed to the subscription whose alias is `azurerm.remote2`. The last would reference one a resource group on the `azurerm.remote3` subscription alias. If using remote subscriptions, they must be declared in your `main.tf` file with blocks like this:

```
provider "azurerm" {
  features {}
  subscription_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
}

provider "azurerm" {
  features {}
  subscription_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  alias           = "remote"
}

provider "azurerm" {
  features {}
  subscription_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  alias           = "remote2"
}

provider "azurerm" {
  features {}
  subscription_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  alias           = "remote3"
}
```

Ensure that you define only the providers you need to use. They should also be defined in the `provdiers = {}` block in the module call like this:

```
module "azure-terraform" {
  ...

  providers = {
    azurerm.remote  = azurerm.remote
    azurerm.remote2 = azurerm.remote2
    azurerm.remote3 = azurerm.remote3
  }
}
```

Only the remote subscriptions required must be defined. If only one is needed, then `azurerm.remote2` can be defined as `azurerm` as in the initial module declaration of this ReadMe.