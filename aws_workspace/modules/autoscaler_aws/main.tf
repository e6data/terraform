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
  
  set {
    name = "extraArgs.scan-interval"
    value = "10s"
  }

  set {
    name = "extraArgs.scale-down-unneeded-time"
    value = "1m"
  }

  set {
    name = "extraArgs.scale-down-unready-time"
    value = "1m"
  }

  set {
    name = "extraArgs.scale-down-utilization-threshold"
    value = "0.2"
  } 

  set {
    name = "extraArgs.scale-down-delay-after-add"
    value = "1m"
  }

  set {
    name = "extraArgs.scale-down-delay-after-delete"
    value = "1m"
  }

  set {
    name = "extraArgs.ignore-daemonsets-utilization"
    value = "true"
  }
  
  depends_on = [null_resource.waiting]
}