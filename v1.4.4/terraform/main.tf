terraform {
  required_version = ">= 0.12, < 0.13"
}

provider "aws" {
  region  = "us-east-1"
  version = "~> 2.0"
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_instance" "Rundeckv1" {
  ami                         = var.packer_built_rundeckv1_ami
  associate_public_ip_address = true
  instance_type               = "m4.large"

  key_name = "RunDeck-Playgrounds"
  vpc_security_group_ids = [
    aws_security_group.HTTP_SG_v1.id,
    aws_security_group.SSH_SG_v1.id,
    aws_security_group.Rundeck_SG_v1.id
  ]

  ebs_block_device {
    device_name           = "/dev/xvda"
    delete_on_termination = true
    volume_size           = 100
    volume_type           = "gp2"
  }

  user_data = <<-EOF
              #!/bin/bash
              echo "Working..." 
              EOF

  tags = {
    Name = "Rundeck Playground v1.4.4"
  }
}

resource "aws_security_group" "Rundeck_SG_v1" {
  name = "Rundeck Security Group"

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 4440
    to_port     = 4440
    protocol    = "tcp"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "HTTP_SG_v1" {
  name = "HTTP Security Group"

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "SSH_SG_v1" {
  name = "SSH Security Group"

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
