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

resource "aws_instance" "terraform-basic-ec2" {
  ami           = "ami-02521d90e7410d9f0"
  instance_type = "t2.micro"
}
