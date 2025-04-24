# Perk Up AWS Deployment

This directory contains Terraform configurations to deploy the Perk Up application on AWS EC2 instances.

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) (>= 1.2.0)
- AWS CLI installed and configured
- EC2 key pair (default: `perk-up-dev`)

## Deployment Structure

- `main.tf` - Main Terraform configuration
- `variables.tf` - Variable definitions
- `outputs.tf` - Output definitions
- `terraform.tfvars` - Variable values
- `modules/` - Terraform modules
  - `vpc/` - VPC configuration
  - `security/` - Security group configuration
  - `ec2/` - EC2 instance configuration
- `deploy.sh` - Deployment script
- `redeploy.sh` - Redeployment script

## Customization

You can customize the deployment by editing the `terraform.tfvars` file. The following variables are available:

- `aws_region` - AWS region (default: `ca-central-1`)
- `vpc_cidr` - VPC CIDR block (default: `10.0.0.0/16`)
- `public_subnet_cidrs` - Public subnet CIDR blocks (default: `["10.0.1.0/24", "10.0.2.0/24"]`)
- `availability_zones` - Availability zones (default: `["ca-central-1a", "ca-central-1b"]`)
- `key_name` - EC2 key pair name (default: `perk-up-dev`)
- `instance_type` - EC2 instance type (default: `t2.micro`)
- `backend_port` - Backend port (default: `3000`)
- `frontend_port` - Frontend port (default: `3001`)

## Deployment

To deploy the application, run:

```bash
./deploy.sh
```

The script will:
1. Initialize Terraform if needed
2. Plan the deployment
3. Ask for confirmation
4. Apply the plan
5. Show the URLs to access the application

## Redeployment

If you need to redeploy the application (e.g., after making changes), you can use the `redeploy.sh` script:

```bash
# Redeploy everything
./redeploy.sh all

# Redeploy only the backend
./redeploy.sh backend

# Redeploy only the frontend
./redeploy.sh frontend
```

## Accessing the Instances

After deployment, you can SSH into the instances using:

```bash
ssh -i your-key.pem ec2-user@<frontend-public-dns>
ssh -i your-key.pem ec2-user@<backend-public-dns>
```

The URLs to access the application will be displayed after deployment:

- Frontend: `http://<frontend-public-dns>:3001`
- Backend: `http://<backend-public-dns>:3000`

## Cleaning Up

To destroy all resources created by this deployment, run:

```bash
terraform destroy
``` 