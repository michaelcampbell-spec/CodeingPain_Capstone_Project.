# modules/acr/main.tf
resource "azurerm_container_registry" "acr" {
  name                = "capstone-acr" # Must be globally unique
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Standard" # Premium for enterprise (Private Endpoints), but Standard works for a demo
  admin_enabled       = false      # True enterprise disables admin keys
}

output "id" { value = azurerm_container_registry.acr.id }