aws_region="us-east-1"
cost_tags = {
  App = "e6data"
}

vpc_id="vpc-abcdef1234567"
private_subnet_ids=["subnet-abcdef1234567","subnet-abcdef1234567"]
subnet_ids=["subnet-abcdef1234567","subnet-abcdef1234567"]

kube_version="1.27"
cluster_name="e6data"

min_size="1"
desired_size="1"
max_size="5"

disk_size="100"

aws_command_line_path = "aws"

# Autoscaler variables
autoscaler_namespace = "kube-system"
autoscaler_service_account_name = "cluster-autoscaler"
autoscaler_helm_chart_name = "autoscaler"
autoscaler_helm_chart_version = "9.26.0"
