module "eks" {
  source = "./eks"
  cluster_name     = var.cluster_name
  kube_version     = var.kube_version
  cluster_log_types = var.cluster_log_types

  subnet_ids       = var.subnet_ids
  private_subnet_ids = var.private_subnet_ids

  min_size = var.min_size
  desired_size = var.desired_size
  max_size = var.max_size
  
  instance_type = var.instance_type
  disk_size = var.disk_size

  vpc_id = var.vpc_id
  capacity_type = var.capacity_type

  depends_on = [aws_ebs_encryption_by_default.enable_enc]
}

resource "aws_ebs_encryption_by_default" "enable_enc" {
  enabled = true
}

module "eks_tags" {
  source = "./eks_tags"

  for_each = var.cost_tags
  
  autoscaling_group_name = module.eks.nodegroup_asg_name
  tag_key = each.key
  tag_value = each.value

  depends_on = [ module.eks ]
}

data "aws_eks_cluster_auth" "apps_eks_auth" {
  name = module.eks.cluster_name

  depends_on = [module.eks]
}

provider "kubernetes" {
  alias                  = "e6data"
  host                   = module.eks.eks_endpoint
  cluster_ca_certificate = base64decode(module.eks.eks_certificate_data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
    command     = var.aws_command_line_path
  }
}

provider "helm" {
  alias          = "e6data"
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

resource "kubernetes_namespace" "e6data_namespace" {
  provider   = kubernetes.e6data
  for_each   = var.e6data_namespaces

  metadata {
    annotations = {
      name = each.key
    }
    name = each.key
  }

  depends_on = [module.eks]
}


module "autoscaler_oidc" {
  source = "./aws_oidc"

  providers = {
    kubernetes = kubernetes.e6data
  }

  tls_url = module.eks.eks_oidc_tls
  policy_arn = [aws_iam_policy.cluster_autoscaler.arn]
  eks_oidc_arn = module.eks.oidc_arn

  oidc_role_name = "${module.eks.cluster_name}-autoscaler"

  kubernetes_namespace = var.autoscaler_namespace
  kubernetes_service_account_name = var.autoscaler_service_account_name

  depends_on = [aws_iam_policy.cluster_autoscaler]
}



module "autoscaler_deployment" {
  providers = {
    kubernetes = kubernetes.e6data
    helm       = helm.e6data
  }

  source = "./autoscaler"

  helm_chart_name = var.autoscaler_helm_chart_name
  helm_chart_version = var.autoscaler_helm_chart_version
  
  namespace = module.autoscaler_oidc.kubernetes_namespace
  service_account_name = module.autoscaler_oidc.service_account_name  
  cluster_name = module.eks.cluster_name
  region = var.aws_region
  
  depends_on = [module.eks, module.autoscaler_oidc]
}