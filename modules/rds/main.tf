resource "aws_db_subnet_group" "db_subnet_group" {
  name = "${var.name_prefix}-db-subnets"
  subnet_ids = var.private_db_subnet_ids
}

resource "aws_db_instance" "rds" {
    instance_class = var.instance_class
    identifier = var.name_prefix
    engine = "postgres"
    engine_version = var.engine_version
    allocated_storage = var.allocated_storage
    db_name = var.db_name
    username = var.db_username
    manage_master_user_password = true
    skip_final_snapshot = true
    db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name
    vpc_security_group_ids = [var.rds_security_group_id]
}
