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

# Using the third-party module for Consul
# This module deploys a Consul cluster on AWS using the specified AMI, spot price, SSH key, and VPC.
module "consul" {
  source  = "hashicorp/consul/aws"
  version = "0.11.0"
  # insert the 4 required variables here
  # ami_id       = ""
  # spot_price   = ""
  # ssh_key_name = ""
  # vpc_id       = ""
  # cluster_name = "consul-cluster"
}
