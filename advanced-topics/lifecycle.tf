# Meta-arguments
# Lifecycle
# - A set of meta-arguments to control terraform's behavior regarding resource creation, updates, and deletions.
# - Useful for managing how resources are created, updated, or deleted.

resource "aws_instance" "example" {
  ami           = "ami-02521d90e7410d9f0"
  instance_type = "t2.micro"

  lifecycle {
    # Can help with zero-downtime deployments
    create_before_destroy = true
    # Prevents the resource from being destroyed
    prevent_destroy = true

    # Ignore changes to the specified attributes
    ignore_changes = [
      tags["Name"]
    ]
  }

  tags = {
    Name = "example-instance"
  }
}
