output "resource_group_name" {
  value = "azurerm_resource_group"
}

output "vm_name" {
  value = [for i in range(var.vm_count) : azurerm_virtual_machine.vm[i].name]
}

output "storage_account_name" {
  value = "azurerm_storage_account"
}