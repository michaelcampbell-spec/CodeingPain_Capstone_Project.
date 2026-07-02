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
    vm_size        = "Standard_B2s_v2"
    vnet_subnet_id = var.vnet_subnet_id
    max_pods = 80 #Testing if grafana pods will deploy on the system node pool, if not, we will create a user node pool for the apps

    temporary_name_for_rotation = "tmpagentpool"
  }

  identity {
    type = "SystemAssigned" 
  }

  network_profile {
    network_plugin     = "azure"            
    service_cidr       = "172.16.0.0/16"     # Clean, completely separated space for services
    dns_service_ip     = "172.16.0.10"       # Must sit inside the service_cidr range
  }
}

# # 2. User Node Pool (Dedicated exclusively to Grafana, ArgoCD, and your Website)
# resource "azurerm_kubernetes_cluster_node_pool" "user_apps" {
#   name                  = "capstonepool"
#   kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
#   vm_size               = "Standard_B2ls_v2"
#   node_count            = 1
#   vnet_subnet_id        = var.vnet_subnet_id
# }

output "kube_config" {
  value     = azurerm_kubernetes_cluster.aks.kube_config
  sensitive = true
}