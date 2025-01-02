# Configure authentication and access management for EKS cluster
module "e6data_configmap_and_api" {
  source = "./modules/configmap_and_api"
  count  = contains(["API", "API_AND_CONFIG_MAP"], data.aws_eks_cluster.current.access_config[0].authentication_mode) ? 1 : 0

  workspace_name         = var.workspace_name
  eks_cluster_name       = var.eks_cluster_name
  cross_account_role_arn = aws_iam_role.e6data_cross_account_role.arn
}

data "kubernetes_config_map_v1" "aws_auth_read" {
  provider = kubernetes.eks_e6data

  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }
}

resource "kubernetes_config_map_v1_data" "aws_auth_update" {
  provider = kubernetes.eks_e6data

  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  count = data.aws_eks_cluster.current.access_config[0].authentication_mode == "CONFIGMAP" ? 1 : 0

  data = local.map3

  force = true
  lifecycle {
    ignore_changes = [data]
  }
}