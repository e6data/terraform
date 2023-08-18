resource "helm_release" "e6data_workspace_deployment" {
  provider = helm.e6data

  name       = var.workspace_name
  repository = "https://e6x-labs.github.io/helm-charts/"
  chart = "workspace"
  namespace  = var.kubernetes_namespace
  create_namespace = true
  version    = var.helm_chart_version
  timeout = 600

  values = [local.helm_values_file]

  lifecycle {
    ignore_changes = [ values ]
  }
}

data "kubernetes_config_map_v1" "aws_auth_read" {
  provider = kubernetes.e6data

  metadata {
    name = "aws-auth"
    namespace = "kube-system"
  }
  depends_on = [aws_eks_node_group.workspace_node_group]  
}

resource "kubernetes_config_map_v1_data" "aws_auth_update" {
  provider = kubernetes.e6data
  metadata {
    name = "aws-auth"
    namespace = "kube-system"
  }
  data = local.map3

  force = true
  lifecycle {
    ignore_changes = [ data ]    
  }
  depends_on = [aws_eks_node_group.workspace_node_group]  
}