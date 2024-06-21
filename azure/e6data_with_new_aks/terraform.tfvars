subscription_id = "244ad77a-91e4-4a8e-9193-835d79ac55e2"
region = "eastus"
data_storage_account = "e6dataengine"
data_resource_group = "e6data-common"

cluster_name = "engine"
kube_version = "1.27.9"
private_cluster_enabled = "false"
resource_group_name = "e6data-common"
admin_group_object_ids = ["c436c2ee-18b7-4130-acc4-d7a01fe6ee7e"]
engine_namespaces = ["perf", "dev","tmp"]

node_label_key = "agentpool"

cost_tags = {
  Team = "PERF"
  Operation = "PERF-QA"
  Environment = "Dev"
  App = "e6data"
  User = "perf@e6x.io"
  permanent = "true"
}

container_names = ["ci", "devcore", "regression"]

cidr_block=["10.210.0.0/16"]
env = "e6engine"

###Default Node pool variables
default_node_pool_min_size = 1
default_node_pool_max_size = 20
default_node_pool_vm_size = "Standard_B2s"
default_node_pool_node_count = 1
default_node_pool_name    = "default"
scale_down_unneeded = "1m"
scale_down_unready = "1m"
scale_down_utilization_threshold = "0.2"
scale_down_delay_after_add = "1m"

### CI Nodepool variables
ci_workspace_name = "perf"
ci_vm_size="Standard_D32plds_v5"
ci_enable_auto_scaling = true
ci_min_size=0
ci_max_size=200
ci_zones=["1","2","3"]
ci_priority="Spot"
ci_spot_max_price= -1
ci_spot_eviction_policy="Deallocate"

ci_kubernetes_namespace = "perf"
ci_helm_chart_version="1.0.5"

### tmp Nodepool variables
tmp_vm_size="Standard_E32as_v4"
tmp_kubernetes_namespace="tmp"
tmp_workspace_name = "tmp"
tmp_enable_auto_scaling = true
tmp_min_size=0
tmp_max_size=200
tmp_zones=["1","2","3"]
tmp_helm_chart_version="1.0.5"

### Dev Nodepool variables
dev_workspace_name = "dev"
dev_vm_size="Standard_D32plds_v5"
dev_enable_auto_scaling = true
dev_min_size=0
dev_max_size=200
dev_zones=["1","2","3"]
dev_priority="Spot"
dev_spot_max_price= -1
dev_spot_eviction_policy="Deallocate"

dev_kubernetes_namespace = "dev"
dev_helm_chart_version="1.0.5"

### Docker Registry
docker_image_repository          = "us-docker.pkg.dev/e6data-analytics/e6-engine"
docker_project_id   = "e6data-analytics"
gcp_region = "us-central1"

### Docker Registry variables
image_secret_namespaces = ["perf", "dev"]

###blob full access
e6data_blob_full_access_secret_expiration_time = "7200h"

### Helm SCP Policy variables
helm_scp_name = "helm-scp"
helm_scp_namespace = "default"

helm_scp_image_repository = "e6labs.azurecr.io"
helm_scp_image_tag = "2.0.23-b0a255a"
helm_scp_image_name = "helm-scp"

helm_scp_env_vars = {
  "EXCLUDED_NAMESPACES"="{kube-system,default,kube-public,kube-node-lease}"
  "EXCLUDED_RELEASES"="{ci-montioring,dev,dev-montioring,ingress-nginx,perf,e6data}"
  "THRESHOLD_AGE_IN_MINS"="120"
  "SLACK_WEBHOOK_URL"="https://hooks.slack.com/services/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"
}

helm_scp_nodegroup = "default"

# azure container registry variables
acr_name="e6labs"
acr_rg="e6data-common"

ci_domain="e6xlabs.cloud"
ci_alias="perf"
ci_monitoring_v3_map = {
  monitoring_ci = {
    type = "external"
    helm_chart_name = "e6data"
    logs_label_key = "app"
    logs_label_value = "e6data"
    metrics_label_key = "app"
    metrics_label_value = "e6data"
    namespace = "perf"
    docker_image_repository = "us-docker.pkg.dev/e6data-analytics/e6-engine"
    metrics_docker_image_name = "monitoring-metrics"
    metrics_docker_image_tag = "2.0.31-95adb095"
    monitoring_metrics_replicas = 1
    agent_docker_image_name = "monitoring-agent"
    agent_docker_image_tag = "2.0.10-ced0990f"
    monitoring_controller_docker_image_name = "monitoring-controller"
    monitoring_controller_docker_image_tag = "2.0.60-f3566cb"
    monitoring_controller_replicas = 1
    metrics_port = 8081
    agent_enabled = true
    controller_enabled = true
    metrics_enabled = true
    cloud = "AZURE"
    component = "perf"
  } 
}

dev_alias="dev"
dev_domain="e6xlabs.cloud"
dev_monitoring_v3_map = {
  monitoring_dev = {
    type = "external"
    helm_chart_name = "e6data"
    logs_label_key = "app"
    logs_label_value = "e6data"
    metrics_label_key = "app"
    metrics_label_value = "e6data"
    namespace = "dev"
    docker_image_repository = "us-docker.pkg.dev/e6data-analytics/e6-engine"
    metrics_docker_image_name = "monitoring-metrics"
    metrics_docker_image_tag = "2.0.31-95adb095"
    monitoring_metrics_replicas = 1
    agent_docker_image_name = "monitoring-agent"
    agent_docker_image_tag = "2.0.10-ced0990f"
    monitoring_controller_docker_image_name = "monitoring-controller"
    monitoring_controller_docker_image_tag = "2.0.60-f3566cb"
    monitoring_controller_replicas = 1
    metrics_port = 8081
    agent_enabled = true
    controller_enabled = true
    metrics_enabled = true
    cloud = "AZURE"
    component = "dev"
  } 
}

tmp_alias="tmp"
tmp_domain="e6xlabs.cloud"
tmp_monitoring_v3_map = {
  monitoring_tmp = {
    type = "external"
    helm_chart_name = "e6data-tmp"
    logs_label_key = "app"
    logs_label_value = "e6data"
    metrics_label_key = "app"
    metrics_label_value = "e6data"
    namespace = "dev"
    docker_image_repository = "us-docker.pkg.dev/e6data-analytics/e6-engine"
    metrics_docker_image_name = "monitoring-metrics"
    metrics_docker_image_tag = "2.0.31-95adb095"
    monitoring_metrics_replicas = 1
    agent_docker_image_name = "monitoring-agent"
    agent_docker_image_tag = "2.0.10-ced0990f"
    monitoring_controller_docker_image_name = "monitoring-controller"
    monitoring_controller_docker_image_tag = "2.0.60-f3566cb"
    monitoring_controller_replicas = 1
    metrics_port = 8081
    agent_enabled = true
    controller_enabled = true
    metrics_enabled = true
    cloud = "AZURE"
    component = "tmp"
  } 
}
