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

  iam_instance_profile = aws_iam_instance_profile.SSM_Profile.name

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

resource "aws_iam_role" "AssumeRole" {
  name = "AssumeRole"

  assume_role_policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "ec2.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
      }
    ]
  }
  EOF
}

resource "aws_iam_instance_profile" "SSM_Profile" {
  name = "SSM_Profile"
  role = aws_iam_role.AssumeRole.name
}

resource "aws_iam_role_policy" "SSM_Policy" {
  name = "SSM_Policy"
  role = aws_iam_role.AssumeRole.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ssm:DescribeAssociation",
                "ssm:GetDeployablePatchSnapshotForInstance",
                "ssm:GetDocument",
                "ssm:DescribeDocument",
                "ssm:GetManifest",
                "ssm:GetParameter",
                "ssm:GetParameters",
                "ssm:ListAssociations",
                "ssm:ListInstanceAssociations",
                "ssm:PutInventory",
                "ssm:PutComplianceItems",
                "ssm:PutConfigurePackageResult",
                "ssm:UpdateAssociationStatus",
                "ssm:UpdateInstanceAssociationStatus",
                "ssm:UpdateInstanceInformation"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ssmmessages:CreateControlChannel",
                "ssmmessages:CreateDataChannel",
                "ssmmessages:OpenControlChannel",
                "ssmmessages:OpenDataChannel"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2messages:AcknowledgeMessage",
                "ec2messages:DeleteMessage",
                "ec2messages:FailMessage",
                "ec2messages:GetEndpoint",
                "ec2messages:GetMessages",
                "ec2messages:SendReply"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}
