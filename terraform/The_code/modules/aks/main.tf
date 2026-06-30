# modules/aks/main.tf

# 1. System Node Pool (Only runs Kubernetes system pods)
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "enterprise-aks"
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "enterprise-cluster"

  default_node_pool {
    name           = "systempool"
    node_count     = 1
    vm_size        = "Standard_B2s" 
    vnet_subnet_id = var.vnet_subnet_id
  
  }

  identity { type = "SystemAssigned" }
}

# 2. User Node Pool (Dedicated exclusively to Grafana, ArgoCD, and your Website)
resource "azurerm_kubernetes_cluster_node_pool" "user_apps" {
  name                  = "userapps"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vm_size               = "Standard_B2s"
  node_count            = 1
  vnet_subnet_id        = var.vnet_subnet_id
  
  node_labels = {
    "role" = "workloads"
  }
}

# Output the cluster's identity principal ID so we can give it access to ACR
output "kubelet_identity_principal_id" {
  value = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
}

output "kube_config" {
  value     = azurerm_kubernetes_cluster.aks.kube_config
  sensitive = true
}