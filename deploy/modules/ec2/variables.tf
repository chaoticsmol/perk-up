variable "backend_subnet_id" {
  description = "ID of the subnet for the backend instance"
  type        = string
}

variable "frontend_subnet_id" {
  description = "ID of the subnet for the frontend instance"
  type        = string
}

variable "security_group_id" {
  description = "ID of the security group"
  type        = string
}

variable "key_name" {
  description = "Name of the EC2 key pair"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "backend_port" {
  description = "Port for the backend application"
  type        = number
}

variable "frontend_port" {
  description = "Port for the frontend application"
  type        = number
}

variable "aws_region" {
  description = "AWS region for the deployment"
  type        = string
} 