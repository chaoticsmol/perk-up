# PerkUp AWS Deployment Guide

This guide explains how to deploy the PerkUp application to AWS using Terraform.

## Prerequisites

1. AWS CLI installed and configured with appropriate credentials
2. Terraform CLI installed (version 1.0.0+)
3. GitHub repository access to [chaoticsmol/perk-up](https://github.com/chaoticsmol/perk-up)
4. Rails master key from the backend application

## Running Locally

Before deploying to AWS, you can test the application locally using Docker Compose:

```bash
# Clone the repository
git clone https://github.com/chaoticsmol/perk-up.git
cd perk-up

# Create a .env file with your Rails master key
echo "RAILS_MASTER_KEY=your_rails_master_key" > .env

# Build and run the containers
docker-compose build
docker-compose up -d
```

The application will be available at:
- Frontend: http://localhost:3001
- Backend: http://localhost:3000

## Deployment Steps

### 1. Prepare your environment variables

Update the terraform.tfvars file with your Rails master key:

```bash
# Edit terraform.tfvars and set rails_master_key
rails_master_key = "your_rails_master_key_here"
```

### 2. Initialize Terraform

```bash
terraform init
```

### 3. Review planned changes

```bash
terraform plan
```

### 4. Apply the configuration

```bash
terraform apply
```

Confirm the changes by typing `yes` when prompted.

### 5. Access your application

After the deployment completes, Terraform will output URLs to access both the frontend and backend applications:

- Frontend: http://your-ec2-public-dns:3001
- Backend: http://your-ec2-public-dns:3000

## Architecture Overview

The deployment sets up:

1. A VPC with public and private subnets
2. A single EC2 instance running both frontend and backend Docker containers
3. A PostgreSQL database running in a container (or optionally an RDS instance)
4. Security groups to control access

The application is deployed using Docker Compose, which simplifies managing all services.

## Troubleshooting

If you encounter issues:

1. SSH into the EC2 instance:
   ```bash
   ssh -i "perk-up-dev.pem" ec2-user@your-ec2-public-dns
   ```

2. Check Docker Compose status:
   ```bash
   cd /app
   docker-compose ps
   ```

3. View container logs:
   ```bash
   docker-compose logs backend
   docker-compose logs frontend
   ```

4. If containers failed to build or start:
   ```bash
   # Stop any running containers
   docker-compose down
   
   # Try rebuilding without cache
   docker-compose build --no-cache
   
   # Start in foreground to see immediate output
   docker-compose up
   ```

5. Check user data script logs:
   ```bash
   cat /var/log/user-data.log
   ```

## Cleanup

To destroy all resources when they're no longer needed:

```bash
terraform destroy
```

Confirm the destruction by typing `yes` when prompted.

## Customization

- Edit `variables.tf` to change default values
- Modify `ec2.tf` to adjust EC2 instance configurations
- Update `database.tf` to change database settings

## Connecting to EC2 Instances

```bash
ssh -i /path/to/your-key-pair.pem ec2-user@[instance-public-ip]
```

## Security Considerations

- The current setup opens SSH (port 22) to the world. For production, restrict this to your IP or VPN.
- Database passwords are stored in Terraform state. Use AWS Secrets Manager for production.
- Consider enabling HTTPS for production deployments.
- This setup uses a simple configuration. Add more security layers for production use.

## Performance Optimization

For a production environment, consider:
- Using Auto Scaling Groups for both frontend and backend
- Implementing a load balancer
- Enabling Multi-AZ for the RDS instance
- Setting up CloudFront for frontend content delivery 