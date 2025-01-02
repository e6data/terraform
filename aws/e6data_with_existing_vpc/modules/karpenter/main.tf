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

resource "helm_release" "karpenter-crd" {
  namespace        = var.namespace
  create_namespace = false
  name             = "karpenter-crd"
  repository       = "oci://public.ecr.aws/karpenter"
  chart            = "karpenter-crd"
  version          = var.karpenter_release_version
  wait             = true
}

resource "helm_release" "karpenter_release" {
  name  = "karpenter"
  chart = "karpenter"
  skip_crds = true

  repository = "oci://public.ecr.aws/karpenter"

  version   = var.karpenter_release_version
  namespace = var.namespace
  timeout   = 600

  set {
    name  = "settings.clusterName"
    value = var.eks_cluster_name
  }

  set {
    name  = "settings.interruptionQueue"
    value = var.interruption_queue_name
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = var.controller_role_arn
  }

  set {
    name  = "serviceAccount.create"
    value = false
  }
  set {
    name  = "serviceAccount.name"
    value = var.service_account_name
  }
}
