variable "instance_name" {
  description = "Name of EC2 instance"
  type        = string
}

variable "ami" {
  description = "AWS machine image to use for EC2 instance"
  type        = string
  default     = "ami-02521d90e7410d9f0" 
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "db_user" {
  description = "username for database"
  type        = string
  default     = "danish"
}

variable "db_pass" {
  description = "password for database"
  type        = string
  sensitive   = true
}