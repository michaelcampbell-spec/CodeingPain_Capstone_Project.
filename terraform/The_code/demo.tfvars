location            = "southafricanorth"
resource_group_name = "capstone"

apps = {
  grafana = {
    hostname = "grafana.capstone.com"
    ip       = ["10.0.2.00"] # Replace with Grafana internal IP
  }
  argocd = {
    hostname = "argocd.capstone.com"
    ip       = ["10.0.2.50"] # Replace with ArgoCD internal IP
  }
  website = {
    hostname = "www.capstone.com"
    ip       = ["10.0.2.33"] # Replace with Website internal IP
  }
}
