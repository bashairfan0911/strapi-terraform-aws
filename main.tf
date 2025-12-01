terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Get latest Ubuntu 22.04 AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Security Group for EC2 instance
resource "aws_security_group" "strapi_sg" {
  name        = "strapi-security-group"
  description = "Security group for Strapi CMS"

  # SSH access
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
    description = "SSH access"
  }

  # Strapi admin panel and API
  ingress {
    from_port   = 1337
    to_port     = 1337
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Strapi application"
  }

  # HTTP access (optional, for production setup)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP access"
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name = "strapi-sg"
  }
}

# EC2 Instance for Strapi
resource "aws_instance" "strapi_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  vpc_security_group_ids = [aws_security_group.strapi_sg.id]
  key_name              = var.key_name

  # User data script to install and configure Strapi
  user_data = file("${path.module}/scripts/install_strapi.sh")

  # Storage
  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  tags = {
    Name = "strapi-cms-server"
  }
}

# Elastic IP for persistent public IP
resource "aws_eip" "strapi_eip" {
  instance = aws_instance.strapi_server.id
  domain   = "vpc"

  tags = {
    Name = "strapi-eip"
  }
}