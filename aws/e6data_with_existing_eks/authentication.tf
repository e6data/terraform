
module "e6data_configmap_and_api" {
  source                 = "./modules/configmap_and_api"
  count = data.aws_eks_cluster.current.access_config[0].authentication_mode == "API_AND_CONFIG_MAP" ? 1 : 0

  workspace_name         = var.workspace_name
  eks_cluster_name       = var.eks_cluster_name
  principal_arn          = local.role_arn
  cross_account_role_arn = aws_iam_role.e6data_cross_account_role.arn
}