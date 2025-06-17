# General variables
variable "region" {
  description = "The AWS region to deploy the web application."
  type        = string
  default     = "ap-south-1" # (Mumbai region)
}

variable "app_name" {
  description = "Name of the web application."
  type        = string
  default     = "web-app"
}

variable "environment" {
  description = "Environment for the web application (e.g., dev, staging, prod)."
  type        = string
  default     = "dev"
  
  validation {
    condition = contains(["production", "dev", "staging"], var.environment)
    error_message = "Environment must be one of: Production, dev, or staging."
  }
}

# EC2 variables
variable "ami" {
  description = "AMI ID for the EC2 instances."
  type        = string
  default     = "ami-02521d90e7410d9f0"
}

variable "instance_type" {
  description = "Instance type for the EC2 instances."
  type        = string
  default     = "t2.micro"
}

# S3 variables
variable "bucket_prefix" {
  description = "Prefix for the S3 bucket name."
  type        = string
  default     = "web-app-bucket"
}


# Route53 variables
variable "create_dns_zone" {
  description = "Flag to create a Route53 DNS zone."
  type        = bool
  default     = false
}

variable "domain_name" {
  description = "Domain name for the Route53 DNS zone."
  type        = string
  default     = "blahblahblah.com"
}


# RDS variables
variable "db_instance_class" {
  description = "Instance class for the RDS database."
  type        = string
  default     = "db.t4g.micro"
}

variable "db_engine" {
  description = "Database engine for the RDS instance."
  type        = string
  default     = "postgres"
}

variable "db_engine_version" {
  description = "Version of the database engine."
  type        = string
  default     = "17"
}

variable "db_allocated_storage" {
  description = "Allocated storage for the RDS database in GB."
  type        = number
  default     = 20
}

variable "db_identifier" {
  description = "Identifier for the RDS database instance."
  type        = string
  default     = "mydb"
}

variable "db_username" {
  description = "Username for the RDS database."
  type        = string
  default     = "danish"
}

variable "db_password" {
  description = "Password for the RDS database."
  type        = string
  sensitive   = true
}
