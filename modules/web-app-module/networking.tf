data "aws_vpc" "default_vpc" {
  default = true
}

data "aws_subnets" "default_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default_vpc.id]
  }
}

data "aws_subnet" "default_subnet" {
  id = data.aws_subnets.default_subnets.ids[0]
}

data "aws_subnet" "default_subnet_2" {
  id = data.aws_subnets.default_subnets.ids[1]
}

# Create a security group to allow HTTP traffic
resource "aws_security_group" "instances" {
  name = "${var.app_name}-${var.environment}-instances-sg"
}

resource "aws_security_group_rule" "allow_http_inbound" {
  type              = "ingress"
  security_group_id = aws_security_group.instances.id

  from_port   = 8080
  to_port     = 8080
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"] # Allow HTTP traffic from anywhere
  description = "Allow HTTP traffic on port 8080"
}
