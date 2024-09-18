locals {
  authentication_mode = "CONFIG_MAP" // or "API_AND_CONFIG_MAP"
}

module "e6data_configmap" {
  source                  = "./modules/configmap"
  workspace_name          = var.workspace_name
  eks_cluster_name        = var.eks_cluster_name
  karpenter_node_role_arn = aws_iam_role.karpenter_node_role.arn
  cross_account_role_arn  = aws_iam_role.e6data_cross_account_role.arn
  aws_command_line_path   = var.aws_command_line_path
  map3                    = local.map3

  count = local.authentication_mode == "CONFIG_MAP" ? 1 : 0
}

module "e6data_configmap_and_api" {
  source                 = "./modules/configmap_and_api"
  workspace_name         = var.workspace_name
  eks_cluster_name       = var.eks_cluster_name
  principal_arn          = local.role_arn
  cross_account_role_arn = aws_iam_role.e6data_cross_account_role.arn

  count = local.authentication_mode == "API_AND_CONFIG_MAP" ? 1 : 0
}