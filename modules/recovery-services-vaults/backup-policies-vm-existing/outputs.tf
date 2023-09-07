output "name" {
  value = data.azurerm_backup_policy_vm.policy.name
}

output "id" {
  value = data.azurerm_backup_policy_vm.policy.id
}

output "resource_group_name" {
  value = data.azurerm_backup_policy_vm.policy.resource_group_name
}

output "recovery_vault_name" {
  value = data.azurerm_backup_policy_vm.policy.recovery_vault_name
}