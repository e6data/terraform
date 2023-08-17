# **AWS e6data workspace setup commands**
## **Prerequisites**
Before you begin, ensure you have the following prerequisites in place:

1. **EC2 instance**: You need to spin up an ec2 instance of t4g.small with ec2 instance role having [appropriate IAM permissions](./terraform_permissions.json) to create e6data resources.

1. **Terraform**: [Install](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) Terraform on your machine. Or you can run the following commands

```Shell
sudo yum install -y yum-utils

sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo

sudo yum -y install terraform
```

1. **kubectl**: Install kubectl for managing Kubernetes clusters(Optional).
<https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/>

1. **Git :** Install git on your machine to clone the e6data terraform repo or Run the following command 

```Shell
sudo yum install git -y
```

## **Workspace Setup**

### **1. Clone the Repository**
Clone the e6data workspace repository to your machine:

```Shell
git clone https://github.com/e6x-labs/terraform.git

cd terraform/aws_workspace
```

### **2. Configure Variables**
open the [terraform.tfvars](../aws_workspace/terraform.tfvars) file. Modify the variables according to your requirements, Make sure to follow the provided comments for guidance on each variable's configuration.

### **3. Configure s3 as Backend (Optional)**
- Edit the [provider.tf](../aws_workspace/provider.tf) and add S3 backend block :

\# Configure the AWS Provider

```HCL
terraform {
   backend "s3" {
      bucket = "<BUCKET_NAME>"
      key    = "<BUCKET_PREFIX>"
      region = "<BUCKET_REGION>"
   }
}
```

Please replace <BUCKET_NAME> , <BUCKET_PREFIX> and <BUCKET_REGION> with the actual bucket name, bucket path and region of the S3 bucket you choose to use as the backend. Once you configure the above, Terraform state files will be stored in the S3 bucket. 

### **4. Initialize Terraform with Backend Configuration:**
Run the following command to initialize Terraform with the specified backend configuration:

a. **Initialize Terraform with Backend Configuration:**

```HCL
terraform init
```

**b. Plan:**
Once the initialization is complete, you can plan the changes i.e have a look at the resources that will get created using the following command:

```HCL
terraform plan --out=plan.out
```

**c. Apply:**

If you are satisfied with the plan and want to proceed with applying the changes to your infrastructure, you can go ahead and apply the changes using the following command:

```HCL
terraform apply "plan.out"
```