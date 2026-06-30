# modules/aks/main.tf

# 1. System Node Pool (Only runs Kubernetes system pods)
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "capstone-aks"
  dns_prefix          = "capstone-cluster-dns"
  image_cleaner_enabled        = true
  image_cleaner_interval_hours = 168
  location            = var.location
  resource_group_name = var.resource_group_name
  oidc_issuer_enabled          = true
  workload_identity_enabled    = true

  default_node_pool {
    name           = "agentpool"
    node_count     = 1
    vm_size        = "Standard_B2s" 
    vnet_subnet_id = var.vnet_subnet_id
  }

  identity {
    type = "SystemAssigned" 
  }
}

# 2. User Node Pool (Dedicated exclusively to Grafana, ArgoCD, and your Website)
resource "azurerm_kubernetes_cluster_node_pool" "user_apps" {
  name                  = "capstonepool"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vm_size               = "Standard_B2s"
  node_count            = 1
  vnet_subnet_id        = var.vnet_subnet_id
}

output "kube_config" {
  value     = azurerm_kubernetes_cluster.aks.kube_config
  sensitive = true
}