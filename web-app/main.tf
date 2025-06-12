terraform {
  backend "remote" {
    organization = "danish-siddiqui"

    workspaces {
      name = "terraform-basics"
    }
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

# Creating two EC2 instances
resource "aws_instance" "instance_1" {
  ami             = "ami-02521d90e7410d9f0"
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.backend-instances.name]
  user_data       = <<-EOF
              #!/bin/bash
              echo "Hello, World!" > index.html
              python3 -m http.server 80 &
            EOF
}

resource "aws_instance" "instance_2" {
  ami             = "ami-02521d90e7410d9f0"
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.backend-instances.name]
  user_data       = <<-EOF
              #!/bin/bash
              echo "Hello, World from server 2!" > index.html
              python3 -m http.server 80 &
            EOF
}

# Specify the Virtual Private Cloud (VPC) and subnet within that vpc for the instances
# The data block is used to reference existing resources
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
resource "aws_security_group" "backend-instances" {
  name = "backend-instances-sg"
}

# Adding rules to the security group
resource "aws_security_group_rule" "allow_http_inbound" {
  type              = "ingress"
  security_group_id = aws_security_group.backend-instances.id

  from_port   = 8080
  to_port     = 8080
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"] # Allow HTTP traffic from anywhere
  description = "Allow HTTP traffic on port 8080"
}

# Configure the Load Balancer
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: Page not found"
      status_code  = 404
    }
  }
}

resource "aws_lb_target_group" "instances" {
  name     = "example-target-group"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default_vpc.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

# Attach the instances to the target group
resource "aws_lb_target_group_attachment" "instance_1_attachment" {
  target_group_arn = aws_lb_target_group.instances.arn
  target_id        = aws_instance.instance_1.id
  port             = 8080
}

resource "aws_lb_target_group_attachment" "instance_2_attachment" {
  target_group_arn = aws_lb_target_group.instances.arn
  target_id        = aws_instance.instance_2.id
  port             = 8080
}

resource "aws_lb_listener_rule" "instances" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.instances.arn
  }
}

# Security group for the load balancer
resource "aws_security_group" "load_balancer_sg" {
  name        = "load-balancer-sg"
  description = "Security group for the load balancer"
}

resource "aws_security_group_rule" "allow_inbound_http_from_lb" {
  type              = "ingress"
  security_group_id = aws_security_group.load_balancer_sg.id

  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"] # Allow HTTP traffic from anywhere
  description = "Allow HTTP traffic on port 80"
}


resource "aws_security_group_rule" "allow_outbound_http_to_instances" {
  type              = "egress" # for outbound rules
  security_group_id = aws_security_group.load_balancer_sg.id

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  description = "Allow all outbound traffic"
}

resource "aws_lb" "load_balancer" {
  name               = "web-app-lb"
  load_balancer_type = "application"
  subnets = [
    data.aws_subnet.default_subnet.id,
    data.aws_subnet.default_subnet_2.id
  ]
  security_groups = [aws_security_group.load_balancer_sg.id]

  enable_deletion_protection = false

  tags = {
    Name = "web-app-lb"
  }
}


# Creating a database instance
resource "aws_db_instance" "web_app_db" {
  allocated_storage   = 20
  storage_type        = "standard"
  engine              = "postgres"
  engine_version      = "17.4-R1"
  instance_class      = "db.t4g.micro"
  identifier          = "web-app-db"
  username            = "admin"
  password            = "password1234"
  db_name             = "webappdb"
  skip_final_snapshot = true

  tags = {
    Name = "web-app-db"
  }
}
