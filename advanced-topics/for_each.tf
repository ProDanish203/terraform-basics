# Meta-arguments
# For Each
# - Allows for creating multiple resources based on a list or map.
# - Allows more control over resource creation compared to `count`.
locals {
  subnet_ids = toset([
    "subnet-0a1b2c3d4e5f6g7h8",
    "subnet-0h7g6f5e4d3c2b1a0"
  ])
}

resource "aws_instance" "example" {
  for_each = local.subnet_ids

  ami           = "ami-02521d90e7410d9f0"
  instance_type = "t2.micro"
  subnet_id     = each.key

  tags = {
    Name = "Server-${each.key}"
  }
}
