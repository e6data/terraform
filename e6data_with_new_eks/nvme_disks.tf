resource "kubernetes_storage_class" "fast_disks" {
  provider =  kubernetes.e6data

  metadata {
    name = "e6data-${local.short_workspace_name}-fast-disks"
  }

  storage_provisioner           = "kubernetes.io/no-provisioner"
  volume_binding_mode           = "WaitForFirstConsumer"
}

resource "kubernetes_config_map" "local_volume_provisioner_config" {
  provider =  kubernetes.e6data

  metadata {
    name      = "e6data-${local.short_workspace_name}-local-volume-provisioner-config"
    namespace = "kube-system"
  }

  data = {
    nodeLabelsForPV = <<-EOT
      - kubernetes.io/hostname
    EOT

    storageClassMap = <<-EOT
      e6data-${local.short_workspace_name}-fast-disks:
        hostDir: /mnt/fast-disks
        mountDir: /mnt/fast-disks
        blockCleanerCommand:
          - "/scripts/shred.sh"
          - "2"
        volumeMode: Filesystem
        fsType: ext4
        namePattern: "*"
    EOT
  }
}
resource "kubernetes_daemonset" "local_volume_provisioner" {
  provider =  kubernetes.e6data

  metadata {
    name      = "local-volume-provisioner"
    namespace = "kube-system"
    labels = {
      "app.kubernetes.io/name" = "local-volume-provisioner"
    }
  }

  spec {
    selector {
      match_labels = {
        "app.kubernetes.io/name" = "local-volume-provisioner"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/name" = "local-volume-provisioner"
        }
      }

      spec {
        service_account_name = "local-volume-provisioner"

        container {
          image           = "registry.k8s.io/sig-storage/local-volume-provisioner:v2.5.0"
          image_pull_policy = "Always"
          name            = "provisioner"
          security_context {
            privileged = true
          }
          env {
            name = "MY_NODE_NAME"
            value_from {
              field_ref {
                field_path = "spec.nodeName"
              }
            }
          }
          env {
            name = "MY_NAMESPACE"
            value_from {
              field_ref {
                field_path = "metadata.namespace"
              }
            }
          }
          port {
            name          = "metrics"
            container_port = 8080
          }
          volume_mount {
            name       = "provisioner-config"
            mount_path = "/etc/provisioner/config"
            read_only  = true
          }
          volume_mount {
            mount_path         = "/mnt/fast-disks"
            name               = "e6data-${local.short_workspace_name}-fast-disks"
            mount_propagation  = "HostToContainer"
          }
        }

        volume {
          name = "provisioner-config"
          config_map {
            name = "e6data-${local.short_workspace_name}-local-volume-provisioner-config"
          }
        }

        volume {
          name = "e6data-${local.short_workspace_name}-fast-disks"
          host_path {
            path = "/mnt/fast-disks"
          }
        }

        affinity {
          node_affinity {
            required_during_scheduling_ignored_during_execution {
              node_selector_term {
                match_expressions {
                  key      = "karpenter.k8s.aws/instance-local-nvme"
                  operator = "Exists"
                }
              }
            }
          }
        }
      }
    }
  }
}
