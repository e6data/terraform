module "e6data_authentication" {
  source                 = "./modules/authentication"
  count = data.aws_eks_cluster.current.access_config[0].authentication_mode == "API_AND_CONFIG_MAP" ? 1 : 0

  workspace_name         = var.workspace_name
  principal_arn = local.role_arn
  eks_cluster_name       = var.eks_cluster_name

  cross_account_role_arn = aws_iam_role.e6data_cross_account_role.arn

  depends_on = [module.eks]
}