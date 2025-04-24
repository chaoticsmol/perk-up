variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "frontend_port" {
  description = "Port for the frontend application"
  type        = number
}

variable "backend_port" {
  description = "Port for the backend application"
  type        = number
} 