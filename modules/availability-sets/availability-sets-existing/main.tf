data "azurerm_availability_set" "av_set" {
  name                = var.name
  resource_group_name = var.resource_group_name
}