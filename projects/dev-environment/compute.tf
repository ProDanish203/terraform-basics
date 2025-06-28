# Create a key-pair to access the instance
resource "aws_key_pair" "ssh_key" {
  key_name   = "dev-ssh-key"
  public_key = file("~/.ssh/tfkey.pub")
  tags = {
    Name = "dev-ssh-key"
  }
}

# Create the EC2 instance
resource "aws_instance" "dev_instance" {
  ami           = var.ami
  instance_type = var.instance_type

  # for SSH access
  key_name = aws_key_pair.ssh_key.id
  # It is because the security group is associated with the VPC
  vpc_security_group_ids = [aws_security_group.dev_public_sg.id]
  subnet_id              = aws_subnet.dev_public_subnet.id

  # Storage
  root_block_device {
    volume_size = 10
  }

  tags = {
    Name = "dev-instance"
  }

  user_data = file("userdata.sh")

  provisioner "local-exec" {
    command = templatefile("windows-ssh-config.sh.tpl", {
      hostname     = self.public_ip,
      user         = "ubuntu",
      identityfile = "~/.ssh/tfkey"
    })
    interpreter = ["Powershell", "-Command"]
  }
}
