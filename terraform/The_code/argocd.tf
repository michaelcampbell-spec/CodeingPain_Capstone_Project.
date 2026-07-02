# 1. Create the ArgoCD Namespace
resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }

  # Ensure the AKS cluster exists before trying to create a namespace in it
  depends_on = [module.aks]
}

# 2. Deploy ArgoCD via Helm
resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = kubernetes_namespace.argocd.metadata[0].name
  version    = "10.1.0" # It is best practice to pin a chart version

  depends_on = [kubernetes_namespace.argocd]

  # Pull in custom ACR image values from your CI-CD folder
  values = [
    file("../../CI-CD/values.yaml"),
    <<-EOT
    server:
      extraArgs:
        - --insecure
      service:
        type: LoadBalancer
        loadBalancerIP: 10.0.2.83
        annotations:
          service.beta.kubernetes.io/azure-load-balancer-internal: "true"
    EOT
  ]
}