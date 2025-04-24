output "backend_public_ip" {
  description = "Public IP address of the backend EC2 instance"
  value       = aws_instance.backend.public_ip
}

output "frontend_public_ip" {
  description = "Public IP address of the frontend EC2 instance"
  value       = aws_instance.frontend.public_ip
}

output "backend_public_dns" {
  description = "Public DNS name of the backend EC2 instance"
  value       = aws_instance.backend.public_dns
}

output "frontend_public_dns" {
  description = "Public DNS name of the frontend EC2 instance"
  value       = aws_instance.frontend.public_dns
} 