data "azurerm_kubernetes_cluster" "aks_e6data" {
  name                = var.aks_cluster_name
  resource_group_name = var.aks_resource_group_name
}

data "azurerm_resources" "aks_sg" {
  type = "Microsoft.Network/networkSecurityGroups"

  resource_group_name = data.azurerm_kubernetes_cluster.aks_e6data.node_resource_group

  depends_on = [ data.azurerm_kubernetes_cluster.aks_e6data ]
}

provider "kubernetes" {
  alias                  = "e6data"
  host                   = data.azurerm_kubernetes_cluster.aks_e6data.kube_config.0.host
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.aks_e6data.kube_config.0.cluster_ca_certificate)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "kubelogin"
    args = [
      "get-token",
      "--login",
      "azurecli",
      "--environment",
      "AzurePublicCloud",
      "--tenant-id",
      data.azurerm_client_config.current.tenant_id,
      "--server-id",
      "6dae42f8-4368-4678-94ff-3960e28e3630",
      "|",
      "jq",
      ".status.token"
    ]
  }
}

provider "helm" {
  alias = "e6data"
  kubernetes {
    host                   = data.azurerm_kubernetes_cluster.aks_e6data.kube_config.0.host
    cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.aks_e6data.kube_config.0.cluster_ca_certificate)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "kubelogin"
      args = [
        "get-token",
        "--login",
        "azurecli",
        "--environment",
        "AzurePublicCloud",
        "--tenant-id",
        data.azurerm_client_config.current.tenant_id,
        "--server-id",
        "6dae42f8-4368-4678-94ff-3960e28e3630",
        "|",
        "jq",
        ".status.token"
      ]
    }
  }
}

provider "kubectl" {
  host                   = data.azurerm_kubernetes_cluster.aks_e6data.kube_config.0.host
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.aks_e6data.kube_config.0.cluster_ca_certificate)
  load_config_file       = false
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "kubelogin"
    args = [
      "get-token",
      "--login",
      "azurecli",
      "--environment",
      "AzurePublicCloud",
      "--tenant-id",
      data.azurerm_client_config.current.tenant_id,
      "--server-id",
      "6dae42f8-4368-4678-94ff-3960e28e3630",
      "|",
      "jq",
      ".status.token"
    ]
  }
}

resource "kubernetes_namespace" "e6data_namespace" {
  provider = kubernetes.e6data

  metadata {
    annotations = {
      name = var.kubernetes_namespace
    }
    name = var.kubernetes_namespace
  }

  depends_on = [data.azurerm_kubernetes_cluster.aks_e6data]
}

data "kubernetes_resources" "bootstrap" {
  provider = kubernetes.e6data
  api_version    = "v1"
  kind           = "Secret"
  namespace      = "kube-system"
  field_selector = "type==bootstrap.kubernetes.io/token"

  depends_on = [ data.azurerm_kubernetes_cluster.aks_e6data ]
}