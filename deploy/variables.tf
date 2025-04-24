variable "aws_region" {
  description = "AWS region to deploy the infrastructure"
  type        = string
  default     = "ca-central-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for the public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "availability_zones" {
  description = "Availability zones for the subnets"
  type        = list(string)
  default     = ["ca-central-1a", "ca-central-1b"]
}

variable "key_name" {
  description = "Name of the EC2 key pair"
  type        = string
  default     = "perk-up-dev"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "backend_port" {
  description = "Port for the backend application"
  type        = number
  default     = 3000
}

variable "frontend_port" {
  description = "Port for the frontend application"
  type        = number
  default     = 3001
} 