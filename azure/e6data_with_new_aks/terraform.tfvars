subscription_id         = "244ad77a-91e4-4a8e-9193-835d79ac55e2"
region                  = "eastus"
data_storage_account    = "e6dataengine"
data_resource_group     = "e6data-common"
cluster_name            = "engine"
kube_version            = "1.27.9"
private_cluster_enabled = "false"
resource_group_name     = "e6data-common"
admin_group_object_ids  = ["c436c2ee-18b7-4130-acc4-d7a01fe6ee7e"]
engine_namespaces       = ["perf", "dev", "tmp"]

node_label_key = "agentpool"

cost_tags = {
  Team        = "PERF"
  Operation   = "PERF-QA"
  Environment = "Dev"
  App         = "e6data"
  User        = "perf@e6x.io"
  permanent   = "true"
}

container_names = ["ci", "devcore", "regression"]

cidr_block = ["10.210.0.0/16"]
env        = "e6engine"

###Default Node pool variables
default_node_pool_min_size       = 1
default_node_pool_max_size       = 20
default_node_pool_vm_size        = "Standard_B2s"
default_node_pool_node_count     = 1
default_node_pool_name           = "default"
scale_down_unneeded              = "1m"
scale_down_unready               = "1m"
scale_down_utilization_threshold = "0.2"
scale_down_delay_after_add       = "1m"

### Dev Nodepool variables
workspace_name       = "dev"
vm_size              = "Standard_D32plds_v5"
enable_auto_scaling  = true
min_size             = 0
max_size             = 200
zones                = ["1", "2", "3"]
priority             = "Spot"
spot_max_price       = -1
spot_eviction_policy = "Deallocate"
kubernetes_namespace = "dev"
helm_chart_version   = "1.0.5"

###blob full access
e6data_blob_full_access_secret_expiration_time = "7200h"

# azure container registry variables
acr_name = "e6labs"
acr_rg   = "e6data-common"

