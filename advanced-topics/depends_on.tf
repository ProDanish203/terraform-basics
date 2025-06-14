# Meta-Arguments
# Depends On
# - Terraform automatically manages dependencies between resources based on references.
# - The `depends_on` argument is used to explicitly define dependencies between resources.

resource "aws_iam_role" "example_role" {
  name               = "example-role"
  assume_role_policy = ""
}

resource "aws_iam_instance_profile" "example_profile" {
  role = aws_iam_role.example_role.name
}

resource "aws_iam_role_policy" "example_role_policy" {
  name = "example-role-policy"
  role = aws_iam_role.example_role.id
  policy = jsonencode({
    "Statement" = [{
      "Action" = "s3:*"
      "Effect" = "Allow"
    }]
  })
}

resource "aws_instance" "example_instance" {
  ami           = "ami-02521d90e7410d9f0"
  instance_type = "t2.micro"

  iam_instance_profile = aws_iam_instance_profile.example_profile

  # This instance depends on the IAM role policy being created first
  depends_on = [aws_iam_role_policy.example_role_policy]
}
