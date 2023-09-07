output "name" {
  value = azurerm_backup_policy_vm.policy.name
}

output "id" {
  value = azurerm_backup_policy_vm.policy.id
}

output "resource_group_name" {
  value = azurerm_backup_policy_vm.policy.resource_group_name
}

output "recovery_vault_name" {
  value = azurerm_backup_policy_vm.policy.recovery_vault_name
}

output "timezone" {
  value = azurerm_backup_policy_vm.policy.timezone
}

output "policy_type" {
  value = azurerm_backup_policy_vm.policy.policy_type
}

output "backup_frequency" {
  value = azurerm_backup_policy_vm.policy.backup.0.frequency
}

output "backup_time" {
  value = azurerm_backup_policy_vm.policy.backup.0.time
}