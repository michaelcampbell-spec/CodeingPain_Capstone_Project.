# modules/acr/main.tf
resource "azurerm_container_registry" "acr" {
  name                = "capstoneacr" 
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Standard" 
  admin_enabled       = false     
}

output "id" { 
  value = azurerm_container_registry.acr.id 
}