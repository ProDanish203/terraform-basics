terraform {
  backend "remote" {
    organization = "danish-siddiqui" # Terraform Cloud organization name

    workspaces {
      name = "terraform-basics" # Name of the workspace in Terraform Cloud
    }
  }
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
