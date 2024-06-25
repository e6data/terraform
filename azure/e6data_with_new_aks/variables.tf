variable "subscription_id" {
  type        = string
  description = "The subscription ID of the Azure subscription in which the e6data resources will be deployed."
  default     = "2b69ff5f-bcfa-4f86-a43c-c06ca182c584"
}

variable "workspace_name" {
  type        = string
  description = "Name of the e6data workspace to be created.."
  default     = "har"
}

variable "e6data_app_secret_expiration_time" {
  type        = string
  description = "A relative duration for which the password is valid until, for example 240h (10 days) or 2400h30m."
  default     = "3600h"
}

variable "aks_cluster_name" {
  type        = string
  description = "The name of your Azure Kubernetes Service (AKS) cluster in which to deploy the e6data workspace."
  default     = "testpoc"
}

variable "aks_resource_group_name" {
  type        = string
  description = "The name of the resource group where the AKS cluster is deployed."
  default     = "test123"
}

variable "vnet_name" {
  type        = string
  description = "The vnet where the AKS cluster is deployed."
}

variable "subnet_name" {
  type        = string
  description = "The subnet where the AKS cluster is deployed."
}

variable "vm_size" {
  type        = string
  description = "The VM size for the AKS node pool.(for example Standard_DS2_v2)"
  default     = "Standard_DS2_v2"
}

variable "min_number_of_nodes" {
  type        = number
  description = "The minimum number of nodes in the AKS node pool."
  default     = 1
}

variable "max_number_of_nodes" {
  type        = number
  description = "The maximum number of nodes in the AKS node pool."
  default     = 2
}

variable "kubernetes_namespace" {
  type        = string
  description = "The namespace in the AKS cluster to deploy e6data workspace."
  default     = "default"
}

variable "data_resource_group_name" {
  type        = string
  description = "The name of the resource group containing data to be queried."
  default     = "data-rg"
}

variable "data_storage_account_name" {
  type        = string
  description = "The name of the storage account containing data to be queried."
  default     = "data-storage-account"
}

variable "list_of_containers" {
  type        = list(string)
  description = "List of names of the containers inside the data storage account, that the 6data engine queries and require read access to."
  default     = ["*"]
}

variable "helm_chart_version" {
  type        = string
  description = "The version of the e6data helm chart to be deployed."
  default     = "1.0.2"
}

variable "zones" {
  type        = list(string)
  description = "Specifies a list of Availability Zones in which this Kubernetes Cluster Node Pool should be located"
  default     = ["1","2","3"]
}

variable "kube_version" {
  type        = string
  description = "Version of Kubernetes used for the Agents"
  default     = "1.26.6"
}

variable "priority" {
  type        = string
  description = "Regular/Spot"
  default     = "Spot"
}


variable "eviction_policy" {
  type        = string
  description = "Deallocate/Delete"
  default     = "Deallocate"
}

variable "prefix" {
  type        = string
  description = "AZURE resource name prefix"
}

variable "region" {
  type        = string
  description = "AZURE region"
}

variable "cost_tags" {
  type        = map(string)
  description = "cost tags"
}

variable "enable_auto_scaling" {
  type        = bool
  description = "enable autoscaling in dev nodepool."
}

variable "min_size" {
  type        = number
  description = "The minimum number of nodes in the dev AKS node pool."
}

variable "max_size" {
  type        = number
  description = "The maximum number of nodes in the dev AKS node pool."
}

variable "spot_max_price" {
  type        = number
  description = "maximum Spot price"
  default     = -1
}

variable "spot_eviction_policy" {
  type        = string
  description = "Deallocate/Delete"
  default     = "Deallocate"
}


variable "cidr_block" {
  type        = list(string)
  description = "Base CIDR block which will be divided into subnet CIDR blocks (e.g. `10.0.0.0/16`)"
}


variable "private_cluster_enabled" {
  type        = string
  description = "enable private cluster"
}

# Default Node pool Variables
variable "default_node_pool_min_size" {
  type        = number
  description = "The minimum number of nodes in the default AKS node pool."
  default     = 1
}

variable "default_node_pool_max_size" {
  type        = number
  description = "The maximum number of nodes in the default AKS node pool."
}

variable "default_node_pool_name" {
  type        = string
  description = "The name of the default AKS node pool."
}

variable "default_node_pool_vm_size" {
  type        = string
  description = "The size of the default AKS node pool vm."
}

variable "default_node_pool_node_count" {
  type        = string
  description = "The node pool count of default nodepool"
}


## default nodegroup auto scaler profile
variable "scale_down_unneeded" {
  type        = string
  description = "How long a node should be unneeded before it is eligible for scale down."
}
variable "scale_down_delay_after_add" {
  type        = string
  description = "How long after the scale up of AKS nodes the scale down evaluation resumes."
}
variable "scale_down_unready" {
  type        = string
  description = "How long an unready node should be unneeded before it is eligible for scale down."
}
variable "scale_down_utilization_threshold" {
  type        = string
  description = "Node utilization level, defined as sum of requested resources divided by capacity, below which a node can be considered for scale down."
}

# variable "subscription_id" {
#   type        = string
#   description = "The subscription ID of the Azure subscription in which the e6data resources will be deployed."
#   default     = "2b69ff5f-bcfa-4f86-a43c-c06ca182c584"
# }



# variable "e6data_app_secret_expiration_time" {
#   type        = string
#   description = "A relative duration for which the password is valid until, for example 240h (10 days) or 2400h30m."
#   default     = "3600h"
# }

# variable "data_storage_account" {
#   type        = string
#   description = "storage account where data is present"
# }

# variable "data_resource_group" {
#   type        = string
#   description = "resource group where data is present"
# }

# ### aks cluster variables
# variable "cluster_name" {
#   type        = string
#   description = "Name of AKS cluster"
# }

# variable "kube_version" {
#   type        = string
#   description = "The Kubernetes version in cluster"
# }


# variable "resource_group_name" {
#   type        = string
#   description = "resource group name"
# }

# variable "admin_group_object_ids" {
#   type        = list(string)
#   description = "AAD groups to have admin access to the aks cluster"
#   default     = ["c436c2ee-18b7-4130-acc4-d7a01fe6ee7e"]
# }

# variable "engine_namespaces" {
#   type        = set(string)
#   description = "Namespaces to be created after cluster creation"
# }




# variable "env" {
#   type        = string
#   description = "tag prefix to be added"
# }

# variable "container_names" {
#   type        = set(string)
#   description = "container to create"
# }





# ### Nodepool variables
# variable "workspace_name" {
#   type        = string
#   description = "Name of dev workspace"
# }

# variable "vm_size" {
#   type        = string
#   description = "The VM size for the dev AKS node pool.(for example Standard_DS2_v2)"
# }



# variable "zones" {
#   type        = list(string)
#   description = "Specifies a list of Availability Zones in which the dev Cluster Node Pool should be located"
#   default     = ["1", "2", "3"]
# }

# variable "priority" {
#   type        = string
#   description = "Regular/Spot"
#   default     = "Spot"
# }



# variable "kubernetes_namespace" {
#   type        = string
#   description = "dev kubernetes namespace"
# }

# variable "helm_chart_version" {
#   type        = string
#   description = "dev helm chart version"
# }

# variable "alias" {
#   type        = string
#   description = "e6data domain name for dev environment"
# }

# variable "domain" {
#   type        = string
#   description = "e6data base domain name for dev environment"
# }



# variable "list_of_containers" {
#   type        = list(string)
#   description = "List of names of the containers inside the data storage account, that the 6data engine queries and require read access to."
#   default     = ["*"]
# }

# # SECURITY
# variable "docker_image_repository" {
#   type        = string
#   description = "Docker image repository URL"
# }

# # Docker Registry variables
# variable "image_secret_namespaces" {
#   type        = set(string)
#   description = "Namespaces to have Docker image secret"
# }

# variable "docker_project_id" {
#   type        = string
#   description = "GCP Project ID of docker images"
# }

# variable "gcp_region" {
#   type        = string
#   description = "Region for creating the resource"
# }

# variable "e6data_blob_full_access_secret_expiration_time" {
#   type        = string
#   description = "A relative duration for which the password is valid until, for example 240h (10 days) or 2400h30m."
#   default     = "7200h"
# }

# ## Helm SCP variables
# variable "helm_scp_name" {
#   type        = string
#   description = "Name of helm chart"
# }

# variable "helm_scp_namespace" {
#   type        = string
#   description = "Namespace to deploy helm chart"
# }

# variable "helm_scp_image_repository" {
#   type        = string
#   description = "Image repository"
# }

# variable "helm_scp_image_tag" {
#   type        = string
#   description = "Image tag"
# }

# variable "helm_scp_image_name" {
#   type        = string
#   description = "Image name"
# }

# variable "helm_scp_env_vars" {
#   type        = map(string)
#   description = "Environment variables"
# }

# variable "helm_scp_nodegroup" {
#   type        = string
#   description = "Environment variables"
# }

# # azure container registry variables
# variable "acr_name" {
#   type        = string
#   description = "acr name"
# }

# variable "acr_rg" {
#   type        = string
#   description = "acr resource group"
# }