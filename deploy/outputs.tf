output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "frontend_public_ip" {
  description = "Public IP address of the frontend EC2 instance"
  value       = module.ec2.frontend_public_ip
}

output "backend_public_ip" {
  description = "Public IP address of the backend EC2 instance"
  value       = module.ec2.backend_public_ip
}

output "frontend_public_dns" {
  description = "Public DNS name of the frontend EC2 instance"
  value       = module.ec2.frontend_public_dns
}

output "backend_public_dns" {
  description = "Public DNS name of the backend EC2 instance"
  value       = module.ec2.backend_public_dns
}

output "frontend_url" {
  description = "URL to access the frontend application"
  value       = "http://${module.ec2.frontend_public_dns}:${var.frontend_port}"
}

output "backend_url" {
  description = "URL to access the backend application"
  value       = "http://${module.ec2.backend_public_dns}:${var.backend_port}"
} 