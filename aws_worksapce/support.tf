locals {
  e6data_workspace_name = "e6data-workspace-${var.workspace_name}"
  bucket_names_with_full_path = [for bucket_name in var.bucket_names : "arn:aws:s3:::${bucket_name}/*"]
  bucket_names_with_arn = [for bucket_name in var.bucket_names : "arn:aws:s3:::${bucket_name}"]

  oidc_tls_suffix = replace(module.eks.eks_oidc_tls, "https://", "")

  helm_values_file =yamlencode({
    cloud = {
      type = "AWS"
      oidc_value = aws_iam_role.e6data_engine_role.arn
      control_plane_user = ["e6data-${var.workspace_name}-user"]
    }
  })

  mapUsers = try(data.kubernetes_config_map_v1.aws_auth_read.data["mapUsers"], "")
  mapRoles = try(data.kubernetes_config_map_v1.aws_auth_read.data["mapRoles"], "")
  mapAccounts = try(data.kubernetes_config_map_v1.aws_auth_read.data["mapAccounts"], "")

  mapRoles2 = yamldecode(local.mapRoles)

  myroles = [{
    "rolearn"=  aws_iam_role.e6data_cross_account_role.arn,
    "username"= "e6data-${var.workspace_name}-user"
  }]

  totalRoles = concat(local.mapRoles2, local.myroles)
  totalRoles2 = yamlencode(local.totalRoles)

  mapData = {
     mapUsers = local.mapUsers == "" ? "" : local.mapUsers
     mapRoles = local.totalRoles2
     mapAccounts = local.mapAccounts == "" ? "" : local.mapAccounts
  }

  map2 = { for k, v in local.mapData : k => v if v != "" }

  map3 = { for k, v in local.map2 : k =>  replace(v, "\"", "") }
}

data "aws_caller_identity" "current" {
}

# data "aws_eks_cluster" "current" {
#   name = module.eks.cluster_name
# }

data "aws_eks_cluster_auth" "current" {
  name = module.eks.cluster_name
}

provider "kubernetes" {
  alias                  = "eks_e6data"
  host                   = module.eks.eks_endpoint
  cluster_ca_certificate = base64decode(module.eks.eks_certificate_data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
    command     = var.aws_command_line_path
  }
}

provider "helm" {
  alias                    = "eks_e6data"
  kubernetes {
    host                   = module.eks.eks_endpoint
    cluster_ca_certificate = base64decode(module.eks.eks_certificate_data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
      command     = var.aws_command_line_path
    }
  }
}