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

resource "aws_instance" "RunDeckv3" {
  ami                         = var.packer_built_rundeckv3_ami
  associate_public_ip_address = true
  instance_type               = "t3.small"

  key_name = "RunDeck-Playgrounds"
  vpc_security_group_ids = [
    aws_security_group.HTTP_SG.id,
    aws_security_group.SSH_SG.id,
    aws_security_group.RunDeck_SG.id
  ]

  tags = {
    Name = "RunDeck Playgrounds"
  }
}

resource "aws_security_group" "RunDeck_SG" {
  name = "RunDeck Security Group"

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 4440
    to_port     = 4440
    protocol    = "tcp"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "HTTP_SG" {
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

resource "aws_security_group" "SSH_SG" {
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
