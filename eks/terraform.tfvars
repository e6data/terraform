aws_region="us-east-1"
cost_tags = {
  App = "e6data"
}
vpc_id="vpc-03b5f6f73fb2b5897"
private_subnet_ids=["subnet-0f1b32057034a875e","subnet-0d64044719cbfb492"]
subnet_ids=["subnet-0a8d934ed49c56fae","subnet-0f6ebfd0f545f8454"]
e6data_namespaces=["e6data"]
kube_version="1.27"
cluster_name="e6data"
min_size="1"
desired_size="1"
max_size="5"
disk_size="100"
tag="e6data"
aws_command_line_path = "aws"
# Autoscaler variables
autoscaler_namespace = "kube-system"
autoscaler_service_account_name = "cluster-autoscaler"
autoscaler_helm_chart_name = "autoscaler"
autoscaler_helm_chart_version = "9.26.0"
