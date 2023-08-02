aws_region                      = "us-east-1" ### AWS region of the EKS cluster.
workspace_name                  = "workspace-name" ### Name of the e6data workspace to be created.

eks_cluster_name                = "eks-cluster-name" ### The name of the Kubernetes cluster to deploy e6data workspace.
kube_version                    = "1.24" ### The Kubernetes cluster version. Version 1.24 or higher is required.

max_instances_in_eks_nodegroup  = 20 ### The maximum number of instances that can be allowed in the EKS nodegroup. A minimum of 3 is required.

eks_disk_size                   = 100 ### Disk size for the disks in the node group. A minimum of 100 GB is required.
eks_capacity_type               = "ON_DEMAND" ### Options: ON_DEMAND or SPOT. The type of instances that should be created.

bucket_names                    = ["*"] ### List of bucket names that the e6data engine queries and therefore, require read access to. Default is ["*"] which means all buckets, it is advisable to change this.

kubernetes_namespace            = "e6data" ### Value of the Kubernetes namespace to deploy the e6data workspace.
helm_chart_version              = "1.0.1" ### e6data workspace Helm chart version to be used.


### Below are the tags which will be applied to all the resources created by this Terraform script.
cost_tags = {}

aws_command_line_path            = "/usr/bin/aws"