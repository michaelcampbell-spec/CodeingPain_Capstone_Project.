output "vm_ids" {
  value = {
    for vm_name, vm in azurerm_linux_virtual_machine.vm :
    vm_name => vm.id
  }
}
output "vm_names" {
  value = keys(azurerm_linux_virtual_machine.vm)
}
