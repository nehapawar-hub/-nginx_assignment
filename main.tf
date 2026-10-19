terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.5.0"
}

# Configure AWS provider

provider "aws" {
  region = var.aws_region
}

# Find the default VPC

data "aws_vpc" "default" {
  default = true
}

# Find subnets in the default VPC

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Find the latest Ubuntu 22.04 LTS AMI

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

# Create security group

resource "aws_security_group" "nginx_sg" {
  name        = "terraform-nginx-security-group"
  description = "Allow HTTP and SSH traffic"
  vpc_id      = data.aws_vpc.default.id

  # Allow HTTP traffic

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow SSH traffic

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_allowed_cidr]
  }

  # Allow outbound traffic

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform-nginx-sg"
  }
}

# Create EC2 instance

resource "aws_instance" "nginx_server" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = data.aws_subnets.default.ids[0]
  vpc_security_group_ids      = [aws_security_group.nginx_sg.id]
  associate_public_ip_address = true

  # Install Nginx and create custom HTML page

  user_data = <<-EOF
#!/bin/bash
set -eux

```
          export DEBIAN_FRONTEND=noninteractive

          apt-get update -y
          apt-get install -y nginx

          cat > /var/www/html/index.html <<'HTML'
          <!DOCTYPE html>
          <html>
          <head>
              <title>Terraform Nginx Server</title>
          </head>
          <body>
              <h1>Welcome to the Terraform-managed Nginx Server on Ubuntu</h1>
          </body>
          </html>
          HTML

          systemctl enable nginx
          systemctl restart nginx
          EOF


  tags = {
    Name = "terraform-nginx-ubuntu"
  }
}
