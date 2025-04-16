# VPC outputs
output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = [aws_subnet.public_1.id, aws_subnet.public_2.id]
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = [aws_subnet.private_1.id, aws_subnet.private_2.id]
}

# Security group outputs
output "backend_security_group_id" {
  description = "ID of the backend security group"
  value       = aws_security_group.backend.id
}

output "frontend_security_group_id" {
  description = "ID of the frontend security group"
  value       = aws_security_group.frontend.id
}

output "database_security_group_id" {
  description = "ID of the database security group"
  value       = aws_security_group.database.id
}

# EC2 outputs
output "app_server_instance_id" {
  description = "ID of the app server EC2 instance"
  value       = aws_instance.app_server.id
}

output "backend_url" {
  description = "URL to access the backend application"
  value       = "http://${aws_instance.app_server.public_dns}:${var.backend_port}"
}

output "frontend_url" {
  description = "URL to access the frontend application"
  value       = "http://${aws_instance.app_server.public_dns}:${var.frontend_port}"
}

output "app_server_public_ip" {
  description = "Public IP of the app server EC2 instance"
  value       = aws_instance.app_server.public_ip
}

output "app_server_public_dns" {
  description = "Public DNS of the app server EC2 instance"
  value       = aws_instance.app_server.public_dns
}

# RDS outputs
output "database_connection_string" {
  description = "Connection string for the database"
  value       = "postgres://${var.db_username}:${var.db_password}@${aws_db_instance.main.endpoint}/${var.db_name}"
  sensitive   = true
}

output "db_endpoint" {
  description = "Endpoint of the RDS instance"
  value       = aws_db_instance.main.endpoint
}

output "db_name" {
  description = "Name of the database"
  value       = aws_db_instance.main.db_name
}

output "db_username" {
  description = "Username for the database"
  value       = var.db_username
}

output "db_port" {
  description = "Port for the database connection"
  value       = 5432
} 