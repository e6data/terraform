resource "aws_eks_addon" "ebs_csi_driver" {
  cluster_name = module.eks.cluster_name
  addon_name   = "aws-ebs-csi-driver"

  configuration_values = jsonencode({
    controller = {
      tolerations = [
        {
          key      = "app"
          operator = "Equal"
          value    = "e6data"
          effect   = "NoSchedule"
        }
      ]
    }
  })

  depends_on = [aws_eks_node_group.default_node_group, module.eks]
}

resource "kubernetes_storage_class" "gp3" {
  provider = kubernetes.e6data

  metadata {
    name = "gp3"
    annotations = {
      "storageclass.kubernetes.io/is-default-class" : "false"
    }
  }

  parameters = {
    type = "gp3"
  }

  storage_provisioner = "ebs.csi.aws.com"
  reclaim_policy      = "Delete"

  depends_on = [aws_eks_addon.ebs_csi_driver]
}
