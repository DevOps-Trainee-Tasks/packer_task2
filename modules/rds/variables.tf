variable "name_prefix" {
    type = string
}

variable "private_db_subnet_ids" {
  type = list(string)
}

variable "rds_security_group_id" {
  type = string
}

variable "db_name" {
    type = string
}

variable "db_username" {
    type = string
}

variable "engine_version" {
    type = string
}

variable "allocated_storage" {
    type = number
}

variable "instance_class" {
    type = string
}

