locals {
  short_workspace_name = substr(var.workspace_name, 0, 5)

  e6data_workspace_name = "e6data-workspace-${local.short_workspace_name}"
  bucket_names_with_full_path = [for bucket_name in var.bucket_names : "arn:aws:s3:::${bucket_name}/*"]
  bucket_names_with_arn = [for bucket_name in var.bucket_names : "arn:aws:s3:::${bucket_name}"]

  e6data_nodepool_name = "e6data-nodepool-${local.short_workspace_name}"
  e6data_nodeclass_name = "e6data-nodeclass-${local.short_workspace_name}"

  oidc_tls_suffix = replace(module.eks.eks_oidc_tls, "https://", "")

  helm_values_file =yamlencode({
    cloud = {
      type = "AWS"
      oidc_value = aws_iam_role.e6data_engine_role.arn
      control_plane_user = ["e6data-${var.workspace_name}-user"]
    }
    karpenter = {
      nodepool = local.e6data_nodepool_name
      nodeclass = local.e6data_nodeclass_name
    }
  })

  mapUsers = try(data.kubernetes_config_map_v1.aws_auth_read.data["mapUsers"], "")
  mapRoles = try(data.kubernetes_config_map_v1.aws_auth_read.data["mapRoles"], "")
  mapAccounts = try(data.kubernetes_config_map_v1.aws_auth_read.data["mapAccounts"], "")

  mapRoles2 = yamldecode(local.mapRoles)

  myroles = [{
    "rolearn"=  aws_iam_role.e6data_cross_account_role.arn,
    "username"= "e6data-${var.workspace_name}-user"
  },
  {
    "rolearn"=  aws_iam_role.karpenter_node_role.arn,
    "username"= "system:node:{{EC2PrivateDNSName}}"
    "groups"= ["system:bootstrappers", "system:nodes"]
  }]


  totalRoles = concat(local.mapRoles2, local.myroles, )
  totalRoles2 = yamlencode(local.totalRoles)

  mapData = {
     mapUsers = local.mapUsers == "" ? "" : local.mapUsers
     mapRoles = local.totalRoles2
     mapAccounts = local.mapAccounts == "" ? "" : local.mapAccounts
  }

  map2 = { for k, v in local.mapData : k => v if v != "" }

  map3 = { for k, v in local.map2 : k =>  replace(v, "\"", "") }
}

resource "random_string" "random" {
  length           = 5
  special          = false
  lower            = true
  upper            = false
}

data "aws_caller_identity" "current" {
}

# data "aws_eks_cluster" "current" {
#   name = module.eks.cluster_name
# }

# data "aws_eks_cluster_auth" "current" {
#   name = module.eks.cluster_name
# }