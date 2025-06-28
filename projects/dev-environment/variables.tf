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
