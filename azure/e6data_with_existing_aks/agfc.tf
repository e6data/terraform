# Create Application Gateway for Containers resource using Kubernetes manifest
resource "kubernetes_manifest" "application_load_balancer" {
  provider = kubernetes.e6data
  count    = var.agfc_enabled && var.alb_subnet_id != "" ? 1 : 0

  manifest = {
    apiVersion = "alb.networking.azure.io/v1"
    kind       = "ApplicationLoadBalancer"
    metadata = {
      name      = var.workspace_name
      namespace = var.kubernetes_namespace
    }
    spec = {
      associations = [
        var.alb_subnet_id
      ]
    }
  }

  depends_on = [
    data.azurerm_kubernetes_cluster.aks_e6data,
    helm_release.alb_controller,
    azurerm_role_assignment.alb_identity_subnet_join,
    azurerm_role_assignment.alb_identity_agfc_config_manager
  ]
}
