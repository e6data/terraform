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

resource "helm_release" "autoscaler_deployment" {
  name = var.helm_chart_name # "autoscaler"
  repository = "https://kubernetes.github.io/autoscaler"
  chart = "cluster-autoscaler"
  namespace = var.namespace
  version    = var.helm_chart_version # "9.26.0"
  timeout = 600

  set {
    name = "rbac.serviceAccount.name"
    value = var.service_account_name
  }

  set {
    name = "autoDiscovery.clusterName"
    value = var.cluster_name
  }

  set {
    name = "awsRegion"
    value = var.region
  }

  set {
    name = "rbac.serviceAccount.create"
    value = false
  }
  
  depends_on = [null_resource.waiting]
}