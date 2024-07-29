resource "helm_release" "e6data_workspace_deployment" {
  provider = helm.gke_e6data

  count = length(var.workspace_names)

  name             = var.workspace_names[count.index].name
  repository       = "https://e6x-labs.github.io/helm-charts/"
  chart            = "workspace"
  namespace        = var.workspace_names[count.index].namespace
  create_namespace = true
  version          = var.helm_chart_version
  timeout          = 600

  values = [local.helm_values_file]
}