resource "aws_db_instance" "db_instance" {
  allocated_storage   = var.db_allocated_storage
  storage_type        = "standard"
  engine              = var.db_engine
  engine_version      = var.db_engine_version
  instance_class      = var.db_instance_class
  identifier          = var.db_identifier
  username            = var.db_username
  password            = var.db_password
  skip_final_snapshot = true
}
