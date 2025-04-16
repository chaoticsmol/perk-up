# EC2 Instance Variables
variable "ec2_instance_type" {
  description = "EC2 instance type"
  default     = "t2.micro"  # Free tier eligible
}

variable "ec2_key_name" {
  description = "EC2 key pair name"
  default     = "perk-up-dev"  # This should match the key you created in AWS
}

# Get latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Create EC2 instance to host both frontend and backend
resource "aws_instance" "app_server" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.ec2_instance_type
  key_name               = var.ec2_key_name
  vpc_security_group_ids = [aws_security_group.backend.id, aws_security_group.frontend.id]
  subnet_id              = aws_subnet.public_1.id

  root_block_device {
    volume_size = 20
    volume_type = "gp2"
  }

  tags = {
    Name = "${var.app_name}-${var.environment}-app-server"
  }

  user_data = <<-EOF
              #!/bin/bash
              # Log all output
              exec > >(tee /var/log/user-data.log|logger -t user-data) 2>&1
              echo "Starting setup..."
              
              # Update and install dependencies
              yum update -y
              amazon-linux-extras install -y docker
              yum install -y git
              
              # Install Docker Compose
              curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
              chmod +x /usr/local/bin/docker-compose
              
              # Start Docker service
              service docker start
              usermod -a -G docker ec2-user
              chkconfig docker on
              
              # Clone repository
              echo "Cloning repository from ${var.repo_url}..."
              mkdir -p /app
              cd /app
              git clone ${var.repo_url} .
              
              if [ $? -ne 0 ]; then
                echo "ERROR: Git clone failed. Please ensure the repository is accessible."
                exit 1
              fi
              
              # Create .env file for Rails master key
              echo "Setting up environment variables..."
              cat > /app/.env << EOF_ENV
              RAILS_MASTER_KEY=${var.rails_master_key}
              EOF_ENV
              
              # Create local docker-compose.yml with the correct database URL
              echo "Creating docker-compose.yml..."
              cat > /app/docker-compose.yml << EOF_COMPOSE
              version: '3.8'
              
              services:
                db:
                  image: postgres:13
                  container_name: perk-up-postgres
                  restart: unless-stopped
                  environment:
                    - POSTGRES_USER=${var.db_username}
                    - POSTGRES_PASSWORD=${var.db_password}
                    - POSTGRES_DB=${var.db_name}
                  volumes:
                    - postgres-data:/var/lib/postgresql/data
                  ports:
                    - "5432:5432"
              
                backend:
                  build:
                    context: ./backend
                    dockerfile: Dockerfile
                  container_name: perk-up-backend
                  restart: unless-stopped
                  environment:
                    - RAILS_MASTER_KEY=\${var.rails_master_key}
                    - RAILS_ENV=production
                    - RAILS_LOG_TO_STDOUT=true
                    - RAILS_SERVE_STATIC_FILES=true
                    - DATABASE_URL=postgres://${var.db_username}:${var.db_password}@db:5432/${var.db_name}
                  depends_on:
                    - db
                  volumes:
                    - backend-storage:/rails/storage
                  ports:
                    - "3000:80"
              
                frontend:
                  build:
                    context: ./frontend
                    dockerfile: Dockerfile
                  container_name: perk-up-frontend
                  restart: unless-stopped
                  environment:
                    - PORT=3001
                    - NODE_ENV=production
                    - BACKEND_URL=http://backend
                  ports:
                    - "3001:3001"
                  depends_on:
                    - backend
              
              volumes:
                postgres-data:
                  driver: local
                backend-storage:
                  driver: local
              EOF_COMPOSE
              
              # Build and start the containers with debug output
              echo "Building and starting containers..."
              cd /app
              RAILS_MASTER_KEY=${var.rails_master_key} docker-compose build --no-cache
              RAILS_MASTER_KEY=${var.rails_master_key} docker-compose up -d
              
              echo "Setup complete!"
              EOF
} 