# **AWS e6data workspace setup**

This terraform script broadly consists of two parts:
1. prequisites the e6data workspace
2. e6data workspace

## **Terraform Setup**
The steps are alreaady mentioned in the [terraform_setup.md](../docs/terraform_setup.md) file.

The permissions required for the terraform user are mentioned in the [terraform_permissions.json](../docs/terraform_permissions.json) file.

## **Terraform components**
1. **VPC**: Create a VPC with zones equivalent public subnets and private subnets.
2. **EKS Cluster**: Create an EKS cluster in the VPC created in the previous step.
3. **EKS Node Group**: Create an EKS node group in the EKS cluster created in the previous step.
4. **S3 Bucket**: Create an S3 bucket to store the e6data operation management data.
5. **Cluster Autoscaler**: Create a cluster autoscaler to scale the EKS cluster nodes.
6. **AWS ALB Ingress Controller**: Create an AWS ALB Ingress Controller to manage the ingress traffic to the EKS cluster.
7. **AWS IAM Roles**: Create AWS IAM roles for the EKS cluster , Cluster Autoscaler and the AWS ALB Ingress Controller.
8. **AWS IAM Policies**: Create AWS IAM policies for the EKS cluster , Cluster Autoscaler and the AWS ALB Ingress Controller.
9. **Cross Account IAM Roles**: Create AWS IAM roles for e6data control plane to access the EKS cluster and the s3 bucket.
10. **OIDC Provider**: Create an OIDC provider for the EKS cluster to enable IAM roles for service accounts.
11. **AWS IAM Roles for Service Accounts**: Create AWS IAM roles for service accounts to access the s3 data buckets.
12. **e6data Helm Chart**: Deploy the e6data helm chart to the EKS cluster.


