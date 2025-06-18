# This resource adds a tag to each subnet in the network module
# to enable Karpenter to discover the EKS cluster.
resource "aws_ec2_tag" "karpenter_subnet_cluster_tag" {
  count       = length(var.subnet_ids)
  resource_id = var.subnet_ids[count.index]
  key         = "karpenter.sh/discovery"
  value       = data.aws_eks_cluster.cluster.id
}

# Grants Karpenter controller scoped permissions to manage EC2 resources, including creation, tagging, and deletion, with conditions to limit actions to specific cluster and nodepool tags.
data "aws_iam_policy_document" "karpenter_controller_policy_document" {
  statement {
    actions = [
      "ec2:RunInstances",
      "ec2:CreateFleet"
    ]
    sid    = "AllowScopedEC2InstanceAccessActions"
    effect = "Allow"
    resources = [
      "arn:aws:ec2:${var.aws_region}::image/*",
      "arn:aws:ec2:${var.aws_region}::snapshot/*",
      "arn:aws:ec2:${var.aws_region}:*:security-group/*",
      "arn:aws:ec2:${var.aws_region}:*:subnet/*"
    ]
  }

  statement {
    actions = [
      "ec2:RunInstances",
      "ec2:CreateFleet"
    ]

    effect    = "Allow"
    resources = ["arn:aws:ec2:${var.aws_region}:*:launch-template/*"]
    sid       = "AllowScopedEC2LaunchTemplateAccessActions"
    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/kubernetes.io/cluster/${data.aws_eks_cluster.cluster.id}"
      values   = ["owned"]
    }
  }

  statement {
    actions = [
      "ec2:RunInstances",
      "ec2:CreateFleet",
      "ec2:CreateLaunchTemplate"
    ]

    effect = "Allow"
    resources = [
      "arn:aws:ec2:${var.aws_region}:*:fleet/*",
      "arn:aws:ec2:${var.aws_region}:*:instance/*",
      "arn:aws:ec2:${var.aws_region}:*:volume/*",
      "arn:aws:ec2:${var.aws_region}:*:network-interface/*",
      "arn:aws:ec2:${var.aws_region}:*:launch-template/*",
      "arn:aws:ec2:${var.aws_region}:*:spot-instances-request/*"
    ]

    sid = "AllowScopedEC2InstanceActionsWithTags"
    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/kubernetes.io/cluster/${data.aws_eks_cluster.cluster.id}"
      values   = ["owned"]
    }
  }

  statement {
    actions = [
      "ec2:CreateTags"
    ]

    effect = "Allow"
    resources = [
      "arn:aws:ec2:${var.aws_region}:*:fleet/*",
      "arn:aws:ec2:${var.aws_region}:*:instance/*",
      "arn:aws:ec2:${var.aws_region}:*:volume/*",
      "arn:aws:ec2:${var.aws_region}:*:network-interface/*",
      "arn:aws:ec2:${var.aws_region}:*:launch-template/*",
      "arn:aws:ec2:${var.aws_region}:*:spot-instances-request/*"
    ]

    sid = "AllowScopedResourceCreationTagging"
    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/kubernetes.io/cluster/${data.aws_eks_cluster.cluster.id}"
      values   = ["owned"]
    }
    condition {
      test     = "StringEquals"
      variable = "ec2:CreateAction"
      values = [
        "RunInstances",
        "CreateFleet",
        "CreateLaunchTemplate"
      ]
    }
  }

  statement {
    actions = [
      "ec2:CreateTags"
    ]

    effect = "Allow"
    resources = [
      "arn:aws:ec2:${var.aws_region}:*:instance/*"
    ]

    sid = "AllowScopedResourceTagging"
    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/kubernetes.io/cluster/${data.aws_eks_cluster.cluster.id}"
      values   = ["owned"]
    }
  }

  statement {
    actions = [
      "ec2:TerminateInstances",
      "ec2:DeleteLaunchTemplate"
    ]

    effect = "Allow"
    resources = [
      "arn:aws:ec2:${var.aws_region}:*:instance/*",
      "arn:aws:ec2:${var.aws_region}:*:launch-template/*"
    ]

    sid = "AllowScopedDeletion"
    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/kubernetes.io/cluster/${data.aws_eks_cluster.cluster.id}"
      values   = ["owned"]
    }
  }

  statement {
    actions = [
      "ec2:DescribeAvailabilityZones",
      "ec2:DescribeImages",
      "ec2:DescribeInstances",
      "ec2:DescribeInstanceTypeOfferings",
      "ec2:DescribeInstanceTypes",
      "ec2:DescribeLaunchTemplates",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSpotPriceHistory",
      "ec2:DescribeSubnets"
    ]

    effect    = "Allow"
    resources = ["*"]

    sid = "AllowRegionalReadActions"
    condition {
      test     = "StringEquals"
      variable = "aws:RequestedRegion"
      values   = ["${var.aws_region}"]
    }
  }

  statement {
    actions = [
      "ssm:GetParameter"
    ]

    effect    = "Allow"
    resources = ["arn:aws:ssm:${var.aws_region}::parameter/aws/service/*"]

    sid = "AllowSSMReadActions"
  }

  statement {
    actions = [
      "pricing:GetProducts"
    ]

    effect    = "Allow"
    resources = ["*"]

    sid = "AllowPricingReadActions"
  }

  statement {
    actions = [
      "sqs:DeleteMessage",
      "sqs:GetQueueUrl",
      "sqs:ReceiveMessage"
    ]

    effect    = "Allow"
    resources = ["${aws_sqs_queue.node_interruption_queue.arn}"]

    sid = "AllowInterruptionQueueActions"
  }

  statement {
    actions = ["iam:PassRole"]

    effect    = "Allow"
    resources = ["*"] #TODO - GET THE ROLE ARN FROM THE NODEGROUP
    sid       = "AllowPassingInstanceRole"
    condition {
      test     = "StringEquals"
      variable = "iam:PassedToService"
      values = [
        "ec2.amazonaws.com"
      ]
    }
  }

  statement {
    sid       = "AllowScopedInstanceProfileCreationActions"
    effect    = "Allow"
    resources = ["*"]
    actions   = ["iam:CreateInstanceProfile"]

    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/kubernetes.io/cluster/${data.aws_eks_cluster.cluster.id}"
      values   = ["owned"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/topology.kubernetes.io/region"
      values   = ["${var.aws_region}"]
    }
  }

  statement {
    sid       = "AllowScopedInstanceProfileTagActions"
    effect    = "Allow"
    resources = ["*"]
    actions   = ["iam:TagInstanceProfile"]

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/kubernetes.io/cluster/${data.aws_eks_cluster.cluster.id}"
      values   = ["owned"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/topology.kubernetes.io/region"
      values   = ["${var.aws_region}"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/kubernetes.io/cluster/${data.aws_eks_cluster.cluster.id}"
      values   = ["owned"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/topology.kubernetes.io/region"
      values   = ["${var.aws_region}"]
    }
  }

  statement {
    sid       = "AllowScopedInstanceProfileActions"
    effect    = "Allow"
    resources = ["*"]
    actions = [
      "iam:AddRoleToInstanceProfile",
      "iam:RemoveRoleFromInstanceProfile",
      "iam:DeleteInstanceProfile"
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/kubernetes.io/cluster/${data.aws_eks_cluster.cluster.id}"
      values   = ["owned"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/topology.kubernetes.io/region"
      values   = ["${var.aws_region}"]
    }
  }

  statement {
    actions = ["eks:DescribeCluster"]

    effect    = "Allow"
    resources = ["arn:aws:eks:${var.aws_region}:${data.aws_caller_identity.current.account_id}:cluster/${data.aws_eks_cluster.cluster.id}"]
    sid       = "EKSClusterEndpointLookup"
  }

  statement {
    sid       = "AllowInstanceProfileReadActions"
    effect    = "Allow"
    resources = ["*"]
    actions   = ["iam:GetInstanceProfile"]
  }
}

# Create an IAM policy for the Karpenter controller, granting necessary permissions for managing EKS nodes
resource "aws_iam_policy" "karpenter_controller_policy" {
  name        = "${data.aws_eks_cluster.cluster.id}-karpenter-controller-${random_string.random.result}"
  description = "karpenter policy for cluster ${data.aws_eks_cluster.cluster.id}"
  policy      = data.aws_iam_policy_document.karpenter_controller_policy_document.json
}

# Configure the OIDC provider for Karpenter to enable integration with EKS
module "karpenter_oidc" {
  source = "./modules/aws_oidc"

  providers = {
    kubernetes = kubernetes.eks_e6data
  }

  tls_url      = data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer
  policy_arn   = [aws_iam_policy.karpenter_controller_policy.arn]
  eks_oidc_arn = data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer

  oidc_role_name = "${data.aws_eks_cluster.cluster.id}-karpenter"

  kubernetes_namespace            = var.karpenter_namespace
  kubernetes_service_account_name = var.karpenter_service_account_name
  workspace_name                  = var.workspace_name

  depends_on = [aws_iam_policy.karpenter_controller_policy]
}

# Deploy Karpenter in the specified Kubernetes namespace to manage EKS node provisioning
module "karpeneter_deployment" {
  providers = {
    kubernetes = kubernetes.eks_e6data
    helm       = helm.eks_e6data
  }

  source = "./modules/karpenter"

  karpenter_release_version = var.karpenter_release_version

  namespace               = module.karpenter_oidc.kubernetes_namespace
  eks_cluster_name        = data.aws_eks_cluster.cluster.id
  eks_endpoint            = data.aws_eks_cluster.cluster.endpoint
  service_account_name    = module.karpenter_oidc.service_account_name
  controller_role_arn     = module.karpenter_oidc.oidc_role_arn
  interruption_queue_name = aws_sqs_queue.node_interruption_queue.name

  depends_on = [module.karpenter_oidc, aws_sqs_queue.node_interruption_queue]
}

data "aws_availability_zones" "available" {
  state         = "available"
  exclude_names = var.excluded_az
}

# Data source to fetch and template Karpenter provisioner manifests
data "kubectl_path_documents" "provisioner_manifests" {
  pattern = "./karpenter-provisioner-manifests/*.yaml"
  vars = {
    workspace_name           = var.workspace_name
    available_zones          = jsonencode(data.aws_availability_zones.available.names)
    cluster_name             = var.eks_cluster_name
    instance_family          = jsonencode(var.nodepool_instance_family)
    karpenter_node_role_name = basename(data.aws_eks_node_group.node_group.node_role_arn)
    volume_size              = var.eks_disk_size
    nodeclass_name           = local.e6data_nodeclass_name
    nodepool_name            = local.e6data_nodepool_name
    tags = jsonencode(
      merge(
        var.cost_tags,
        {
          "Name" = local.e6data_workspace_name
        }
      )
    )
    nodepool_cpu_limits = var.nodepool_cpu_limits
  }
  depends_on = [data.aws_availability_zones.available, module.karpeneter_deployment]
}

resource "kubectl_manifest" "provisioners" {
  count     = 2
  yaml_body = values(data.kubectl_path_documents.provisioner_manifests.manifests)[count.index]

  depends_on = [data.kubectl_path_documents.provisioner_manifests, module.karpeneter_deployment]
}