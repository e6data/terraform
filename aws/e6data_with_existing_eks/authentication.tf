module "e6data_configmap_and_api" {
  source                 = "./modules/configmap_and_api"
  count = data.aws_eks_cluster.current.access_config[0].authentication_mode == "API_AND_CONFIG_MAP" ? 1 : 0

  eks_cluster_name = var.eks_cluster_name
  cross_account_role_arn = var.cross_account_role_arn
  principal_arn = var.principal_arn
  workspace_name = var.workspace_name
}