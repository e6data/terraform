locals {
  mapUsers    = try(data.kubernetes_config_map_v1.aws_auth_read.data["mapUsers"], "")
  mapRoles    = try(data.kubernetes_config_map_v1.aws_auth_read.data["mapRoles"], "")
  mapAccounts = try(data.kubernetes_config_map_v1.aws_auth_read.data["mapAccounts"], "")

  mapRoles2 = yamldecode(local.mapRoles)

  myroles = [{
    "rolearn"  = aws_iam_role.e6data_cross_account_role.arn,
    "username" = "e6data-${var.workspace_name}-user"
    },
    {
      "rolearn"  = aws_iam_role.karpenter_node_role.arn,
      "username" = "system:node:{{EC2PrivateDNSName}}"
      "groups"   = ["system:bootstrappers", "system:nodes"]
  }]

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



data "kubernetes_config_map_v1" "aws_auth_read" {
  provider = kubernetes.eks_e6data

  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }
}

resource "kubernetes_config_map_v1_data" "aws_auth_update" {
  provider = kubernetes.eks_e6data
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }
  data = local.map3

  force = true
  lifecycle {
    ignore_changes = [data]
  }
}

data "aws_caller_identity" "current" {
}

data "aws_eks_cluster" "current" {
  name = var.eks_cluster_name
}
