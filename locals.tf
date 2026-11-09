locals {
    aws_region = "us-east-1"
    project = "manual-task1"
    http_port = 80
    bastion_ami_id = "ami-07ad3ac74660c86c1"
    bastion_instance_type = "t3.micro"
    bastion_key_name  = "task1-key"
    llm_ami_id = local.bastion_ami_id
    llm_instance_type = "m7i-flex.large"
    rds_instance_class = "db.t4g.micro"
    rds_db_name = "manualdb"
    rds_db_username = "dbadmin"
    rds_engine_version = "16"
    rds_allocated_storage = 20
}