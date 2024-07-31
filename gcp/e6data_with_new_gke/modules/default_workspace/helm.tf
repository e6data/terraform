resource "helm_release" "e6data_workspace_deployment" {

  name             = var.workspace_name
  repository       = "https://e6data.github.io/helm-charts/"
  chart            = "workspace"
  namespace        = var.kubernetes_namespace
  create_namespace = true
  version          = var.helm_chart_version
  timeout          = 600

  values = [local.helm_values_file]

}