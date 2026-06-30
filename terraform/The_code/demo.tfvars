location            = "East US"
resource_group_name = "enterprise-demo-rg"

apps = {
  grafana = {
    hostname = "grafana.capstone.com"
    ip       = ["10.0.2.10"] # Replace with Grafana internal IP
  }
  argocd = {
    hostname = "argocd.capstone.com"
    ip       = ["10.0.2.11"] # Replace with ArgoCD internal IP
  }
  website = {
    hostname = "www.capstone.com"
    ip       = ["10.0.2.12"] # Replace with Website internal IP
  }
}