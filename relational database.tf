// Create the RDS instance
resource "aws_db_instance" "rds" {
  identifier                 = "${var.proj_name_prefix}-mysql-db"
  engine                     = "mysql"
  engine_version             = var.proj_db["engine_version"]
  auto_minor_version_upgrade = true
  instance_class             = var.proj_db["instance_class"]
  username                   = var.proj_db["username"] //security could be improved by secret manager
  password                   = var.proj_db["password"]
  allocated_storage          = var.proj_db["allocated_storage"]
  max_allocated_storage      = var.proj_db["max_allocated_storage"]
  storage_type               = var.proj_db["storage_type"]
  vpc_security_group_ids     = [aws_security_group.proj_rds_sg.id]
  db_subnet_group_name       = aws_db_subnet_group.proj_subnet_group.name
  skip_final_snapshot        = var.proj_db["skip_final_snapshot"]
  backup_retention_period    = var.proj_db["backup_retention_period"]

  tags = {
    Name = var.proj_tag
  }
}

//Create db subnet group
resource "aws_db_subnet_group" "proj_subnet_group" {
  name       = "freeland-subnet-group"
  subnet_ids = local.subnet_ids

  tags = {
    Name = var.proj_tag
  }
}

//endpoint of rds with port number
output "rds_endpoint" {
  value = aws_db_instance.rds.endpoint
}
