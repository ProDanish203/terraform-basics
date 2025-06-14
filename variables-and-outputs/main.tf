terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

# Defining local variables
locals {
  extra_tag = "extra_value"
}


resource "aws_instance" "instance" {
  ami           = var.ami
  instance_type = var.instance_type

  tags = {
    Name     = var.instance_name
    ExtraTag = local.extra_tag
  }
}

# Applying variables at runtime
# terraform apply -var="db_user=myuser" -var="db_pass=mypassword"

resource "aws_db_instance" "db_instance" {
  allocated_storage   = 20
  storage_type        = "gp2"
  engine              = "postgres"
  engine_version      = "17"
  instance_class      = "db.t4g.micro"
  identifier          = "mydb"
  username            = var.db_user
  password            = var.db_pass
  skip_final_snapshot = true
}
