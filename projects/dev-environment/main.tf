# Main VPC - isolated virtual network for our infrastructure
resource "aws_vpc" "main" {
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
