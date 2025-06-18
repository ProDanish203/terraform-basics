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

variable "db_pass" {
  description = "Password for database"
  type        = string
  sensitive   = true
}

# Specifying the backend configuration for Terraform workspaces
locals {
  environment = terraform.workspace
}

module "web_app" {
  source = "../../../modules/web-app-module"

  app_name        = "web-app-${local.environment}"
  bucket_prefix   = "web-app-${local.environment}-bucket"
  environment     = local.environment
  db_identifier   = "web-app-${local.environment}-db"
  db_username     = "danish"
  db_password     = var.db_pass # Must be greater than 8 characters
  create_dns_zone = terraform.workspace == "production" ? true : false
}
