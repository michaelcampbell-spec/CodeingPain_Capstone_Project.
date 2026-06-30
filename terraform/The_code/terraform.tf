terraform {
  backend "azurerm" {
    resource_group_name  = "capstone"
    storage_account_name = "capstonesa10"
    container_name       = "capstone-blob"
    key                  = "capstone-core-infra.terraform.tfstate"
  }
}