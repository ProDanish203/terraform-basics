terraform {
  # backend "remote" {
  #   organization = "danish-siddiqui" # Terraform Cloud organization name

  #   workspaces {
  #     name = "terraform-basics" # Name of the workspace in Terraform Cloud
  #   }
  # }

  # backend "s3" {
  #   bucket         = "terraform-basics-aws"               # S3 bucket name for storing Terraform state
  #   key            = "terraform-basics/terraform.tfstate" # Key for the state file in the S3 bucket
  #   region         = "ap-south-1"                         # AWS region where the S3 bucket is located
  #   encrypt        = true                                 # Enable server-side encryption for the state file
  #   dynamodb_table = "terraform-basics-lock"              # DynamoDB table for state locking
  # }

  required_providers {
    aws = {
      source  = "hashicorp/aws" # Use the official AWS provider from HashiCorp Terraform Registry
      version = "~> 5.0"        # Specify the version of the AWS provider
    }
  }
}

provider "aws" {
  region = "ap-south-1" # Set the AWS region to Asia Pacific (Mumbai)
}

resource "aws_instance" "terraform-basic-ec2" {
  ami           = "ami-02521d90e7410d9f0" # Image name for Ubuntu 22.04 in ap-south-1
  instance_type = "t2.micro"              # Free tier eligible instance type
}

resource "aws_s3_bucket" "terraform-basics-s3" {
  bucket        = "terraform-basics-aws" # Name of the S3 bucket
  force_destroy = true                   # Allow deletion of the bucket even if it contains objects
}

resource "aws_dynamodb_table" "terraform-basics-lock" {
  name         = "terraform-basics-lock" # Name of the DynamoDB table for state locking
  billing_mode = "PAY_PER_REQUEST"       # Use on-demand billing mode
  hash_key     = "LockID"                # Primary key for the table

  attribute {
    name = "LockID" # Attribute name for the primary key
    type = "S"      # Attribute type (String)
  }
}
