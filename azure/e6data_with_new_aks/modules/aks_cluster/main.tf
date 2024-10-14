moved {
  from = module.ssh-key.tls_private_key.ssh
  to   = tls_private_key.ssh[0]
}

resource "tls_private_key" "ssh" {
  count = var.admin_username == null ? 0 : 1

  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "azurerm_kubernetes_cluster" "aks_e6data" {
  name                              = var.cluster_name
  location                          = var.region
  resource_group_name               = var.resource_group_name
  local_account_disabled            = true
  workload_identity_enabled         = true
  oidc_issuer_enabled               = true
  dns_prefix                        = var.cluster_name
  role_based_access_control_enabled = true
  kubernetes_version                = var.kube_version

  node_os_upgrade_channel           = "None"

  linux_profile{
    admin_username = var.admin_username
      ssh_key {
        key_data = replace(coalesce(var.public_ssh_key, tls_private_key.ssh[0].public_key_openssh), "\n", "")
      }
  }

  network_profile {
    network_plugin = "azure"
    network_policy = "cilium"
    network_plugin_mode = "overlay"
    network_data_plane = "cilium"
  }

  # Enable virtual node (ACI connector) for Linux
  aci_connector_linux {
    subnet_name = var.aci_subnet_name
  }

  azure_active_directory_role_based_access_control {
    admin_group_object_ids = var.admin_group_object_ids
  }

  identity {
    type = "SystemAssigned"
  }

  default_node_pool {
    name                = var.default_node_pool_name
    vm_size             = var.default_node_pool_vm_size
    vnet_subnet_id      = var.aks_subnet_id
    node_count          = var.default_node_pool_node_count
    tags                = var.tags
    temporary_name_for_rotation = "tmpnodepool"

    upgrade_settings {
      drain_timeout_in_minutes = 0
      max_surge = "10%"
      node_soak_duration_in_minutes = 0
    }
  }
  tags = var.tags
}