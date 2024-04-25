module "local_nvme_provisioner_deployment" {
  providers = {
    kubernetes = kubernetes.e6data
    helm       = helm.e6data
  }
  source = "./modules/local_volume_provisioner"

  workspace_name = var.workspace_name
  local_volume_provisioner_release_version = var.local_volume_provisioner_release_version
}
