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
  name = var.helm_chart_name
  repository = "https://kubernetes.github.io/autoscaler"
  chart = "cluster-autoscaler"
  namespace = var.namespace
  version    = var.helm_chart_version
  timeout = 600

  set {
    name = "autoDiscovery.clusterName"
    value = var.cluster_name
  }

  set {
    name  = "autoscalingGroupsnamePrefix[0].name"
    value = "gke-${substr(var.cluster_name, 0, 14)}"
  }

  set {
    name  = "autoscalingGroupsnamePrefix[0].maxSize"
    value = "10"
  }

  set {
    name  = "autoscalingGroupsnamePrefix[0].minSize"
    value = "1"
  }

  set {
    name = "cloudProvider"
    value = "gce"
  }

  set {
    name = "extraArgs.ignore-daemonsets-utilization"
    value = "true"
  }

  set {
    name = "extraArgs.scan-interval"
    value = "10s"
  }

  set {
    name = "extraArgs.leader-elect"
    value = false
  }

  set {
    name = "extraArgs.scale-down-unneeded-time"
    value = "3m"
  }

  set {
    name = "extraArgs.scale-down-unready-time"
    value = "3m"
  }

  set {
    name = "extraArgs.scale-down-utilization-threshold"
    value = "0.2"
  } 

  set {
    name = "extraArgs.scale-down-delay-after-add"
    value = "3m"
  }

  set {
    name = "extraArgs.scale-down-delay-after-delete"
    value = "3m"
  }

  set {
    name = "extraArgs.ignore-daemonsets-utilization"
    value = "true"
  }

  set {
    name = "rbac.serviceAccount.create"
    value = false
  }

  set {
    name = "rbac.serviceAccount.name"
    value = kubernetes_service_account.cluster_autoscaler.metadata.0.name
  }

  set {
    name = "tolerations[0].key"
    value = var.tolerations_key
  }

  set {
    name = "tolerations[0].operator"
    value = "Equal"
  }

  set {
    name = "tolerations[0].value"
    value = var.tolerations_value
  }

  set {
    name = "tolerations[0].effect"
    value = "NoSchedule"
  }

  depends_on = [null_resource.waiting, google_service_account.cluster_autoscaler, kubernetes_service_account.cluster_autoscaler]
}