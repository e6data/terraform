aws_region = "us-east-1" ### AWS region of the EKS cluster.

workspace_name = "workspace-name" ### Name of the e6data workspace to be created.
# Note: The variable workspace_name should meet the following criteria:
# a) Accepts only lowercase alphanumeric characters.
# b) Must have a minimum of 3 characters.
# c) Must not exceed 10 characters.

eks_cluster_name = "eks-cluster-name" ### The name of the Kubernetes cluster to deploy e6data workspace.

eks_disk_size            = 100 ### Disk size for the instances in the nodepool. A minimum of 100 GB is required.
nodepool_instance_family = ["t3", "t4g", "t2", "c7g", "c7gd", "c6g", "c6gd", "r6g", "r6gd", "r7g", "r7gd", "i3"]

excluded_az = ["us-east-1e"]

bucket_names = ["*"] ### List of bucket names that the e6data engine queries and therefore, require read access to. Default is ["*"] which means all buckets, it is advisable to change this.

kubernetes_namespace = "e6data" ### Value of the Kubernetes namespace to deploy the e6data workspace.
helm_chart_version   = "2.0.9"  ### e6data workspace Helm chart version to be used.


### Below are the tags which will be applied to all the resources created by this Terraform script.
cost_tags = {
  app = "e6data"
}

aws_command_line_path = "/usr/bin/aws" ### Specify the path to the AWS Command Line Interface executable. Run "which aws" command to get exact path.