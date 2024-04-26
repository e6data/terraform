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

resource "helm_release" "local_volume_provisioner_release" {
  name = "e6data-local-static-provisioner"
  chart = "e6data-local-static-provisioner"
  repository = "https://kubernetes-sigs.github.io/sig-storage-local-static-provisioner"
  version = var.local_volume_provisioner_release_version
  namespace = var.namespace
  timeout = 600

  set {
    name  = "affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions[0].key"
    value = "karpenter.k8s.aws/instance-local-nvme"
  }
  set {
    name  = "affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions[0].operator"
    value = "Exists"
  }

  set {
    name  = "nameOverride"
    value = "e6data-${var.workspace_name}"
  }

  set {
    name  = "classes[0].name"
    value = "fast-disks"
  }

  set {
    name  = "classes[0].hostDir"
    value = "/mnt/fast-disks"
  }

  set {
    name  = "classes[0].volumeMode"
    value = "Filesystem"
  }

  set {
    name  = "classes[0].name"
    value = "e6data-fast-disks"
  }

  set {
    name  = "classes[0].fsType"
    value = "ext4"
  }

  set {
    name  = "classes[0].namePattern"
    value = "*"
  }

  set {
    name  = "classes[0].allowedTopologies[0]"
    value = "/scripts/shred.sh"
  }

  set {
    name  = "classes[0].allowedTopologies[1]"
    value = "2"
  }

  set {
    name  = "classes[0].storageClass"
    value = "true"
  }
}
