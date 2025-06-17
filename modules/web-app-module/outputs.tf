output "db_instance_endpoint" {
  value = aws_db_instance.db_instance.address
}

output "instance_1_ip_address" {
  value = aws_instance.instance_1.public_ip
}

output "instance_2_ip_address" {
  value = aws_instance.instance_2.public_ip
}
