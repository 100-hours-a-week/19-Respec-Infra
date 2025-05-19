resource "aws_db_subnet_group" "this" {
  name       = "${var.name}-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "${var.name}-rds-subnet-group"
  }
}

resource "aws_db_instance" "this" {
  identifier              = var.name
  engine                  = var.engine
  engine_version          = var.engine_version
  instance_class          = var.instance_class
  username                = var.username
  password                = var.password
  db_name                 = var.db_name
  allocated_storage       = var.allocated_storage
  max_allocated_storage   = var.max_allocated_storage
  storage_type            = var.storage_type
  multi_az                = var.multi_az
  storage_encrypted       = var.storage_encrypted
  kms_key_id              = var.kms_key_id
  vpc_security_group_ids  = var.security_group_ids
  db_subnet_group_name    = aws_db_subnet_group.this.name
  backup_retention_period = var.backup_retention_period
  backup_window           = var.backup_window
  maintenance_window      = var.maintenance_window
  deletion_protection     = var.deletion_protection
  publicly_accessible     = false
  monitoring_interval     = var.monitoring_interval
  enabled_cloudwatch_logs_exports = var.cloudwatch_logs_exports

  tags = {
    Environment = var.environment
    Name        = var.name
  }
}
