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

module "web_app" {
  source = "../../../modules/web-app-module"

  app_name        = "web-app-staging"
  bucket_prefix   = "web-app-staging-bucket"
  environment     = "staging"
  db_identifier   = "web-app-staging-db"
  db_username     = "danish"
  db_password     = var.db_pass # Must be greater than 8 characters
  create_dns_zone = false
}
