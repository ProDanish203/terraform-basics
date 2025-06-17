terraform {
  backend "s3" {
    bucket         = "terraform-backend"
    key            = "terraform/terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true
    dynamodb_table = "terraform-lock"
  }

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

variable "db_pass_1" {
  description = "Password for the first database"
  type        = string
  sensitive   = true
}

variable "db_pass_2" {
  description = "Password for the second database"
  type        = string
  sensitive   = true
}

# using the created web-app module to deploy two web applications
# Each application has its own S3 bucket, RDS instance, and EC2 instances.
# Dev environment
module "web_app_1" {
  source = "../web-app-module"

  app_name        = "web-app"
  bucket_prefix   = "web-app-dev-bucket"
  environment     = "dev"
  db_identifier   = "web-app-dev-db"
  db_username     = "danish"
  db_password     = var.db_pass_1 # Must be greater than 8 characters
  create_dns_zone = false
}

# Production environment
module "web_app_2" {
  source = "../web-app-module"

  app_name        = "web-app"
  bucket_prefix   = "web-app-prod-bucket"
  environment     = "production"
  db_identifier   = "web-app-prod-db"
  db_username     = "danish"
  db_password     = var.db_pass_2 # Must be greater than 8 characters
  create_dns_zone = false
}
