locals {
  tags = {
    managed_by = "terraform"
    module = "vm"
  }
}
resource "azurerm_network_interface" "nic" {
  for_each = var.virtual_machines
  name = "${each.key}-nic"
  location = var.location
  resource_group_name = var.resource_group_name
  ip_configuration {
    name = "internal"
    subnet_id = var.subnet_id
    private_ip_address_allocation = each.value.private_ip_address_allocation
  }
  tags = local.tags
}
resource "azurerm_linux_virtual_machine" "vm" {
  for_each = var.virtual_machines
  name = each.key
  resource_group_name = var.resource_group_name
  location = var.location
  size = each.value.size
  admin_username = var.admin_username
  admin_password = var.admin_password
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.nic[each.key].id
  ]
  os_disk {
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer = "0001-com-ubuntu-server-jammy"
    sku = "22_04-lts"
    version = "latest"
  }
  tags = local.tags
}
