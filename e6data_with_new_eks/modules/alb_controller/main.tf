terraform {
    required_providers {
        helm = {
            source = "hashicorp/helm"
        }
        kubernetes = {
            source = "hashicorp/kubernetes"
        }
    }
}

resource "null_resource" "waiting" {
  provisioner "local-exec" {
    command = "sleep 60"
  }
}

resource "helm_release" "alb_controller_release" {
  name = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart = "aws-load-balancer-controller"
  
  version = var.alb_ingress_controller_version
  namespace = var.namespace
  timeout = 600

  set {
    name  = "clusterName"
    value = var.eks_cluster_name
  }

  set {
    name  = "serviceAccount.create"
    value = false
  }

  set {
    name = "serviceAccount.name"
    value = var.eks_service_account_name
  }

  set {
    name = "region"
    value = var.region
  }

  set {
    name = "vpcId"
    value = var.vpc_id
  }

  set {
    name = "enableWaf"
    value = false
  }

  set {
    name = "enableShield"
    value = false
  }

  set {
    name = "enableWafv2"
    value = false
  }

  set {
    name = "nodeSelector.e6data-workspace-name"
    value = "default"
  }
}
