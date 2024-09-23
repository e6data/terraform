resource "helm_release" "workspace_deployment" {
  provider = helm.e6data

  name             = var.workspace_name
  repository       = "https://e6data.github.io/helm-charts/"
  chart            = "workspace"
  namespace        = var.kubernetes_namespace
  create_namespace = true
  version          = var.helm_chart_version
  timeout          = 600

  values = [local.helm_values_file]

  lifecycle {
    ignore_changes = [values]
  }
  depends_on = [data.azurerm_kubernetes_cluster.aks_e6data, kubernetes_namespace.e6data_namespace]
}