# 1. CORE NETWORKING LAYER
# Deploys the unified VNet and slices out dedicated subnets for AppGW and AKS.
module "network" {
  source              = "./modules/network"
  location            = var.location
  resource_group_name = var.resource_group_name
}

# 2. CONTAINER REGISTRY LAYER
# Provisions a private registry with admin credentials disabled for secure image hosting.
module "acr" {
  source              = "./modules/acr"
  location            = var.location
  resource_group_name = var.resource_group_name
}

# 3. COMPUTE LAYER (AKS)
# Deploys the cluster, assigning system pods and application workloads to distinct node pools.
module "aks" {
  source              = "./modules/aks"
  location            = var.location
  resource_group_name = var.resource_group_name
  vnet_subnet_id      = module.network.aks_subnet_id
}

# 4. EDGE ROUTING LAYER (APPLICATION GATEWAY)
# Spins up the public entry point and maps incoming traffic for Grafana, ArgoCD, and the website.
module "app_gateway" {
  source              = "./modules/app_gateway"
  location            = var.location
  resource_group_name = var.resource_group_name
  appgw_name          = "capstone-appgw"
  subnet_id           = module.network.appgw_subnet_id
  listeners           = var.listeners
}