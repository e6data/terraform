resource "kubernetes_daemon_set_v1" "gke_raid_disks" {
  provider = kubernetes.gke_e6data

  metadata {
    name      = "e6data-gke-raid-disks"
    namespace = var.kubernetes_namespace
    labels = {
      k8s-app = "e6data-gke-raid-disks"
    }
  }

  spec {
    selector {
      match_labels = {
        name = "e6data-gke-raid-disks"
      }
    }

    template {
      metadata {
        labels = {
          name = "e6data-gke-raid-disks"
        }
      }

      spec {
        node_selector = {
          "cloud.google.com/gke-local-nvme-ssd" = "true"
        }

        host_pid = true

        container {
          name  = "startup-script"
          image = "gcr.io/google-containers/startup-script:v1"

          security_context {
            privileged = true
          }

          env {
            name  = "STARTUP_SCRIPT"
            value = file("${path.module}/scripts/startup.sh")
          }
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
}
