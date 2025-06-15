terraform {
  #   backend "s3" {
  #     bucket         = "terraform-backend"
  #     key            = "terraform/terraform.tfstate"
  #     region         = "ap-south-1"
  #     encrypt        = true
  #     dynamodb_table = "terraform-lock"
  #   }

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

resource "aws_s3_bucket" "terraform-s3" {
  bucket        = "terraform-backend"
  force_destroy = true
}

resource "aws_dynamodb_table" "terraform-lock" {
  name         = "terraform-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
