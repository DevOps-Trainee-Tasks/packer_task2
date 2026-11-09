terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}
provider "aws" {
  region = local.aws_region
}

module "vpc" {
  source = "./modules/vpc"
  nat_gateway_public_subnet_index = 0
  name_prefix = local.project

cidr = "10.0.0.0/24"

  available_zones_list = [
    "us-east-1a",
    "us-east-1b"
  ]
  public_subnets = [
    "10.0.0.0/27",
    "10.0.0.32/27"
  ]
  private_servers_subnets = [
    "10.0.0.64/27",
    "10.0.0.96/27"
  ]
  private_db_subnets = [
    "10.0.0.128/27",
    "10.0.0.160/27"
  ]
}

module "sg" {
  source = "./modules/sg"
  main_vpc_id = module.vpc.vpc_id

  security_groups = {
    bastion_sg = {
      allow_all_egress = true
    }

    alb_sg = {
      allow_all_egress = true
    }

    "bastion-servers_sg" = {}

    "alb-llm_sg" = {
      allow_all_egress = true
    }

    rds_sg = {}
  }

  ingress_rules = {
    bastion_ssh = {
      target_group = "bastion_sg"
      ports = [22]
      cidr_ipv4 = var.my_ip
    }

    alb_http = {
      target_group = "alb_sg"
      ports = [80]
      cidr_ipv4 = var.my_ip
    }

    ssh_to_server = {
      target_group = "bastion-servers_sg"
      ports = [22]
      source_group = "bastion_sg"
    }

    alb_to_llm = {
      target_group = "alb-llm_sg"
      ports = [11434]
      source_group = "alb_sg"
    }

    llm_to_db = {
      target_group = "rds_sg"
      ports = [5432]
      source_group = "alb-llm_sg"
    }

    bastion_to_db = {
      target_group = "rds_sg"
      ports = [5432]
      source_group = "bastion_sg"
    }
  }
}

module "bastion" {
  source = "./modules/ec2"

  name_prefix = local.project
  ami_id = local.bastion_ami_id
  instance_type = local.bastion_instance_type
  subnet_id = module.vpc.public_subnet_ids[0]
  security_group_ids = [module.sg.security_group_ids["bastion_sg"]]
  key_name = local.bastion_key_name
  user_data = file("${path.root}/scripts/install_pg.sh")
}

module "alb" {
    source = "./modules/alb"

    name_prefix = local.project
    vpc_id = module.vpc.vpc_id
    public_subnet_ids = module.vpc.public_subnet_ids
    security_groups_id = module.sg.security_group_ids["alb_sg"]
    port_listener = local.http_port
    ollama_port = 11434
}

module "asg" {
  source = "./modules/asg"

  name_prefix = local.project
  ami_id = local.llm_ami_id
  instance_type = local.llm_instance_type
  key_name = local.bastion_key_name
  security_group_ids = [
    module.sg.security_group_ids["bastion-servers_sg"],
    module.sg.security_group_ids["alb-llm_sg"]
  ]
  private_subnet_ids = module.vpc.private_servers_subnet_ids
  user_data = filebase64("${path.root}/scripts/install_ollama.sh")
  target_group_arn = module.alb.target_group_arn
}

module "rds" {
    source = "./modules/rds"

    name_prefix = local.project
    private_db_subnet_ids = module.vpc.private_db_subnet_ids
    rds_security_group_id = module.sg.security_group_ids["rds_sg"]
    instance_class = local.rds_instance_class
    db_name = local.rds_db_name
    db_username = local.rds_db_username
    engine_version = local.rds_engine_version
    allocated_storage = local.rds_allocated_storage
}
