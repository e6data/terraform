resource "aws_ec2_tag" "karpenter_subnet_cluster_tag" {
  count    =    length(module.network.public_subnet_ids)
  resource_id = module.network.public_subnet_ids[count.index]
  key         = "karpenter.sh/discovery"
  value       = module.eks.cluster_name
}

resource "aws_ec2_tag" "karpenter_private_subnet_cluster_tag" {
  count    =    length(module.network.private_subnet_ids)
  resource_id = module.network.private_subnet_ids[count.index]
  key         = "karpenter.sh/discovery"
  value       = module.eks.cluster_name
}

data "aws_iam_policy_document" "karpenter_node_trust_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "karpenter_node_role" {
  name = "e6data-${var.cluster_name}-KarpenterNodeRole"
  managed_policy_arns = var.karpenter_eks_node_policy_arn
  assume_role_policy = data.aws_iam_policy_document.karpenter_node_trust_policy.json
}

data "aws_iam_policy_document" "karpenter_controller_policy_document" {
  statement {
    actions = [
      "ssm:GetParameter",
      "ec2:DescribeImages",
      "ec2:RunInstances",
      "ec2:DescribeSubnets",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeLaunchTemplates",
      "ec2:DescribeInstances",
      "ec2:DescribeInstanceTypes",
      "ec2:DescribeInstanceTypeOfferings",
      "ec2:DescribeAvailabilityZones",
      "ec2:DeleteLaunchTemplate",
      "ec2:CreateTags",
      "ec2:CreateLaunchTemplate",
      "ec2:CreateFleet",
      "ec2:DescribeSpotPriceHistory",
      "pricing:GetProducts",
    ]
    
    effect    = "Allow"
    resources = ["*"]
    sid       = "Karpenter"
  }
  
  statement {
    actions = ["sqs:DeleteMessage","sqs:GetQueueUrl","sqs:ReceiveMessage"]
    effect = "Allow"
    resources = ["${aws_sqs_queue.node_interruption_queue.arn}"]
    sid = "AllowInterruptionQueueActions"
  }

  statement {
    actions = ["ec2:TerminateInstances"]
    
    effect = "Allow"
    resources = ["*"]
    sid = "ConditionalEC2Termination"
    
    condition {
      test     = "StringLike"
      variable = "ec2:ResourceTag/karpenter.sh/nodepool"
      values   = [local.e6data_nodepool_name]
    }
  }

  statement {
    actions = ["iam:PassRole"]
    
    effect = "Allow"
    resources = ["${aws_iam_role.karpenter_node_role.arn}"]
    sid = "PassNodeIAMRole"
  }

  statement {
    actions = ["eks:DescribeCluster"]
    
    effect = "Allow"
    resources = ["arn:aws:eks:${var.aws_region}:${data.aws_caller_identity.current.account_id}:cluster/${module.eks.cluster_name}"]
    sid = "EKSClusterEndpointLookup"
  }

  statement {
    sid       = "AllowScopedInstanceProfileCreationActions"
    effect    = "Allow"
    resources = ["*"]
    actions = ["iam:CreateInstanceProfile"]

    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/kubernetes.io/cluster/${module.eks.cluster_name}"
      values   = ["owned"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/topology.kubernetes.io/region"
      values   = ["${var.aws_region}"]
    }

    condition {
      test     = "StringLike"
      variable = "aws:RequestTag/karpenter.k8s.aws/ec2nodeclass"
      values   = [local.e6data_nodeclass_name]
    }
  }

  statement {
    sid       = "AllowScopedInstanceProfileTagActions"
    effect    = "Allow"
    resources = ["*"]
    actions = ["iam:TagInstanceProfile"]

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/kubernetes.io/cluster/${module.eks.cluster_name}"
      values   = ["owned"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/topology.kubernetes.io/region"
      values   = ["${var.aws_region}"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/kubernetes.io/cluster/${module.eks.cluster_name}"
      values   = ["owned"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/topology.kubernetes.io/region"
      values   = ["${var.aws_region}"]
    }

    condition {
      test     = "StringLike"
      variable = "aws:ResourceTag/karpenter.k8s.aws/ec2nodeclass"
      values   = [local.e6data_nodeclass_name]
    }

    condition {
      test     = "StringLike"
      variable = "aws:RequestTag/karpenter.k8s.aws/ec2nodeclass"
      values   = [local.e6data_nodeclass_name]
    }
  }

  statement {
    sid       = "AllowScopedInstanceProfileActions"
    effect    = "Allow"
    resources = ["*"]
    actions = [
      "iam:AddRoleToInstanceProfile",
      "iam:RemoveRoleFromInstanceProfile",
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/kubernetes.io/cluster/${module.eks.cluster_name}"
      values   = ["owned"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/topology.kubernetes.io/region"
      values   = ["${var.aws_region}"]
    }

    condition {
      test     = "StringLike"
      variable = "aws:ResourceTag/karpenter.k8s.aws/ec2nodeclass"
      values   = [local.e6data_nodeclass_name]
    }
  }

  statement {
    sid       = "AllowInstanceProfileReadActions"
    effect    = "Allow"
    resources = ["*"]
    actions = ["iam:GetInstanceProfile"]
  }
}

resource "aws_iam_policy" "karpenter_controller_policy" {
  name = "${module.eks.cluster_name}-karpenter-controller-policy"
  description = "karpenter policy for cluster ${module.eks.cluster_name}"
  policy      = data.aws_iam_policy_document.karpenter_controller_policy_document.json
}

module "karpenter_oidc" {
  source = "./modules/aws_oidc"

  providers = {
    kubernetes = kubernetes.e6data
  }

  tls_url = module.eks.eks_oidc_tls
  policy_arn = [aws_iam_policy.karpenter_controller_policy.arn]
  eks_oidc_arn = module.eks.oidc_arn

  oidc_role_name = "${module.eks.cluster_name}-karpenter"

  kubernetes_namespace = var.karpenter_namespace
  kubernetes_service_account_name = var.karpenter_service_account_name

  depends_on = [aws_iam_policy.karpenter_controller_policy, aws_eks_node_group.default_node_group]
}

module "karpeneter_deployment" {
  providers = {
    kubernetes = kubernetes.e6data
    helm       = helm.e6data
  }

  source = "./modules/karpenter"

  karpenter_release_version = var.karpenter_release_version
  
  namespace = module.karpenter_oidc.kubernetes_namespace
  eks_cluster_name = module.eks.cluster_name
  eks_endpoint = module.eks.eks_endpoint
  service_account_name = module.karpenter_oidc.service_account_name
  controller_role_arn = module.karpenter_oidc.oidc_role_arn
  interruption_queue_name = aws_sqs_queue.node_interruption_queue.name
   
  controller_memory_limits = "1Gi"
  controller_cpu_limits    = "1"
  controller_memory_requests = "1Gi"
  controller_cpu_requests    = "1"

  depends_on = [module.eks, module.karpenter_oidc, aws_eks_node_group.default_node_group, aws_sqs_queue.node_interruption_queue]
}

data "aws_availability_zones" "available" {
  state = "available"
  exclude_names = var.excluded_az
}

data "kubectl_path_documents" "provisioner_manifests" {
  pattern = "./karpenter-provisioner-manifests/*.yaml"
  vars = {
    cluster_name           = var.cluster_name
    workspace_name         = var.workspace_name
    available_zones        = jsonencode(data.aws_availability_zones.available.names)
    cluster_name           = module.eks.cluster_name
    instance_family        = jsonencode(var.nodepool_instance_family)
    karpenter_node_role_name = aws_iam_role.karpenter_node_role.name
    volume_size            = var.eks_disk_size
    nodeclass_name         = local.e6data_nodeclass_name
    nodepool_name          = local.e6data_nodepool_name
    tags                   = jsonencode(var.cost_tags)
  } 
}

resource "kubectl_manifest" "provisioners" {
  count     = 2
  yaml_body = values(data.kubectl_path_documents.provisioner_manifests.manifests)[count.index]

  depends_on = [ module.karpeneter_deployment ]
}