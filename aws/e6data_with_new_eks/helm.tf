resource "helm_release" "e6data_workspace_deployment" {
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

  depends_on = [module.eks, aws_eks_node_group.default_node_group]
}

resource "aws_eks_access_entry" "aws_auth_update" {
  cluster_name  = module.eks.cluster_name
  principal_arn = aws_iam_role.e6data_cross_account_role.arn
  type          = "STANDARD"
  user_name     = "e6data-${var.workspace_name}-user"
  depends_on    = [module.eks]
}

resource "aws_eks_access_entry" "aws_karpenter_auth_update" {
  cluster_name  = module.eks.cluster_name
  principal_arn = aws_iam_role.karpenter_node_role.arn
  type          = "STANDARD"
  user_name     = "e6dsata-${var.workspace_name}-user"
  depends_on    = [module.eks]
}