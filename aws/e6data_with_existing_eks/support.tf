locals {
  short_workspace_name = substr(var.workspace_name, 0, 5)
  e6data_workspace_name       = "e6data-workspace-${local.short_workspace_name}"
  bucket_names_with_full_path = [for bucket_name in var.bucket_names : "arn:aws:s3:::${bucket_name}/*"]
  bucket_names_with_arn       = [for bucket_name in var.bucket_names : "arn:aws:s3:::${bucket_name}"]

  e6data_nodepool_name  = "e6data-nodepool-${local.short_workspace_name}-${random_string.random.result}"
  e6data_nodeclass_name = "e6data-nodeclass-${local.short_workspace_name}-${random_string.random.result}"

  oidc_tls_suffix = replace(data.aws_eks_cluster.current.identity[0].oidc[0].issuer, "https://", "")

  helm_values_file = yamlencode({
    cloud = {
      type               = "AWS"
      oidc_value         = aws_iam_role.e6data_engine_role.arn
      control_plane_user = ["e6data-${var.workspace_name}-user"]
      debug_namespaces   = var.debug_namespaces
    }
  })
  mapUsers    = try(data.kubernetes_config_map_v1.aws_auth_read.data["mapUsers"], "")
  mapRoles    = try(data.kubernetes_config_map_v1.aws_auth_read.data["mapRoles"], "")
  mapAccounts = try(data.kubernetes_config_map_v1.aws_auth_read.data["mapAccounts"], "")

  mapRoles2 = yamldecode(local.mapRoles)

  myroles = [
    {
      "rolearn"  = aws_iam_role.e6data_cross_account_role.arn,
      "username" = "e6data-${var.workspace_name}-user"
    }
  ]

  totalRoles  = concat(local.mapRoles2, local.myroles)
  totalRoles2 = yamlencode(local.totalRoles)

  mapData = {
    mapUsers    = local.mapUsers == "" ? "" : local.mapUsers
    mapRoles    = local.totalRoles2
    mapAccounts = local.mapAccounts == "" ? "" : local.mapAccounts
  }

  map2 = { for k, v in local.mapData : k => v if v != "" }

  map3 = { for k, v in local.map2 : k => replace(v, "\"", "") }
}

resource "random_string" "random" {
  length  = 5
  special = false
  lower   = true
  upper   = false
}

data "aws_caller_identity" "current" {
}

data "aws_eks_cluster" "current" {
  name = var.eks_cluster_name
}

data "aws_eks_cluster_auth" "current" {
  name = var.eks_cluster_name
}

data "aws_eks_node_groups" "current" {
  cluster_name = data.aws_eks_cluster.current.name
}

data "aws_eks_node_group" "current" {
  cluster_name   = var.eks_cluster_name
  node_group_name = tolist(data.aws_eks_node_groups.current.names)[0]
}

data "aws_eks_cluster_auth" "target_eks_auth" {
  name = data.aws_eks_cluster.current.name
}

provider "kubernetes" {
  alias                  = "eks_e6data"
  host                   = data.aws_eks_cluster.current.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.current.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.target_eks_auth.token
}

provider "kubectl" {
  host                   = data.aws_eks_cluster.current.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.current.certificate_authority[0].data)
  load_config_file       = false
  token                  = data.aws_eks_cluster_auth.target_eks_auth.token
}

provider "helm" {
  alias = "eks_e6data"
  kubernetes {
    host                   = data.aws_eks_cluster.current.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.current.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.target_eks_auth.token
  }
}
