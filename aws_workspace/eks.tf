module "eks" {
  source = "./modules/eks"
  cluster_name     = var.cluster_name
  kube_version     = var.kube_version
  cluster_log_types = var.cluster_log_types

  subnet_ids       = module.network.subnet_ids
  private_subnet_ids = module.network.private_subnet_ids

  min_size = var.min_desired_instances_in_eks_nodegroup
  desired_size = var.min_desired_instances_in_eks_nodegroup
  max_size = var.max_instances_in_eks_nodegroup
  
  instance_type = var.eks_nodegroup_instance_types
  disk_size = var.eks_disk_size

  vpc_id = module.network.vpc_id
  capacity_type = var.eks_capacity_type

  depends_on = [aws_ebs_encryption_by_default.enable_enc]
}

resource "aws_ebs_encryption_by_default" "enable_enc" {
  enabled = true
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

