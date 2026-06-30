terraform {
  backend "azurerm" {
    # Replace these with the real details of your administrative storage layout
    resource_group_name  = "management-rg"
    storage_account_name = "capstonetfstate2026"
    container_name       = "tfstate"
    key                  = "core-infra.terraform.tfstate"
  }
}