# Common variables
variable "region" {
  description = "AWS region"
  default     = "ca-central-1"
}

# VPC variables
variable "vpc_cidr" {
  description = "VPC CIDR block"
  default     = "10.0.0.0/16"
}

# Tags
variable "tags" {
  description = "Common resource tags"
  type        = map(string)
  default = {
    Project     = "PerkUp"
    Environment = "Development"
    ManagedBy   = "Terraform"
  }
}

# Repository
variable "repo_url" {
  description = "URL of the Git repository"
  default     = "https://github.com/chaoticsmol/perk-up.git"
}

# Frontend variables
variable "frontend_port" {
  description = "Port for the frontend application"
  default     = 3001
}

# Backend variables
variable "backend_port" {
  description = "Port for the backend application"
  default     = 3000
}

# Rails master key
variable "rails_master_key" {
  description = "Rails master key for the backend application"
  sensitive   = true
  default     = ""  # Should be provided via terraform.tfvars or environment variable
} 