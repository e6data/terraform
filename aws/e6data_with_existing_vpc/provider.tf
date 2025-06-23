# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
  # access_key = "<Access key ID>"
  # secret_key = "<Secret access key>"
  default_tags {
    tags = var.cost_tags
  }
}

terraform {
  # backend "s3" {
  #   bucket = "mybucket"
  #   key    = "path/to/my/key"
  #   region = "us-east-1"
  # }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.35.0"
    }

    kubectl = {
      source  = "alekc/kubectl"
      version = "2.0.4"
    }
    
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}






provider "aws" {
  region = "us-east-1"
}

data "aws_eks_cluster" "e6data" {
  name = "e6data-nonatcpp"
}

data "aws_eks_cluster_auth" "e6data" {
  name = data.aws_eks_cluster.e6data.name
}

provider "kubernetes" {
  alias                   = "e6data"
  host                    = "https://vpce-00ed8a0bd90bd659f-rodosog9.vpce-svc-00a0b40ce97c9fa1a.us-east-1.vpce.amazonaws.com"
  token                   = data.aws_eks_cluster_auth.e6data.token
  cluster_ca_certificate  = null
  insecure                = true
}

provider "kubectl" {
  host                   = "https://vpce-00ed8a0bd90bd659f-rodosog9.vpce-svc-00a0b40ce97c9fa1a.us-east-1.vpce.amazonaws.com"
  token                  = data.aws_eks_cluster_auth.e6data.token
  cluster_ca_certificate = null
  load_config_file	 = false
  insecure                = true
}

provider "helm" {
  alias = "e6data"
  kubernetes {
    host                   = "https://vpce-00ed8a0bd90bd659f-rodosog9.vpce-svc-00a0b40ce97c9fa1a.us-east-1.vpce.amazonaws.com"
    token                  = data.aws_eks_cluster_auth.e6data.token
    cluster_ca_certificate = null
    insecure               = true
  }
}