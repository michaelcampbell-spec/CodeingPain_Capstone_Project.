data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

module "network" {
  source              = "./modules/network"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name
}

module "acr" {
  source              = "./modules/acr"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name
}

module "aks" {
  source              = "./modules/aks"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name
  vnet_subnet_id      = module.network.aks_subnet_id
}

module "app_gateway" {
  source              = "./modules/app_gateway"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name
  appgw_name          = "capstone-appgw"
  subnet_id           = module.network.appgw_subnet_id
  listeners           = var.apps
}


data "azurerm_key_vault" "existing_kv" {
  name                = "capstone-key-vault" 
  resource_group_name = data.azurerm_resource_group.rg.name
}

data "azurerm_key_vault_secret" "vm_password" {
  name         = "capstone-vm-password"
  key_vault_id = data.azurerm_key_vault.existing_kv.id
}

module "github_runner_vm" {
  source              = "./modules/github_runner_vm"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name
  subnet_id           = module.network.runner_subnet_id
  admin_username      = "runneradmin"
  admin_password      = data.azurerm_key_vault_secret.vm_password.value
}