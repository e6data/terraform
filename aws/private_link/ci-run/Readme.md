# Step-by-Step Instructions

## 1. Initial Terraform Apply
Run:
```bash
terraform apply
```

## 2. Deploy Kubernetes Manifests Manually
Deploy the required Kubernetes manifests as per the doc(e.g., nginx service) to trigger NLB creation.

## 3. Update `terraform.tfvars`
After the NLB is created, retrieve its ARN and update your `terraform.tfvars`:
```hcl
network_load_balancer_arn = "arn:aws:elasticloadbalancing:<region>:<account>:loadbalancer/net/nginx-nlb/xyz"
```

## 4. Re-run Terraform
Apply again to trigger the endpoint service creation:
```bash
terraform apply
```