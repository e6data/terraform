## 🚀 Recommended Terraform Apply Order

To ensure resources are created in the correct order and dependencies are properly resolved, apply Terraform using the following steps:

```bash
terraform apply -target=module.eks
terraform apply -target=aws_vpc_endpoint.eks_endpoint
terraform apply
