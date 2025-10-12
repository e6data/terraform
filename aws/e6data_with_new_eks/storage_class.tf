variable "storage_classes" {
  description = "Storage classes"
  default = {
    "gp3" = {
      storage_type               = "gp3"
      reclaim_policy             = "Delete"
      topology_availability_zone = "us-east-1b"
    }
  }
}
variable "eks_addons" {
  description = "EKS addons"
  default = {
    # addon_version = "v1"
    "aws-ebs-csi-driver" = {
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
    }
  }
}

variable "region" {
  type        = string
  description = "the region where all the resources are created"
  default = "us-east-1"
}
resource "kubernetes_storage_class" "storage_class" {
  provider = kubernetes.e6data

  for_each = var.storage_classes

  metadata {
    name = each.key
    annotations = {
      "storageclass.kubernetes.io/is-default-class" : "false"
    }
  }

  parameters = {
    type = each.value.storage_type
  }

  storage_provisioner = "ebs.csi.aws.com"
  reclaim_policy      = each.value.reclaim_policy
  allowed_topologies {
    match_label_expressions {
      key    = "topology.kubernetes.io/zone"
      values = [each.value.topology_availability_zone]
    }
  }

  depends_on = [
    aws_eks_addon.default_addons, ]
}

resource "aws_eks_addon" "default_addons" {
  cluster_name = module.eks.cluster_name

  for_each = var.eks_addons

  addon_name = each.key

  configuration_values = jsonencode("${each.value}")

  depends_on = [aws_eks_node_group.default_node_group, module.eks]
}

resource "aws_iam_policy" "ebs_management" {
  name        = "${var.cluster_name}-ebs-management"
  description = "Policy to manage EBS volumes for EKS nodes"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:CreateVolume",
          "ec2:DescribeVolumes",
          "ec2:AttachVolume",
          "ec2:DetachVolume",
          "ec2:DeleteVolume",
          "ec2:CreateTags"
        ]
        Resource = ["arn:aws:ec2:${var.region}:*:volume/*",
        "arn:aws:ec2:${var.region}:*:instance/*"]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_ebs_policy" {
  policy_arn = aws_iam_policy.ebs_management.arn
  role       = aws_iam_role.eks_nodegroup_iam_role.name
}

# Attach AWS managed EBS CSI Driver policy to node group role
resource "aws_iam_role_policy_attachment" "attach_aws_ebs_csi_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  role       = aws_iam_role.eks_nodegroup_iam_role.name
}
