terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.2.0"
}

provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "./modules/vpc"
  
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  availability_zones   = var.availability_zones
}

module "security" {
  source = "./modules/security"
  
  vpc_id = module.vpc.vpc_id
  backend_port = var.backend_port
  frontend_port = var.frontend_port
}

module "ec2" {
  source = "./modules/ec2"
  
  backend_subnet_id    = module.vpc.public_subnet_ids[0]
  frontend_subnet_id   = module.vpc.public_subnet_ids[0]
  security_group_id    = module.security.security_group_id
  key_name             = var.key_name
  instance_type        = var.instance_type
  backend_port         = var.backend_port
  frontend_port        = var.frontend_port
  aws_region           = var.aws_region
} 