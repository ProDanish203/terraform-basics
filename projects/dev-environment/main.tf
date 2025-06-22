# Main VPC - isolated virtual network for our infrastructure
resource "aws_vpc" "main" {
  # The CIDR block defines the IP address range for the VPC
  # This CIDR block is private and not routable on the internet
  cidr_block           = "10.123.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "dev"
  }
}

# Public subnet - hosts resources that need internet access
resource "aws_subnet" "dev_public_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.123.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "ap-south-1a"

  tags = {
    Name = "dev-public"
  }
}

# Internet Gateway - allows VPC resources to access the internet
resource "aws_internet_gateway" "dev_internet_gateway" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "dev-igw"
  }
}

# Route table - defines routing rules for network traffic
resource "aws_route_table" "dev_public_route_table" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "dev-public-route-table"
  }
}

# Default route - directs all internet traffic through the IGW
resource "aws_route" "dev_default_route" {
  route_table_id         = aws_route_table.dev_public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.dev_internet_gateway.id
}

# Route table association - connects the public subnet to the route table
resource "aws_route_table_association" "dev_public_subnet_association" {
  subnet_id      = aws_subnet.dev_public_subnet.id
  route_table_id = aws_route_table.dev_public_route_table.id
}


resource "aws_security_group" "dev_public_sg" {
  name        = "dev-public-sg"
  description = "Security group for public resources in dev environment"
  vpc_id      = aws_vpc.main.id
}

# Security group rules - control inbound and outbound traffic for the public security group
# We are using only ipv4 and not ipv6 because the VPC is configured with an IPv4 CIDR block
# resource "aws_vpc_security_group_ingress_rule" "allow_ipv4" {
#   security_group_id = aws_security_group.dev_public_sg.id
#   from_port         = 443 # Allow HTTPS traffic, use 0 for all ports
#   ip_protocol       = "tcp"
#   to_port           = 443                     # Allow HTTPS traffic
#   cidr_ipv4         = aws_vpc.main.cidr_block # Allow HTTPS traffic from the VPC CIDR block
#   # use your own ip address to allow access from your machine
#   # cidr_ipv4         = "<your-ip-address>/32"
#   description = "Allow HTTPS traffic from VPC CIDR block"
# }

resource "aws_vpc_security_group_ingress_rule" "allow_ipv4_test" {
  security_group_id = aws_security_group.dev_public_sg.id
  ip_protocol       = "-1" # -1 means all protocols
  cidr_ipv4         = "0.0.0.0/0"
  description       = "Allow all traffic from anywhere"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_outbound_ipv4" {
  security_group_id = aws_security_group.dev_public_sg.id
  # from_port         = 0    # Allow all outbound traffic
  ip_protocol = "-1" # -1 means all protocols
  # to_port           = 0
  cidr_ipv4 = "0.0.0.0/0" # Allow all outbound traffic to the internet
}
