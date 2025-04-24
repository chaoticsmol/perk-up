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

print_step "Starting redeployment process for Perk Up application"

# Check if Terraform is installed
if ! command -v terraform &> /dev/null; then
  print_error "Terraform not found. Please install Terraform: https://learn.hashicorp.com/tutorials/terraform/install-cli"
  exit 1
fi

# If there's a command-line argument, use it to taint specific resources
if [ "$1" = "backend" ]; then
  print_step "Marking backend instance for recreation..."
  terraform taint module.ec2.aws_instance.backend
elif [ "$1" = "frontend" ]; then
  print_step "Marking frontend instance for recreation..."
  terraform taint module.ec2.aws_instance.frontend
elif [ "$1" = "all" ]; then
  print_step "Marking all instances for recreation..."
  terraform taint module.ec2.aws_instance.backend
  terraform taint module.ec2.aws_instance.frontend
else
  print_warning "No specific resource marked for recreation. Use ./redeploy.sh [backend|frontend|all]"
  print_warning "Proceeding with normal apply..."
fi

# Plan the deployment
print_step "Planning Terraform redeployment..."
terraform plan -out=tfplan

# Ask for confirmation
echo ""
read -p "Do you want to apply the above plan? (y/n) " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  print_warning "Redeployment aborted by user"
  exit 0
fi

# Apply the plan
print_step "Applying Terraform plan..."
terraform apply -auto-approve tfplan

# Get the backend and frontend URLs
BACKEND_URL=$(terraform output -raw backend_url)
FRONTEND_URL=$(terraform output -raw frontend_url)

print_step "Redeployment completed successfully!"
echo -e "${GREEN}Backend URL: ${BACKEND_URL}${NC}"
echo -e "${GREEN}Frontend URL: ${FRONTEND_URL}${NC}"
echo -e "${YELLOW}Note: It may take a few minutes for the instances to fully initialize and for the applications to start.${NC}"

# Wait for instances to initialize
echo -e "${YELLOW}Waiting for instances to initialize (this may take a few minutes)...${NC}"
sleep 60

# Check if frontend is accessible
echo -e "${YELLOW}Checking if frontend is accessible...${NC}"
if curl -s --head --request GET ${FRONTEND_URL} | grep "200" > /dev/null; then 
    echo -e "${GREEN}Frontend is accessible!${NC}"
else
    echo -e "${RED}Frontend is not yet accessible. It might need more time to initialize.${NC}"
fi

# Check if backend is accessible
echo -e "${YELLOW}Checking if backend GraphQL endpoint is accessible...${NC}"
if curl -s --head --request GET ${BACKEND_URL}/graphql | grep "200" > /dev/null; then 
    echo -e "${GREEN}Backend GraphQL endpoint is accessible!${NC}"
else
    echo -e "${RED}Backend GraphQL endpoint is not yet accessible. It might need more time to initialize.${NC}"
    echo -e "${YELLOW}You can try accessing it manually later with:${NC}"
    echo -e "curl -v -XPOST ${BACKEND_URL}/graphql -H \"Content-Type: application/json\" -d '{\"query\": \"{ customer { email } }\" }'"
fi

echo -e "${GREEN}Deployment process complete!${NC}"
echo -e "${YELLOW}If services are not yet accessible, wait a few more minutes and try again.${NC}"
echo -e "${YELLOW}You can SSH into the instances for troubleshooting:${NC}"
echo -e "Backend: ssh -i /path/to/key.pem ec2-user@$(terraform output -raw backend_public_dns)"
echo -e "Frontend: ssh -i /path/to/key.pem ec2-user@$(terraform output -raw frontend_public_dns)"
echo -e "${YELLOW}After SSH-ing, you can check Docker logs with:${NC}"
echo -e "Backend: docker logs perk-up-backend"
echo -e "Frontend: docker logs perk-up-frontend"

# Clean up
rm -f tfplan 