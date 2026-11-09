variable "name_prefix" {
    type = string
}

variable "vpc_id" {
    type = string
}

variable "public_subnet_ids" {
    type = list(string)
}

variable "security_groups_id" {
    type = string
}

variable "port_listener" {
    type = number
}

variable "ollama_port" {
    type = number
}