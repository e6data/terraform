resource "null_resource" "e6data_configmap" {
  count = local.authentication_mode == "CONFIG_MAP" ? 1 : 0
}

module "e6data_configmap_instance" {
  source                  = "./modules/configmap"
  workspace_name          = var.workspace_name
  eks_cluster_name        = var.eks_cluster_name
  karpenter_node_role_arn = aws_iam_role.karpenter_node_role.arn
  cross_account_role_arn  = aws_iam_role.e6data_cross_account_role.arn
  aws_command_line_path   = var.aws_command_line_path

  # Ensure this only runs if count is greater than zero.
  depends_on = [null_resource.e6data_configmap]
}

resource "null_resource" "e6data_configmap_and_api" {
  count = local.authentication_mode == "API_AND_CONFIG_MAP" ? 1 : 0
}

module "e6data_configmap_and_api_instance" {
  source                 = "./modules/configmap_and_api"
  workspace_name         = var.workspace_name
  eks_cluster_name       = var.eks_cluster_name
  cross_account_role_arn = aws_iam_role.e6data_cross_account_role.arn

  # Ensure this only runs if count is greater than zero.
  depends_on = [null_resource.e6data_configmap_and_api]
}