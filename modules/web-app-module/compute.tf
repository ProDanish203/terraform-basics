resource "aws_instance" "instance_1" {
  ami           = var.ami
  instance_type = var.instance_type

  security_groups = [aws_security_group.instances.name]

  user_data = <<-EOF
    #!/bin/bash
    echo "Hello, World!" > /var/www/html/index.html
    python3 -m http.server 80 --bind & 
    EOF

  tags = {
    Name = "${var.app_name}-${var.environment}-instance-1"
  }
}

resource "aws_instance" "instance_2" {
  ami           = var.ami
  instance_type = var.instance_type

  security_groups = [aws_security_group.instances.name]

  user_data = <<-EOF
    #!/bin/bash
    echo "Hello, World from instance 2!" > /var/www/html/index.html
    python3 -m http.server 80 --bind & 
    EOF

  tags = {
    Name = "${var.app_name}-${var.environment}-instance-1"
  }
}
