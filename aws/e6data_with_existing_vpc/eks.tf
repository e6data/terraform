module "eks" {
  source                           = "./modules/eks"
  cluster_name                     = var.cluster_name
  kube_version                     = var.kube_version
  cluster_log_types                = var.cluster_log_types
  cloudwatch_log_retention_in_days = var.cloudwatch_log_retention_in_days
  security_group_ids               = [module.security_group.security_group_id]
  subnet_ids                       = module.network.subnet_ids
  private_subnet_ids               = module.network.private_subnet_ids
  public_access_cidrs              = var.public_access_cidrs
  endpoint_private_access          = var.endpoint_private_access
  endpoint_public_access           = var.endpoint_public_access
  vpc_id                           = module.network.vpc_id

  depends_on = [module.network]
}

resource "aws_ec2_tag" "cluster_primary_security_group" {
  resource_id = module.eks.cluster_primary_security_group_id
  key         = "app"
  value       = "e6data"
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

provider "kubectl" {
  host                   = module.eks.eks_endpoint
  cluster_ca_certificate = base64decode(module.eks.eks_certificate_data)
  load_config_file       = false
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
    command     = var.aws_command_line_path
  }
}

provider "helm" {
  alias = "e6data"
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

