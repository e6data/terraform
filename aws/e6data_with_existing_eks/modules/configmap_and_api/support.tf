data "aws_caller_identity" "current" {
}

data "aws_eks_cluster" "current" {
  name = var.eks_cluster_name
}

locals {
  is_assumed_role = regex("assumed-role", data.aws_caller_identity.current.arn) != ""
  role_name       = split("/", data.aws_caller_identity.current.arn)[1]
  role_arn        = local.is_assumed_role ? "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${local.role_name}" : data.aws_caller_identity.current.arn
}
