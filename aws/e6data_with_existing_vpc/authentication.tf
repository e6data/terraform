# Configure authentication and access management for EKS cluster
module "e6data_authentication" {
  source                 = "./modules/authentication"
  workspace_name         = var.workspace_name
  principal_arn          = local.role_arn
  eks_cluster_name       = module.eks.cluster_name
  cross_account_role_arn = aws_iam_role.e6data_cross_account_role.arn

  depends_on = [module.eks]
}