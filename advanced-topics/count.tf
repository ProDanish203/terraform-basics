# Meta-arguments
# Count
# - Allows for creation of multiple resources of the same type from a single resource block.
# - useful for scaling resources or creating multiple similar resources without duplicating code.
resource "aws_instance" "example" {
  count = 3 # Creates 3 instances

  ami           = "ami-02521d90e7410d9f0"
  instance_type = "t2.micro"

  tags = {
    Name = "ExampleInstance-${count.index + 1}"
  }
}
