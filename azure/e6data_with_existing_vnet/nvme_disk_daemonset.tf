resource "kubernetes_daemon_set_v1" "aks_raid_disks" {
  provider = kubernetes.e6data

  metadata {
    name      = "nvme-raid-disks"
    namespace = var.kubernetes_namespace
    labels = {
      k8s-app = "nvme-raid-disks"
    }
  }

  spec {
    selector {
      match_labels = {
        name = "nvme-raid-disks"
      }
    }

    template {
      metadata {
        labels = {
          name = "nvme-raid-disks"
        }
      }

      spec {
        automount_service_account_token = false
        priority_class_name = "system-node-critical"

        node_selector = {
          "app" = "e6data",
          "e6data-workspace-name" = var.workspace_name
        }

        image_pull_secrets {
          name = "e6data-reg-cred"
        }

        container {
          name  = "startup-script"
          image = "us-docker.pkg.dev/e6data-analytics/e6-engine/az-nvme-provisioner:3.0.5-e4fd230d"
          image_pull_policy = "Always"

          security_context {
            privileged = true
          }

          volume_mount {
            mount_path        = "/tmp"
            name              = "tmp-volume"
            mount_propagation = "Bidirectional"
          }
        }

        volume {
          name = "tmp-volume"
          host_path {
            path = "/tmp"
          }
        }

        toleration {
          key      = "kubernetes.azure.com/scalesetpriority"
          operator = "Equal"
          value    = "spot"
          effect   = "NoSchedule"
        }

        toleration {
          key      = "e6data-workspace-name"
          operator = "Equal"
          value    = var.workspace_name
          effect   = "NoSchedule"
        }
      }
    }
  }
  depends_on = [ helm_release.workspace_deployment ]
}
