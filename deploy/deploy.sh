#!/bin/bash

set -e

# Change to the script directory
cd "$(dirname "$0")"

# Define colors for better output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to print a step
print_step() {
  echo -e "${GREEN}==>${NC} $1"
}

# Function to print a warning
print_warning() {
  echo -e "${YELLOW}Warning:${NC} $1"
}

# Function to print an error
print_error() {
  echo -e "${RED}Error:${NC} $1"
}

print_step "Starting deployment process for Perk Up application"

# Check if Terraform is installed
if ! command -v terraform &> /dev/null; then
  print_error "Terraform not found. Please install Terraform: https://learn.hashicorp.com/tutorials/terraform/install-cli"
  exit 1
fi

# Initialize Terraform if .terraform directory doesn't exist
if [ ! -d ".terraform" ]; then
  print_step "Initializing Terraform..."
  terraform init
fi

# Plan the deployment
print_step "Planning Terraform deployment..."
terraform plan -out=tfplan

# Ask for confirmation
echo ""
read -p "Do you want to apply the above plan? (y/n) " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  print_warning "Deployment aborted by user"
  exit 0
fi

# Apply the plan
print_step "Applying Terraform plan..."
terraform apply tfplan

# Show outputs
print_step "Deployment completed successfully!"
echo ""
print_step "Frontend URL:"
terraform output -json frontend_url | tr -d '"'
echo ""
print_step "Backend URL:"
terraform output -json backend_url | tr -d '"'
echo ""

# Clean up
rm -f tfplan

print_step "You can SSH into the instances using:"
echo "ssh -i perk-up-dev-key.pem ec2-user@$(terraform output -json frontend_public_dns | tr -d '"')"
echo "ssh -i perk-up-dev-key.pem ec2-user@$(terraform output -json backend_public_dns | tr -d '"')" 