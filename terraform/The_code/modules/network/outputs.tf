output "appgw_subnet_id" {
  value       = azurerm_subnet.appgw_subnet.id
  description = "The ID of the subnet dedicated to the Application Gateway."
}

output "aks_subnet_id" {
  value       = azurerm_subnet.aks_subnet.id
  description = "The ID of the subnet dedicated to the AKS cluster."
}

output "runner_subnet_id" {
  value       = azurerm_subnet.runner_subnet.id
  description = "The ID of the subnet dedicated to the GitHub Actions runner."
}