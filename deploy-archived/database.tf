# Database variables
variable "db_instance_class" {
  description = "RDS instance class"
  default     = "db.t3.micro"  # Lowest cost option
}

variable "db_name" {
  description = "Database name"
  default     = "perkup_production"
}

variable "db_username" {
  description = "Database username"
  default     = "perkupuser"
}

variable "db_password" {
  description = "Database password"
  sensitive   = true
  # For production, use AWS Secrets Manager or store in a secure location
  # Don't hardcode passwords in Terraform files
  default     = "changeme123"  # Change this before deploying
}

variable "db_allocated_storage" {
  description = "Allocated storage for the database (GB)"
  default     = 20
}

# RDS PostgreSQL instance
resource "aws_db_instance" "main" {
  identifier              = "${var.app_name}-${var.environment}-db"
  allocated_storage       = var.db_allocated_storage
  storage_type            = "gp2"
  engine                  = "postgres"
  engine_version          = "17.4"
  instance_class          = var.db_instance_class
  db_name                 = var.db_name
  username                = var.db_username
  password                = var.db_password
  db_subnet_group_name    = aws_db_subnet_group.main.name
  vpc_security_group_ids  = [aws_security_group.database.id]
  skip_final_snapshot     = true
  backup_retention_period = 7  # Keep backups for 7 days
  multi_az                = false  # Set to true for production
  
  # Additional configuration
  auto_minor_version_upgrade = true
  publicly_accessible        = false
  
  tags = {
    Name = "${var.app_name}-${var.environment}-db"
  }
}

# Removing duplicate outputs that are already defined in outputs.tf 